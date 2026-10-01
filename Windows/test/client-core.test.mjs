import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import test from "node:test";
import * as clientCore from "../client-core.mjs";
import {
  attemptUpload, chooseQuestions, createApiClient, mistakeContext, scoreQuiz,
  validateCatalog, validateServerURL
} from "../client-core.mjs";

const here = path.dirname(fileURLToPath(import.meta.url));
const catalog = validateCatalog(JSON.parse(await readFile(path.join(here, "../../Android/app/src/main/assets/exam_catalog.json"), "utf8")));
const studentId = "00000000-0000-4000-8000-000000000042";

test("Windows consumes the canonical shared catalog in upstream v1 or compatible v2 form", () => {
  assert.ok([1, 2].includes(catalog.schemaVersion));
  const codes = catalog.exams.map((exam) => exam.code);
  assert.ok(["220-1201", "220-1202", "SY0-701"].every((code) => codes.includes(code)));
  if (catalog.schemaVersion === 1) assert.deepEqual(codes, ["220-1201", "220-1202", "SY0-701"]);
  assert.ok(catalog.exams.every((exam) => exam.practiceQuestions.length > 0));
  const schemaOne = { schemaVersion: 1, exams: [{ id: "a-plus", code: "220-1201", domains: [], practiceQuestions: [] }] };
  assert.equal(validateCatalog(schemaOne), schemaOne);
  assert.throws(() => validateCatalog({ ...schemaOne, schemaVersion: 3 }), /unsupported schema/);
});

test("scores original practice and builds server-compatible attempt and tutor payloads", () => {
  const exam = catalog.exams.find((item) => item.code === "SY0-701");
  const questions = chooseQuestions(exam, exam.domains[0].id, 2, () => 0);
  assert.equal(questions.length, 2);
  const score = scoreQuiz(exam, questions, [questions[0].answerIndex, (questions[1].answerIndex + 1) % questions[1].choices.length]);
  assert.equal(score.correct, 1);
  assert.equal(score.weakDomains.length, 1);
  const upload = attemptUpload(studentId, score);
  assert.equal(upload.examID, exam.id);
  assert.equal(upload.attempt.domainPercents[questions[0].domainID], 0.5);
  assert.equal(upload.weakDomains[0], exam.domains[0].title);
  const context = mistakeContext(studentId, score, score.results[1]);
  assert.equal(context.domainTitle, exam.domains[0].title);
  assert.equal(context.wasCorrect, false);
  assert.throws(() => attemptUpload("anonymous", score), /authenticated profile/);
});

test("rejects plaintext remote endpoints and URL credentials", () => {
  assert.equal(validateServerURL("http://127.0.0.1:8787"), "http://127.0.0.1:8787");
  assert.equal(validateServerURL("https://study.lan.example"), "https://study.lan.example");
  assert.throws(() => validateServerURL("http://192.168.1.10:8787"), /HTTPS/);
  assert.throws(() => validateServerURL("https://user:password@study.lan.example"), /credentials/);
  assert.throws(() => validateServerURL("https://study.lan.example/api"), /origin/);
});

test("Remote client requires an authenticated session response", async () => {
  const calls = [];
  const fakeFetch = async (url, options) => {
    calls.push({ url: String(url), options });
    return { ok: true, json: async () => ({ authenticated: true, studentId }) };
  };
  const client = createApiClient("https://study.lan.example", { fetchImpl: fakeFetch, bearerToken: "memory-only" });
  assert.deepEqual(await client.session(), { authenticated: true, studentId });
  assert.equal(calls[0].url, "https://study.lan.example/api/session");
  assert.equal(calls[0].options.credentials, "include");
  assert.equal(calls[0].options.headers.Authorization, "Bearer memory-only");
  await client.attempt({ studentId });
  assert.equal(calls[1].url, "https://study.lan.example/api/learning/attempt");
  assert.equal(JSON.parse(calls[1].options.body).studentId, studentId);
});

test("LAN client rejects a missing or self-asserted session identity", async () => {
  for (const session of [{ authenticated: false, studentId: null }, { authenticated: true, studentId: "anonymous" }]) {
    const client = createApiClient("https://study.lan.example", {
      fetchImpl: async () => ({ ok: true, json: async () => session })
    });
    await assert.rejects(client.session(), /authenticated student session/);
  }
});

test("missing session endpoint falls back only for loopback test mode", async () => {
  const missingRoute = async () => ({
    ok: false,
    status: 404,
    json: async () => ({ error: "Route not found" })
  });
  const local = createApiClient("http://127.0.0.1:8787", { fetchImpl: missingRoute });
  assert.deepEqual(await local.session(), { authenticated: false, studentId: null });
  const remote = createApiClient("https://study.lan.example", { fetchImpl: missingRoute });
  await assert.rejects(remote.session(), (error) => error.statusCode === 404);
});

test("quiz requires an answer for each question", () => {
  const exam = catalog.exams[0];
  const questions = exam.practiceQuestions.slice(0, 1);
  assert.throws(() => scoreQuiz(exam, questions, [-1]), /Answer every question/);
});

test("quiz history persists newest first and keeps a bounded history across reloads", () => {
  assert.equal(typeof clientCore.prependStoredArray, "function", "client needs a testable persistent history operation");
  assert.equal(typeof clientCore.readStoredArray, "function");
  const values = new Map();
  const writer = { getItem: (key) => values.get(key) ?? null, setItem: (key, value) => values.set(key, value) };
  const reopenedPage = { getItem: (key) => values.get(key) ?? null, setItem: (key, value) => values.set(key, value) };
  const key = "history";

  assert.deepEqual(clientCore.prependStoredArray(writer, key, { id: "one" }, 2), {
    entries: [{ id: "one" }], persisted: true
  });
  clientCore.prependStoredArray(writer, key, { id: "two" }, 2);
  clientCore.prependStoredArray(writer, key, { id: "three" }, 2);

  assert.deepEqual(clientCore.readStoredArray(reopenedPage, key), [{ id: "three" }, { id: "two" }]);
});

test("study-task completion persists by task ID and can be cleared after reload", () => {
  assert.equal(typeof clientCore.toggleStoredString, "function", "client needs a testable persistent task operation");
  const values = new Map();
  const storage = { getItem: (key) => values.get(key) ?? null, setItem: (key, value) => values.set(key, value) };
  const key = "completed";

  assert.deepEqual(clientCore.toggleStoredString(storage, key, "task-a", true), {
    entries: ["task-a"], persisted: true
  });
  assert.deepEqual(clientCore.toggleStoredString(storage, key, "task-b", true), {
    entries: ["task-a", "task-b"], persisted: true
  });
  assert.deepEqual(clientCore.readStoredArray(storage, key), ["task-a", "task-b"]);
  assert.deepEqual(clientCore.toggleStoredString(storage, key, "task-a", false), {
    entries: ["task-b"], persisted: true
  });
  const reopenedPage = { getItem: (name) => values.get(name) ?? null, setItem: (name, value) => values.set(name, value) };
  assert.deepEqual(clientCore.readStoredArray(reopenedPage, key), ["task-b"]);
});

test("malformed or unavailable browser storage does not throw during history recording", () => {
  assert.equal(typeof clientCore.prependStoredArray, "function", "client needs a testable persistent history operation");
  const malformed = { getItem: () => "not-json", setItem: () => {} };
  assert.deepEqual(clientCore.readStoredArray(malformed, "history"), []);

  const unavailable = { getItem: () => null, setItem: () => { throw new Error("quota"); } };
  assert.deepEqual(clientCore.prependStoredArray(unavailable, "history", { id: "visible-now" }, 50), {
    entries: [{ id: "visible-now" }], persisted: false
  });
});

test("server-origin and local-profile settings survive reload and storage denial is reported", () => {
  assert.equal(typeof clientCore.readStoredValue, "function", "client needs testable persistent scalar settings");
  assert.equal(typeof clientCore.writeStoredValue, "function");
  const values = new Map();
  const firstPage = { getItem: (key) => values.get(key) ?? null, setItem: (key, value) => values.set(key, value) };
  const reopenedPage = { getItem: (key) => values.get(key) ?? null, setItem: (key, value) => values.set(key, value) };
  assert.equal(clientCore.writeStoredValue(firstPage, "server-origin", "https://study.lan.example"), true);
  assert.equal(clientCore.writeStoredValue(firstPage, "local-profile", "local-uuid"), true);
  assert.equal(clientCore.readStoredValue(reopenedPage, "server-origin"), "https://study.lan.example");
  assert.equal(clientCore.readStoredValue(reopenedPage, "local-profile"), "local-uuid");

  const denied = { getItem: () => { throw new Error("blocked"); }, setItem: () => { throw new Error("blocked"); } };
  assert.equal(clientCore.readStoredValue(denied, "server-origin", ""), "");
  assert.equal(clientCore.writeStoredValue(denied, "server-origin", "https://study.lan.example"), false);
});

test("browser storage getter denial is contained at the acquisition boundary", () => {
  assert.equal(typeof clientCore.acquireStorage, "function", "client needs a guarded browser-storage accessor");
  const unavailable = Object.defineProperty({}, "localStorage", {
    get() { throw new Error("storage access denied"); }
  });
  assert.equal(clientCore.acquireStorage(() => unavailable.localStorage), null);
  assert.equal(clientCore.readStoredValue(clientCore.acquireStorage(() => unavailable.localStorage), "origin"), "");
  assert.equal(clientCore.writeStoredValue(clientCore.acquireStorage(() => unavailable.localStorage), "origin", "https://study.lan.example"), false);
});

test("failed tutor follow-up retries without duplicating the pending user turn", async () => {
  assert.equal(typeof clientCore.sendChatTurn, "function", "client needs transactional chat-turn handling");
  const messages = [{ role: "user", content: "Earlier" }, { role: "assistant", content: "Review this." }];
  const requests = [];
  let shouldFail = true;
  const send = async (transcript) => {
    requests.push(structuredClone(transcript));
    if (shouldFail) {
      shouldFail = false;
      throw new Error("temporary network failure");
    }
    return { reply: "Check the route table." };
  };

  await assert.rejects(clientCore.sendChatTurn(messages, "Why?", send), /temporary network failure/);
  assert.deepEqual(messages, [{ role: "user", content: "Earlier" }, { role: "assistant", content: "Review this." }]);
  assert.deepEqual(requests[0], [...messages, { role: "user", content: "Why?" }]);

  const priorTranscript = structuredClone(messages);
  await clientCore.sendChatTurn(messages, "Why?", send);
  assert.deepEqual(requests[1], [...priorTranscript, { role: "user", content: "Why?" }]);
  assert.equal(requests[1].filter((message) => message.role === "user" && message.content === "Why?").length, 1);
  assert.deepEqual(messages, [
    { role: "user", content: "Earlier" },
    { role: "assistant", content: "Review this." },
    { role: "user", content: "Why?" },
    { role: "assistant", content: "Check the route table." }
  ]);
});
