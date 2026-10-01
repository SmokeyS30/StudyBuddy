import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { attemptUpload, chooseQuestions, createApiClient, mistakeContext, scoreQuiz, validateCatalog } from "../client-core.mjs";

const base = process.argv[2];
if (!base) throw new Error("Pass the isolated loopback server URL.");
const here = path.dirname(fileURLToPath(import.meta.url));
const catalog = validateCatalog(JSON.parse(await readFile(path.join(here, "../../Android/app/src/main/assets/exam_catalog.json"), "utf8")));
const exam = catalog.exams.find((item) => item.code === "SY0-701") || catalog.exams[0];
const api = createApiClient(base);
const health = await api.health();
assert.equal(health.ok, true);
assert.ok(health.tutorProvider === "deterministic-fallback" || health.openaiConfigured === false,
  "refusing to call the tutor when the server may use a paid API");
assert.deepEqual(await api.session(), { authenticated: false, studentId: null });

const studentId = "00000000-0000-4000-8000-000000000042";
const question = chooseQuestions(exam, exam.domains[0].id, 1, () => 0)[0];
const wrong = (question.answerIndex + 1) % question.choices.length;
const score = scoreQuiz(exam, [question], [wrong]);
assert.equal(score.correct, 0);
const attempt = await api.attempt(attemptUpload(studentId, score));
assert.match(attempt.coachMessage, /Attempt saved/);
const plan = await api.studyPath({ studentId, examID: exam.id, daysAvailable: 3, minutesPerDay: 30 });
assert.equal(plan.plan.length, 3);
assert.equal(plan.adaptiveFocus, question.domainID);
const context = mistakeContext(studentId, score, score.results[0]);
const tutor = await api.tutor(context);
assert.equal(tutor.source, "local");
assert.ok(tutor.guidingQuestions.length > 0);
const chat = await api.chat(context, [{ role: "user", content: "Which clue matters?" }]);
assert.equal(chat.source, "local");
assert.ok(chat.reply.length > 0);
console.log(JSON.stringify({ studentId, exam: exam.code, question: question.id, attempt: "server saved", planDays: plan.plan.length, tutorSource: tutor.source, chatSource: chat.source }));
