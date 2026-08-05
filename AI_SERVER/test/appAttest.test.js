import assert from "node:assert/strict";
import { mkdtemp } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { APP_ATTEST_HEADERS, AppAttestManager, buildProtectedPayload } from "../appAttest.js";

const keyId = Buffer.alloc(32, 7).toString("base64");
const attestationObject = Buffer.from("test-attestation").toString("base64");
const assertionObject = Buffer.from("test-assertion").toString("base64");

function fakeVerifier() {
  return {
    verifyAttestation(options) {
      assert.equal(options.keyId, keyId);
      assert.equal(options.bundleIdentifier, "com.smokeys30.studybuddy");
      assert.equal(options.teamIdentifier, "S6L62N62M4");
      assert.equal(options.attestation.toString(), "test-attestation");
      return {
        keyId,
        publicKey: "-----BEGIN PUBLIC KEY-----\ntest\n-----END PUBLIC KEY-----",
        receipt: Buffer.from("receipt")
      };
    },
    verifyAssertion(options) {
      assert.equal(options.assertion.toString(), "test-assertion");
      assert.equal(options.publicKey.includes("PUBLIC KEY"), true);
      return { signCount: options.signCount + 1 };
    }
  };
}

async function makeManager(mode, verifier = fakeVerifier()) {
  const dataDir = await mkdtemp(path.join(os.tmpdir(), "studybuddy-app-attest-"));
  const manager = new AppAttestManager({
    dataDir,
    mode,
    teamIdentifier: "S6L62N62M4",
    bundleIdentifier: "com.smokeys30.studybuddy",
    allowDevelopmentEnvironment: true,
    verifier
  });
  await manager.initialize();
  return manager;
}

async function registerKey(manager) {
  const { challenge } = await manager.issueChallenge("attestation");
  return manager.register({ keyId, challenge, attestationObject });
}

test("registers a key and verifies a protected request", async () => {
  const manager = await makeManager("enforce");
  const registration = await registerKey(manager);
  assert.deepEqual(registration, { keyId, registered: true });

  const { challenge } = await manager.issueChallenge("assertion");
  const rawBody = Buffer.from(JSON.stringify({ studentId: "test-student" }));
  const result = await manager.verifyProtectedRequest({
    method: "POST",
    requestPath: "/api/learning/attempt",
    rawBody,
    headers: {
      [APP_ATTEST_HEADERS.keyId]: keyId,
      [APP_ATTEST_HEADERS.challenge]: challenge,
      [APP_ATTEST_HEADERS.assertion]: assertionObject
    }
  });

  assert.equal(result.status, "verified");
  assert.equal(result.signCount, 1);
  assert.equal(manager.status().registeredKeyCount, 1);
});

test("rejects a replayed challenge in enforce mode", async () => {
  const manager = await makeManager("enforce");
  await registerKey(manager);
  const { challenge } = await manager.issueChallenge("assertion");
  const request = {
    method: "POST",
    requestPath: "/api/tutor/chat",
    rawBody: Buffer.from("{}"),
    headers: {
      [APP_ATTEST_HEADERS.keyId]: keyId,
      [APP_ATTEST_HEADERS.challenge]: challenge,
      [APP_ATTEST_HEADERS.assertion]: assertionObject
    }
  };

  await manager.verifyProtectedRequest(request);
  await assert.rejects(
    manager.verifyProtectedRequest(request),
    (error) => error.code === "app_attest_challenge_expired"
  );
});

test("allows legacy requests only in monitor mode", async () => {
  const manager = await makeManager("monitor");
  const result = await manager.verifyProtectedRequest({
    method: "POST",
    requestPath: "/api/tutor/mistake",
    rawBody: Buffer.from("{}"),
    headers: {}
  });

  assert.equal(result.status, "monitor-allowed");
  assert.equal(result.reason, "app_attest_missing");
});

test("rejects missing assertions in enforce mode", async () => {
  const manager = await makeManager("enforce");
  await assert.rejects(
    manager.verifyProtectedRequest({
      method: "POST",
      requestPath: "/api/tutor/mistake",
      rawBody: Buffer.from("{}"),
      headers: {}
    }),
    (error) => error.code === "app_attest_missing"
  );
});

test("builds the same byte payload expected from the iOS client", () => {
  const result = buildProtectedPayload(
    "post",
    "/api/tutor/mistake",
    "challenge-value",
    Buffer.from('{"answer":1}')
  );

  assert.equal(
    result.toString(),
    'POST\n/api/tutor/mistake\nchallenge-value\n{"answer":1}'
  );
});
