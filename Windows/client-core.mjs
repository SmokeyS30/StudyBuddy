const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export function isLoopback(hostname) {
  return ["127.0.0.1", "localhost", "[::1]"].includes(hostname.toLowerCase());
}

export function acquireStorage(getStorage) {
  try { return getStorage() ?? null; }
  catch { return null; }
}

export async function sendChatTurn(messages, content, send) {
  const question = String(content).trim();
  if (!question) throw new Error("A follow-up question is required.");
  const userMessage = { role: "user", content: question };
  const transcript = [...messages.map((message) => ({ ...message })), userMessage];
  const reply = await send(transcript);
  messages.push(userMessage, { role: "assistant", content: reply.reply });
  return reply;
}

export function readStoredValue(storage, key, fallback = "") {
  try { return storage.getItem(key) ?? fallback; }
  catch { return fallback; }
}

export function writeStoredValue(storage, key, value) {
  try { storage.setItem(key, String(value)); return true; }
  catch { return false; }
}

export function readStoredArray(storage, key) {
  try {
    const value = JSON.parse(storage.getItem(key) || "[]");
    return Array.isArray(value) ? value : [];
  } catch { return []; }
}

export function writeStoredArray(storage, key, entries) {
  try { storage.setItem(key, JSON.stringify(entries)); return true; }
  catch { return false; }
}

export function prependStoredArray(storage, key, entry, limit = 50) {
  if (!Number.isInteger(limit) || limit < 1) throw new Error("A positive history limit is required.");
  const entries = [entry, ...readStoredArray(storage, key)].slice(0, limit);
  return { entries, persisted: writeStoredArray(storage, key, entries) };
}

export function toggleStoredString(storage, key, value, enabled, currentEntries) {
  if (typeof value !== "string" || value.length === 0) throw new Error("A stored task ID is required.");
  const previous = Array.isArray(currentEntries) ? currentEntries : readStoredArray(storage, key);
  const ids = new Set(previous.filter((item) => typeof item === "string" && item.length > 0));
  if (enabled) ids.add(value); else ids.delete(value);
  const entries = [...ids];
  return { entries, persisted: writeStoredArray(storage, key, entries) };
}

export function validateServerURL(value) {
  let url;
  try { url = new URL(String(value).trim()); } catch { throw new Error("Enter a complete server URL."); }
  if (url.username || url.password || url.search || url.hash || url.pathname !== "/") {
    throw new Error("Use only the server origin, without credentials, path, or query.");
  }
  if (url.protocol !== "https:" && !(url.protocol === "http:" && isLoopback(url.hostname))) {
    throw new Error("A remote server must use HTTPS and provide an authenticated session.");
  }
  return url.origin;
}

export function validateCatalog(catalog) {
  if (![1, 2].includes(catalog?.schemaVersion) || !Array.isArray(catalog.exams) || catalog.exams.length === 0) {
    throw new Error("The bundled catalog is missing or has an unsupported schema.");
  }
  for (const exam of catalog.exams) {
    if (!exam.id || !exam.code || !Array.isArray(exam.domains) || !Array.isArray(exam.practiceQuestions)) {
      throw new Error("The bundled catalog has an invalid exam.");
    }
  }
  return catalog;
}

export function chooseQuestions(exam, domainId, count = 10, random = Math.random) {
  const source = exam.practiceQuestions.filter((q) => !domainId || q.domainID === domainId);
  const questions = [...source];
  for (let i = questions.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1));
    [questions[i], questions[j]] = [questions[j], questions[i]];
  }
  return questions.slice(0, Math.min(count, questions.length));
}

export function scoreQuiz(exam, questions, selectedIndexes) {
  if (!questions.length || questions.length !== selectedIndexes.length) throw new Error("Quiz is incomplete.");
  const byDomain = new Map();
  let correct = 0;
  const results = questions.map((question, index) => {
    const choice = selectedIndexes[index];
    if (!Number.isInteger(choice) || choice < 0 || choice >= question.choices.length) {
      throw new Error("Answer every question before submitting.");
    }
    const right = choice === question.answerIndex;
    if (right) correct++;
    const domain = byDomain.get(question.domainID) || { correct: 0, total: 0 };
    domain.total++;
    if (right) domain.correct++;
    byDomain.set(question.domainID, domain);
    return { question, choice, correct: right };
  });
  const domainPercents = Object.fromEntries([...byDomain].map(([id, v]) => [id, v.correct / v.total]));
  const weakDomains = [...byDomain].filter(([, v]) => v.correct < v.total).map(([id]) => id);
  return { exam, correct, total: questions.length, percent: correct / questions.length, domainPercents, weakDomains, results };
}

export function attemptUpload(studentId, score) {
  if (!UUID.test(studentId)) throw new Error("An authenticated profile is required.");
  return {
    studentId,
    examID: score.exam.id,
    attempt: {
      title: `${score.exam.code} Windows practice`,
      percent: score.percent,
      domainPercents: score.domainPercents,
      guessedCount: 0,
      flaggedCount: 0
    },
    weakDomains: score.weakDomains.map((id) => score.exam.domains.find((domain) => domain.id === id)?.title || id)
  };
}

export function mistakeContext(studentId, score, result) {
  const domain = score.exam.domains.find((item) => item.id === result.question.domainID);
  return {
    studentId,
    examID: score.exam.id,
    examName: score.exam.name,
    examCode: score.exam.code,
    domainTitle: domain?.title || result.question.domainID,
    objective: domain?.objectives?.[0] || domain?.focus || "General review",
    wasCorrect: result.correct,
    confidence: "Not marked",
    isPerformanceBased: false,
    itemKind: "singleChoice",
    questionPrompt: result.question.prompt,
    targetStudyMinutes: 30
  };
}

export function createApiClient(origin, { fetchImpl = fetch, bearerToken = "" } = {}) {
  const base = validateServerURL(origin);
  const local = isLoopback(new URL(base).hostname);
  async function request(path, payload) {
    const headers = { Accept: "application/json" };
    if (payload !== undefined) headers["Content-Type"] = "application/json";
    if (bearerToken) headers.Authorization = `Bearer ${bearerToken}`;
    const response = await fetchImpl(new URL(path, base), {
      method: payload === undefined ? "GET" : "POST",
      credentials: "include",
      headers,
      body: payload === undefined ? undefined : JSON.stringify(payload),
      signal: AbortSignal.timeout(10000)
    });
    let data;
    try { data = await response.json(); } catch { throw new Error(`Server returned unreadable data (${response.status}).`); }
    if (!response.ok) {
      const error = new Error(data.error || `Server returned ${response.status}.`);
      error.statusCode = response.status;
      throw error;
    }
    return data;
  }
  return {
    local,
    health: () => request("/health"),
    session: async () => {
      let session;
      try { session = await request("/api/session"); }
      catch (error) {
        if (local && error.statusCode === 404) return { authenticated: false, studentId: null };
        throw error;
      }
      if (session.authenticated === true && UUID.test(session.studentId || "")) return session;
      if (local && session.authenticated === false) return session;
      throw new Error("The server did not provide a valid authenticated student session.");
    },
    attempt: (upload) => request("/api/learning/attempt", upload),
    studyPath: (payload) => request("/api/study-path", payload),
    tutor: (context) => request("/api/tutor/mistake", context),
    chat: (context, messages) => request("/api/tutor/chat", { context, messages })
  };
}
