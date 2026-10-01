import {
  acquireStorage, attemptUpload, chooseQuestions, createApiClient, mistakeContext,
  prependStoredArray, readStoredArray, readStoredValue, scoreQuiz,
  sendChatTurn, toggleStoredString, validateCatalog, writeStoredValue
} from "./client-core.mjs";

const $ = (id) => document.getElementById(id);
const state = { catalog: null, exam: null, api: null, studentId: null, score: null };
const historyKey = "prepnexus-windows-history-v1";
const completedKey = "prepnexus-windows-tasks-v1";
const originKey = "prepnexus-windows-server-origin-v1";
const localStudentKey = "prepnexus-windows-local-student-v1";
const browserStorage = () => acquireStorage(() => window.localStorage);

function element(tag, content, className) {
  const node = document.createElement(tag);
  if (content !== undefined) node.textContent = String(content);
  if (className) node.className = className;
  return node;
}

function clearWork() { $("work-area").replaceChildren(); }
function message(text, kind = "") {
  const p = element("p", text, kind);
  $("work-area").append(p);
  return p;
}
function renderHistory(savedEntries = readStoredArray(browserStorage(), historyKey)) {
  const entries = savedEntries.filter((entry) => entry && typeof entry === "object" && !Array.isArray(entry));
  $("history").replaceChildren(...(entries.length
    ? entries.map((entry) => element("li", `${entry.when} · ${entry.code}: ${entry.correct}/${entry.total} · ${entry.sync}`))
    : [element("li", "No completed quiz yet.")]));
}
function addHistory(entry) {
  const result = prependStoredArray(browserStorage(), historyKey, entry, 50);
  renderHistory(result.entries);
  if (!result.persisted) {
    message("This attempt is visible now, but browser storage could not save its history for the next visit.", "error");
  }
}

function showExam() {
  state.exam = state.catalog.exams.find((e) => e.id === $("exam-select").value) || state.catalog.exams[0];
  const domains = state.exam.domains;
  $("domain-select").replaceChildren(new Option("All domains", ""), ...domains.map((d) => new Option(`${d.title} (${d.weight}%)`, d.id)));
  $("exam-summary").textContent = state.exam.summary;
  const source = $("exam-source");
  source.replaceChildren();
  const meta = state.exam.certification;
  source.append(`${state.exam.disclaimer} · ${meta?.examVersion || ""} · Status checked ${meta?.statusAsOf || "unknown"}. `);
  if (meta?.officialObjectivesURL) {
    const link = element("a", "Official objectives");
    link.href = meta.officialObjectivesURL;
    link.target = "_blank";
    link.rel = "noopener noreferrer";
    source.append(link);
  }
  clearWork();
}

async function connect(event) {
  event.preventDefault();
  $("connection-detail").textContent = "Connecting…";
  $("connection-status").textContent = "Connecting";
  state.api = null;
  state.studentId = null;
  try {
    const candidate = createApiClient($("server-url").value, { bearerToken: $("gateway-token").value.trim() });
    const [health, session] = await Promise.all([candidate.health(), candidate.session()]);
    if (health.ok !== true || (!candidate.local && !health.authenticatedStudentIdentityRequired)) {
      throw new Error("Server identity policy does not match the selected client mode.");
    }
    if (health.appAttest?.mode === "enforce") {
      throw new Error("This server requires Apple App Attest, which this Windows browser cannot provide.");
    }
    let studentId = session.studentId;
    let localProfileWarning = "";
    if (candidate.local && !studentId) {
      studentId = readStoredValue(browserStorage(), localStudentKey);
      if (!studentId) {
        studentId = crypto.randomUUID();
        if (!writeStoredValue(browserStorage(), localStudentKey, studentId)) {
          localProfileWarning = " Local test profile is temporary because browser storage is unavailable.";
        }
      }
    }
    state.api = candidate;
    state.studentId = studentId;
    const originRemembered = writeStoredValue(browserStorage(), originKey, $("server-url").value.trim());
    $("connection-status").textContent = session.authenticated ? "Authenticated session" : "Local test session";
    const originWarning = originRemembered ? "" : " Server URL could not be saved in this browser.";
    $("connection-detail").textContent = `Connected to ${health.service} ${health.version}. Tutor source: ${health.tutorProvider || (health.openaiConfigured ? "configured API" : "deterministic fallback")}. Profile ${studentId}.${originWarning}${localProfileWarning}`;
  } catch (error) {
    $("connection-status").textContent = "Not connected";
    $("connection-detail").textContent = error.message;
  }
}

async function sendAttempt(score) {
  if (!state.api || !state.studentId) throw new Error("Connect to the study server first.");
  return state.api.attempt(attemptUpload(state.studentId, score));
}

function startQuiz() {
  clearWork();
  const questions = chooseQuestions(state.exam, $("domain-select").value);
  if (!questions.length) { message("There are no practice questions for this focus domain."); return; }
  const form = element("form");
  form.id = "quiz-form";
  questions.forEach((question, index) => {
    const field = element("fieldset", undefined, "question");
    field.append(element("legend", `${index + 1}. ${question.prompt}`));
    question.choices.forEach((choice, choiceIndex) => {
      const label = element("label");
      const input = element("input");
      input.type = "radio";
      input.name = `answer-${index}`;
      input.value = String(choiceIndex);
      label.append(input, element("span", choice));
      field.append(label);
    });
    form.append(field);
  });
  const submit = element("button", "Score and sync attempt");
  submit.type = "submit";
  form.append(submit);
  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    let score;
    try {
      const selections = questions.map((_, i) => {
        const chosen = form.querySelector(`input[name="answer-${i}"]:checked`);
        return chosen ? Number(chosen.value) : -1;
      });
      score = scoreQuiz(state.exam, questions, selections);
    } catch (error) { message(error.message, "error"); return; }
    submit.disabled = true;
    state.score = score;
    clearWork();
    message(`${score.exam.code}: ${score.correct} of ${score.total} correct (${Math.round(score.percent * 100)}%).`);
    const sync = message("Sending this attempt to the study server…");
    const entry = { when: new Date().toLocaleString(), code: score.exam.code, correct: score.correct, total: score.total, sync: "not synced" };
    try {
      const coaching = await sendAttempt(score);
      sync.textContent = "Attempt saved on the study server.";
      entry.sync = "server saved";
      const block = element("div", undefined, "server-result");
      block.append(element("h3", "Server coaching"), element("p", coaching.coachMessage), element("p", coaching.nextAction));
      $("work-area").append(block);
    } catch (error) {
      sync.textContent = `Server did not save the attempt: ${error.message}. The score remains in this browser.`;
      sync.className = "error";
    }
    addHistory(entry);
    for (const result of score.results) {
      const domain = score.exam.domains.find((d) => d.id === result.question.domainID);
      const card = element("article", undefined, "card");
      card.append(element("h3", result.question.prompt),
        element("p", `Your answer: ${result.question.choices[result.choice]}`, result.correct ? "correct" : "incorrect"),
        element("p", `Best answer: ${result.question.choices[result.question.answerIndex]}`),
        element("p", result.question.explanation),
        element("small", domain?.title || result.question.domainID));
      if (!result.correct) {
        const button = element("button", "Ask tutor about this mistake");
        button.type = "button";
        button.addEventListener("click", () => askTutor(score, result, card, button));
        const action = element("p");
        action.append(button);
        card.append(action);
      }
      $("work-area").append(card);
    }
  });
  $("work-area").append(form);
}

async function askTutor(score, result, card, button) {
  if (!state.api || !state.studentId) { card.append(element("p", "Connect before using the tutor.", "error")); return; }
  button.disabled = true;
  const context = mistakeContext(state.studentId, score, result);
  const output = element("div", "Asking tutor…", "server-result");
  card.append(output);
  try {
    const response = await state.api.tutor(context);
    output.replaceChildren(element("h3", "Tutor feedback"), element("p", response.coachMessage),
      element("p", response.mistakePattern), element("p", `Source: ${response.source}`));
    const list = element("ul");
    (response.guidingQuestions || []).forEach((q) => list.append(element("li", q)));
    output.append(list);
    const form = element("form");
    const label = element("label", "Follow-up question");
    const input = element("input");
    input.required = true;
    input.maxLength = 1000;
    label.append(input);
    const send = element("button", "Ask follow-up");
    form.append(label, send);
    const messages = [];
    form.addEventListener("submit", async (event) => {
      event.preventDefault();
      const question = input.value.trim();
      if (!question) return;
      send.disabled = true;
      try {
        const reply = await sendChatTurn(messages, question, (transcript) => state.api.chat(context, transcript));
        output.append(element("p", `You: ${question}`), element("p", `Tutor: ${reply.reply} (${reply.source})`));
        input.value = "";
      } catch (error) { output.append(element("p", error.message, "error")); }
      finally { send.disabled = false; }
    });
    output.append(form);
  } catch (error) { output.textContent = error.message; output.className = "error"; button.disabled = false; }
}

function showCards() {
  clearWork();
  const cards = state.exam.flashcards.filter((card) => !$("domain-select").value || card.domainID === $("domain-select").value);
  if (!cards.length) { message("There are no flashcards for this domain."); return; }
  let index = 0;
  let flipped = false;
  const panel = element("div", undefined, "card");
  const progress = element("p");
  const content = element("h3");
  const flip = element("button", "Reveal answer");
  const next = element("button", "Next card");
  function draw() { progress.textContent = `${index + 1} / ${cards.length}`; content.textContent = flipped ? cards[index].back : cards[index].front; flip.textContent = flipped ? "Show prompt" : "Reveal answer"; }
  flip.addEventListener("click", () => { flipped = !flipped; draw(); });
  next.addEventListener("click", () => { index = (index + 1) % cards.length; flipped = false; draw(); });
  panel.append(progress, content, flip, " ", next);
  $("work-area").append(panel);
  draw();
}

function showTasks() {
  clearWork();
  const done = new Set(readStoredArray(browserStorage(), completedKey).filter((id) => typeof id === "string"));
  const tasks = state.exam.studyTasks.filter((task) => !$("domain-select").value || task.domainID === $("domain-select").value);
  if (!tasks.length) { message("There are no study tasks for this domain."); return; }
  for (const task of tasks) {
    const label = element("label", undefined, "card");
    const checkbox = element("input");
    checkbox.type = "checkbox";
    checkbox.checked = done.has(task.id);
    const saveStatus = element("small", "Saved in this browser.");
    saveStatus.setAttribute("role", "status");
    checkbox.addEventListener("change", () => {
      const result = toggleStoredString(browserStorage(), completedKey, task.id, checkbox.checked, [...done]);
      done.clear();
      result.entries.forEach((id) => done.add(id));
      saveStatus.textContent = result.persisted
        ? "Saved in this browser."
        : "Browser storage could not save this task; it will be lost when this page closes.";
      saveStatus.className = result.persisted ? "" : "error";
    });
    label.append(checkbox, element("span", `${task.title} · ${task.minutes} min — ${task.detail}`));
    label.append(saveStatus);
    $("work-area").append(label);
  }
}

async function showPlan() {
  clearWork();
  if (!state.api || !state.studentId) { message("Connect before requesting a study plan.", "error"); return; }
  const status = message("Requesting an adaptive plan from the study server…");
  try {
    const data = await state.api.studyPath({ studentId: state.studentId, examID: state.exam.id, daysAvailable: 7, minutesPerDay: 45 });
    status.textContent = `${data.exam}: ${data.adaptiveFocus}`;
    for (const day of data.plan || []) {
      const card = element("article", undefined, "card");
      card.append(element("h3", `Day ${day.day}: ${day.focus}`), element("p", `${day.minutes} minutes · ${day.tasks.join(" · ")}`));
      $("work-area").append(card);
    }
  } catch (error) { status.textContent = error.message; status.className = "error"; }
}

async function start() {
  try {
    const response = await fetch("/catalog.json");
    if (!response.ok) throw new Error("Could not load the bundled catalog.");
    state.catalog = validateCatalog(await response.json());
    $("exam-select").replaceChildren(...state.catalog.exams.map((e) => new Option(`${e.name} · ${e.code}`, e.id)));
    $("exam-select").addEventListener("change", showExam);
    $("domain-select").addEventListener("change", clearWork);
    $("connect-form").addEventListener("submit", connect);
    $("new-quiz").addEventListener("click", startQuiz);
    $("show-cards").addEventListener("click", showCards);
    $("show-tasks").addEventListener("click", showTasks);
    $("get-plan").addEventListener("click", showPlan);
    $("server-url").value = readStoredValue(browserStorage(), originKey) || "http://127.0.0.1:8787";
    showExam();
    renderHistory();
  } catch (error) { $("connection-detail").textContent = error.message; }
}

start();
