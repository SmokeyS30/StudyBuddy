import http from "node:http";
import crypto from "node:crypto";
import { readFileSync } from "node:fs";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

loadDotEnv(path.join(__dirname, ".env"));

const PORT = Number(process.env.PORT || 8787);
const HOST = process.env.HOST || (process.env.PORT ? "0.0.0.0" : "127.0.0.1");
const DATA_DIR = path.resolve(__dirname, process.env.STUDYBUDDY_DATA_DIR || "./data");
const PROFILE_FILE = path.join(DATA_DIR, "profiles.json");
const OPENAI_MODEL = process.env.OPENAI_MODEL || "gpt-5.6-terra";
const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS || "*")
  .split(",")
  .map((origin) => origin.trim())
  .filter(Boolean);

const EXAM_BLUEPRINTS = {
  "comptia-a-plus-core-1-220-1201": {
    name: "CompTIA A+ Core 1",
    code: "220-1201",
    domains: ["Mobile Devices", "Networking", "Hardware", "Virtualization and Cloud Computing", "Hardware and Network Troubleshooting"],
    labTypes: ["networking diagram", "printer troubleshooting", "cable troubleshooting", "wireless setup", "hardware triage"]
  },
  "comptia-a-plus-core-2-220-1202": {
    name: "CompTIA A+ Core 2",
    code: "220-1202",
    domains: ["Operating Systems", "Security", "Software Troubleshooting", "Operational Procedures"],
    labTypes: ["Windows desktop", "Linux terminal", "ticket system", "malware response", "account hardening"]
  },
  "comptia-security-plus-sy0-701": {
    name: "CompTIA Security+",
    code: "SY0-701",
    domains: ["General Security Concepts", "Threats, Vulnerabilities, and Mitigations", "Security Architecture", "Security Operations", "Security Program Management and Oversight"],
    labTypes: ["log analysis", "firewall rules", "incident response", "cloud responsibility", "risk analysis"]
  }
};

const SYSTEM_PROMPT = [
  "You are StudyBuddy AI Tutor, a Socratic certification coach for CompTIA A+ 220-1201, A+ 220-1202, and Security+ SY0-701.",
  "You help students learn from mistakes, build confidence, and study for the real exam using original explanations and legal study guidance.",
  "Do not provide actual exam dumps, copied proprietary question banks, or claims that content is from the live CompTIA exam.",
  "Do not simply reveal answers. Teach by asking guiding questions, diagnosing the misconception, and assigning targeted practice.",
  "Keep responses practical, exam-focused, and specific to the student's selected exam, domain, confidence, and mistake history.",
  "Return strict JSON with keys: coachMessage, mistakePattern, guidingQuestions, assignments, nextAction."
].join(" ");

await ensureDataFile();

const server = http.createServer(async (request, response) => {
  try {
    setCorsHeaders(request, response);

    if (request.method === "OPTIONS") {
      response.writeHead(204);
      response.end();
      return;
    }

    if (request.method === "GET" && request.url === "/health") {
      sendJson(response, 200, {
        ok: true,
        service: "StudyBuddy AI Server",
        host: HOST,
        port: PORT,
        model: OPENAI_MODEL,
        openaiConfigured: isOpenAIConfigured(),
        openaiKeyStatus: openAIKeyStatus(),
        exams: Object.values(EXAM_BLUEPRINTS).map((exam) => `${exam.name} ${exam.code}`)
      });
      return;
    }

    if (request.method === "POST" && request.url === "/api/tutor/mistake") {
      const context = await readJson(request);
      const profileStore = await readProfiles();
      const profile = getProfile(profileStore, context.studentId);
      learnFromMistake(profile, context);

      const fallback = buildTutorResponse(context, profile, "local");
      const aiResponse = await buildOpenAITutorResponse(context, profile, fallback);
      await writeProfiles(profileStore);
      sendJson(response, 200, aiResponse);
      return;
    }

    if (request.method === "POST" && request.url === "/api/tutor/chat") {
      const payload = await readJson(request);
      const profileStore = await readProfiles();
      const profile = getProfile(profileStore, payload.context?.studentId);

      const chatResponse = await buildChatResponse(payload.context, payload.messages || [], profile);
      await writeProfiles(profileStore);
      sendJson(response, 200, chatResponse);
      return;
    }

    if (request.method === "POST" && request.url === "/api/learning/attempt") {
      const payload = await readJson(request);
      const profileStore = await readProfiles();
      const profile = getProfile(profileStore, payload.studentId);
      learnFromAttempt(profile, payload);

      const weakestDomain = (payload.weakDomains || [])[0] || findWeakestDomain(profile, payload.examID);
      await writeProfiles(profileStore);
      sendJson(response, 200, buildAttemptResponse(payload, weakestDomain));
      return;
    }

    if (request.method === "POST" && request.url === "/api/study-path") {
      const payload = await readJson(request);
      const profileStore = await readProfiles();
      const profile = getProfile(profileStore, payload.studentId);
      sendJson(response, 200, buildStudyPath(payload, profile));
      return;
    }

    sendJson(response, 404, { error: "Route not found" });
  } catch (error) {
    sendJson(response, 500, {
      error: "StudyBuddy AI server error",
      detail: error instanceof Error ? error.message : String(error)
    });
  }
});

server.listen(PORT, HOST, () => {
  console.log(`StudyBuddy AI server running on http://${HOST}:${PORT}`);
});

function loadDotEnv(envPath) {
  try {
    const contents = readFileSync(envPath, "utf8");
    for (const line of contents.split(/\r?\n/)) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith("#") || !trimmed.includes("=")) continue;
      const [key, ...rest] = trimmed.split("=");
      if (!process.env[key]) {
        process.env[key] = rest.join("=").trim();
      }
    }
  } catch {
    // .env is optional.
  }
}

async function ensureDataFile() {
  await mkdir(DATA_DIR, { recursive: true });
  try {
    await readFile(PROFILE_FILE, "utf8");
  } catch {
    await writeFile(PROFILE_FILE, JSON.stringify({ profiles: {} }, null, 2));
  }
}

async function readProfiles() {
  const data = await readFile(PROFILE_FILE, "utf8");
  return JSON.parse(data);
}

async function writeProfiles(profileStore) {
  await writeFile(PROFILE_FILE, JSON.stringify(profileStore, null, 2));
}

function getProfile(profileStore, studentId) {
  const id = studentId || "anonymous";
  profileStore.profiles[id] ||= {
    studentId: id,
    createdAt: new Date().toISOString(),
    lastSeenAt: new Date().toISOString(),
    exams: {}
  };
  profileStore.profiles[id].lastSeenAt = new Date().toISOString();
  return profileStore.profiles[id];
}

function getExamProfile(profile, examID) {
  const id = examID || "unknown-exam";
  profile.exams[id] ||= {
    examID: id,
    attempts: [],
    domains: {},
    mistakeLog: []
  };
  return profile.exams[id];
}

function getDomainStats(examProfile, domainTitle) {
  const title = domainTitle || "General";
  examProfile.domains[title] ||= {
    seen: 0,
    correct: 0,
    missed: 0,
    guessed: 0,
    pbqMissed: 0,
    confidence: {},
    objectives: {},
    lastMistakeAt: null
  };
  return examProfile.domains[title];
}

function learnFromMistake(profile, context = {}) {
  const examProfile = getExamProfile(profile, context.examID);
  const domainStats = getDomainStats(examProfile, context.domainTitle);
  const wasCorrect = Boolean(context.wasCorrect);
  const confidence = context.confidence || "Not marked";

  domainStats.seen += 1;
  domainStats.correct += wasCorrect ? 1 : 0;
  domainStats.missed += wasCorrect ? 0 : 1;
  domainStats.guessed += confidence.toLowerCase().includes("guess") ? 1 : 0;
  domainStats.pbqMissed += !wasCorrect && context.isPerformanceBased ? 1 : 0;
  domainStats.confidence[confidence] = (domainStats.confidence[confidence] || 0) + 1;
  domainStats.objectives[context.objective || "General review"] = (domainStats.objectives[context.objective || "General review"] || 0) + (wasCorrect ? 0 : 1);
  domainStats.lastMistakeAt = wasCorrect ? domainStats.lastMistakeAt : new Date().toISOString();

  examProfile.mistakeLog.unshift({
    at: new Date().toISOString(),
    domainTitle: context.domainTitle,
    objective: context.objective,
    wasCorrect,
    confidence,
    isPerformanceBased: Boolean(context.isPerformanceBased),
    itemKind: context.itemKind,
    prompt: context.questionPrompt
  });

  examProfile.mistakeLog = examProfile.mistakeLog.slice(0, 100);
}

function learnFromAttempt(profile, upload = {}) {
  const examProfile = getExamProfile(profile, upload.examID);
  const attempt = upload.attempt || {};
  examProfile.attempts.unshift({
    at: new Date().toISOString(),
    title: attempt.title,
    scaledScore: attempt.scaledScore,
    passingScore: attempt.passingScore,
    percent: attempt.percent,
    pbqPercent: attempt.pbqPercent,
    guessedCount: attempt.guessedCount,
    flaggedCount: attempt.flaggedCount,
    weakDomains: upload.weakDomains || []
  });
  examProfile.attempts = examProfile.attempts.slice(0, 25);

  for (const [domainID, percent] of Object.entries(attempt.domainPercents || {})) {
    const domainStats = getDomainStats(examProfile, domainID);
    domainStats.seen += 1;
    if (percent >= 0.75) {
      domainStats.correct += 1;
    } else {
      domainStats.missed += 1;
      domainStats.lastMistakeAt = new Date().toISOString();
    }
  }
}

function buildTutorResponse(context = {}, profile, source) {
  const exam = EXAM_BLUEPRINTS[context.examID] || {
    name: context.examName || "StudyBuddy exam",
    code: context.examCode || "",
    labTypes: ["hands-on lab"]
  };
  const weakestDomain = findWeakestDomain(profile, context.examID) || context.domainTitle || "this objective";
  const isPBQ = Boolean(context.isPerformanceBased);
  const missed = !context.wasCorrect;
  const pattern = missed
    ? mistakePatternFor(context)
    : "The answer was correct, so reinforce the reasoning and watch for overconfidence.";

  return {
    sessionId: crypto.randomUUID(),
    coachMessage: missed
      ? `Let's slow this down. For ${exam.name} ${exam.code}, your miss points to ${context.domainTitle || weakestDomain}. I want you to explain the clue in the scenario before choosing a tool or control.`
      : `Good answer. Now prove it: explain why the correct choice fits the scenario and why the strongest distractor does not.`,
    mistakePattern: pattern,
    guidingQuestions: guidingQuestionsFor(context),
    assignments: [
      {
        type: "questions",
        title: "Targeted question set",
        detail: `Answer 30 original ${context.domainTitle || weakestDomain} questions with no hints, then review only missed items.`,
        count: 30
      },
      {
        type: "flashcards",
        title: "Spaced flashcards",
        detail: `Review weak terms from ${context.domainTitle || weakestDomain}; guessed cards return sooner.`,
        count: 12
      },
      {
        type: "pbq",
        title: isPBQ ? "PBQ redo" : "PBQ transfer drill",
        detail: `Complete one ${exam.labTypes[0]} scenario and narrate each decision before submitting.`,
        count: 1
      },
      {
        type: "lab",
        title: "Hands-on reinforcement",
        detail: `Spend ${Math.min(Math.max(context.targetStudyMinutes || 30, 15), 60)} minutes in a ${exam.labTypes[1] || "hands-on"} lab mapped to this weakness.`,
        count: 1
      },
      {
        type: "video",
        title: "Video review",
        detail: "Watch one objective-matched lesson, then write three clues that would reveal this topic on exam day.",
        count: 1
      }
    ],
    nextAction: "Answer the guiding questions out loud before starting the assigned practice.",
    source
  };
}

function buildAttemptResponse(upload = {}, weakestDomain) {
  return {
    sessionId: crypto.randomUUID(),
    coachMessage: `Attempt saved. StudyBuddy will prioritize ${weakestDomain || "your lowest objective"} next.`,
    mistakePattern: "Full-attempt analytics updated the adaptive learning profile.",
    guidingQuestions: [
      "Which objective cost you the most points?",
      "Were those misses knowledge gaps, rushed reading, or confidence errors?",
      "What evidence would prove the right answer next time?"
    ],
    assignments: [
      {
        type: "questions",
        title: "Weak objective recovery",
        detail: `Complete 30 questions from ${weakestDomain || "the lowest scoring objective"}.`,
        count: 30
      },
      {
        type: "pbq",
        title: "PBQ pressure drill",
        detail: "Complete one PBQ before doing any multiple-choice review.",
        count: 1
      }
    ],
    nextAction: "Open the weakest objective and complete the assigned recovery set.",
    source: "local"
  };
}

function mistakePatternFor(context) {
  if (context.isPerformanceBased) {
    return "PBQ workflow error: the student may be moving too fast before reading every constraint.";
  }
  if ((context.itemKind || "").toLowerCase().includes("multiple")) {
    return "Multi-select trap: the student may be choosing true statements instead of all required answers.";
  }
  if ((context.confidence || "").toLowerCase().includes("guess")) {
    return "Confidence gap: the student guessed, so the answer does not yet show durable mastery.";
  }
  return "Scenario-reading gap: the student likely recognized familiar terms but missed the deciding clue.";
}

function guidingQuestionsFor(context) {
  const domain = context.domainTitle || "this objective";
  if ((context.examCode || "").includes("1201") && domain.toLowerCase().includes("network")) {
    return [
      "What symptom tells you whether this is DHCP, DNS, gateway, wireless, or physical layer?",
      "What command or tool would prove your theory with the least disruption?",
      "Which answer sounds true but does not match the first troubleshooting step?"
    ];
  }
  if ((context.examCode || "").includes("1202")) {
    return [
      "What evidence source would you check before changing the system?",
      "Which option fixes the issue while respecting least privilege, documentation, and user impact?",
      "What verification step proves the problem is actually resolved?"
    ];
  }
  if ((context.examCode || "").includes("701")) {
    return [
      "What risk or control objective is the question really testing?",
      "Which option reduces risk without creating a larger operational problem?",
      "What log, policy, or architecture clue eliminates the strongest distractor?"
    ];
  }
  return [
    `What clue in the scenario points to ${domain}?`,
    "Which answer is merely true, and which answer best fits the constraint?",
    "What would you do first if this were a real ticket or incident?"
  ];
}

function findWeakestDomain(profile, examID) {
  const examProfile = profile?.exams?.[examID];
  if (!examProfile) return null;

  return Object.entries(examProfile.domains)
    .map(([domain, stats]) => {
      const total = Math.max(stats.correct + stats.missed, 1);
      return { domain, missRate: stats.missed / total, seen: stats.seen };
    })
    .sort((a, b) => b.missRate - a.missRate || b.seen - a.seen)[0]?.domain || null;
}

function buildStudyPath(payload = {}, profile) {
  const exam = EXAM_BLUEPRINTS[payload.examID] || {
    name: payload.examName || "StudyBuddy exam",
    code: payload.examCode || "",
    domains: []
  };
  const days = Math.min(Math.max(Number(payload.daysAvailable || 10), 1), 60);
  const minutes = Math.min(Math.max(Number(payload.minutesPerDay || 45), 15), 180);
  const weakest = findWeakestDomain(profile, payload.examID);

  const plan = Array.from({ length: days }, (_, index) => {
    const domain = weakest || exam.domains[index % Math.max(exam.domains.length, 1)] || "Mixed review";
    return {
      day: index + 1,
      focus: index === days - 1 ? "Final exam simulation" : domain,
      tasks: index === days - 1
        ? ["Real Exam Mode", "Review flagged questions", "Mistake notebook", "Light flashcards"]
        : ["Objective reading", "Spaced flashcards", "Targeted quiz", "PBQ or lab drill"],
      minutes
    };
  });

  return {
    exam: `${exam.name} ${exam.code}`.trim(),
    days,
    adaptiveFocus: weakest || "Start with the highest-weight objective until the first scored attempt is saved.",
    plan
  };
}

async function buildOpenAITutorResponse(context, profile, fallback) {
  if (!isOpenAIConfigured()) {
    return fallback;
  }

  try {
    const ai = await callOpenAI({
      task: "mistake_tutor",
      context,
      learnerProfile: summarizeProfile(profile, context.examID),
      fallbackShape: fallback
    });
    return normalizeTutorResponse(ai, "openai", fallback);
  } catch (error) {
    return {
      ...fallback,
      coachMessage: `${fallback.coachMessage} The OpenAI call failed, so this is local fallback coaching. Server detail: ${error instanceof Error ? error.message : String(error)}`,
      source: "local-fallback"
    };
  }
}

async function buildChatResponse(context = {}, messages = [], profile) {
  const lastUserMessage = [...messages].reverse().find((message) => message.role === "user")?.content || "";
  const fallback = {
    sessionId: crypto.randomUUID(),
    reply: `Let's reason it out. In ${context.examCode || "this exam"}, what clue in the scenario matters most here, and what answer would that clue eliminate first?`,
    source: "local"
  };

  if (!isOpenAIConfigured()) {
    return fallback;
  }

  try {
    const ai = await callOpenAI({
      task: "follow_up_chat",
      context,
      learnerProfile: summarizeProfile(profile, context.examID),
      messages,
      instruction: `Reply to the student's follow-up as a Socratic tutor. Student said: ${lastUserMessage}`
    });
    const text = typeof ai === "string" ? ai : ai.reply || ai.coachMessage || fallback.reply;
    return {
      sessionId: crypto.randomUUID(),
      reply: text,
      source: "openai"
    };
  } catch {
    return fallback;
  }
}

async function callOpenAI(payload) {
  const response = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${(process.env.OPENAI_API_KEY || "").trim()}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      model: OPENAI_MODEL,
      input: [
        {
          role: "system",
          content: [{ type: "input_text", text: SYSTEM_PROMPT }]
        },
        {
          role: "user",
          content: [{ type: "input_text", text: JSON.stringify(payload) }]
        }
      ],
      max_output_tokens: 1100
    })
  });

  const data = await response.json();
  if (!response.ok) {
    throw new Error(data.error?.message || `OpenAI request failed with status ${response.status}`);
  }

  const text = extractOutputText(data);
  try {
    return JSON.parse(text);
  } catch {
    return text;
  }
}

function isOpenAIConfigured() {
  return openAIKeyStatus() === "configured";
}

function openAIKeyStatus() {
  const key = (process.env.OPENAI_API_KEY || "").trim();
  if (!key) return "missing";
  if (!key.startsWith("sk-")) return "invalid-prefix";
  return "configured";
}

function extractOutputText(data) {
  if (typeof data.output_text === "string" && data.output_text.trim()) {
    return data.output_text;
  }

  const chunks = [];
  for (const item of data.output || []) {
    for (const content of item.content || []) {
      if (content.text) chunks.push(content.text);
    }
  }
  return chunks.join("\n").trim();
}

function normalizeTutorResponse(ai, source, fallback) {
  if (typeof ai === "string") {
    return {
      ...fallback,
      coachMessage: ai,
      source
    };
  }

  return {
    sessionId: crypto.randomUUID(),
    coachMessage: ai.coachMessage || fallback.coachMessage,
    mistakePattern: ai.mistakePattern || fallback.mistakePattern,
    guidingQuestions: Array.isArray(ai.guidingQuestions) && ai.guidingQuestions.length ? ai.guidingQuestions : fallback.guidingQuestions,
    assignments: Array.isArray(ai.assignments) && ai.assignments.length ? ai.assignments : fallback.assignments,
    nextAction: ai.nextAction || fallback.nextAction,
    source
  };
}

function summarizeProfile(profile, examID) {
  const examProfile = profile?.exams?.[examID];
  if (!examProfile) {
    return { summary: "No prior attempts for this exam yet." };
  }

  const domains = Object.entries(examProfile.domains).map(([domain, stats]) => ({
    domain,
    seen: stats.seen,
    missed: stats.missed,
    correct: stats.correct,
    guessed: stats.guessed,
    pbqMissed: stats.pbqMissed,
    topMissedObjectives: Object.entries(stats.objectives || {})
      .sort((a, b) => b[1] - a[1])
      .slice(0, 3)
      .map(([objective, misses]) => ({ objective, misses }))
  }));

  return {
    attemptCount: examProfile.attempts.length,
    recentAttempts: examProfile.attempts.slice(0, 5),
    weakestDomain: findWeakestDomain(profile, examID),
    domains
  };
}

async function readJson(request) {
  const chunks = [];
  for await (const chunk of request) {
    chunks.push(chunk);
  }

  const raw = Buffer.concat(chunks).toString("utf8");
  if (!raw) return {};
  return JSON.parse(raw);
}

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, { "Content-Type": "application/json" });
  response.end(JSON.stringify(payload));
}

function setCorsHeaders(request, response) {
  const requestOrigin = request.headers.origin;
  const allowOrigin = ALLOWED_ORIGINS.includes("*") || !requestOrigin
    ? "*"
    : ALLOWED_ORIGINS.includes(requestOrigin) ? requestOrigin : ALLOWED_ORIGINS[0];
  response.setHeader("Access-Control-Allow-Origin", allowOrigin);
  response.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS");
  response.setHeader("Access-Control-Allow-Headers", "Content-Type,Authorization");
}
