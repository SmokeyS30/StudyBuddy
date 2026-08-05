import crypto from "node:crypto";
import { mkdir, readFile, rename, writeFile } from "node:fs/promises";
import path from "node:path";
import { verifyAssertion, verifyAttestation } from "node-app-attest";

const CHALLENGE_TTL_MS = 2 * 60 * 1000;
const MAX_CHALLENGES = 2_048;
const VALID_MODES = new Set(["off", "monitor", "enforce"]);
const VALID_PURPOSES = new Set(["attestation", "assertion"]);

export const APP_ATTEST_HEADERS = {
  assertion: "x-studybuddy-app-attest-assertion",
  challenge: "x-studybuddy-app-attest-challenge",
  keyId: "x-studybuddy-app-attest-key-id"
};

export class AppAttestError extends Error {
  constructor(code, message, statusCode = 401) {
    super(message);
    this.name = "AppAttestError";
    this.code = code;
    this.statusCode = statusCode;
  }
}

export class AppAttestManager {
  constructor({
    dataDir,
    mode = "off",
    teamIdentifier,
    bundleIdentifier,
    allowDevelopmentEnvironment = false,
    verifier = { verifyAttestation, verifyAssertion },
    now = () => Date.now()
  }) {
    const normalizedMode = String(mode).trim().toLowerCase();
    if (!VALID_MODES.has(normalizedMode)) {
      throw new Error(`Invalid APP_ATTEST_MODE: ${mode}`);
    }

    this.dataDir = dataDir;
    this.stateFile = path.join(dataDir, "app-attest.json");
    this.mode = normalizedMode;
    this.teamIdentifier = String(teamIdentifier || "").trim();
    this.bundleIdentifier = String(bundleIdentifier || "").trim();
    this.allowDevelopmentEnvironment = Boolean(allowDevelopmentEnvironment);
    this.verifier = verifier;
    this.now = now;
    this.operationQueue = Promise.resolve();
    this.state = emptyState();

    if (this.mode === "enforce" && !this.isConfigured) {
      throw new Error("APP_ATTEST_TEAM_ID and APP_ATTEST_BUNDLE_ID are required when App Attest enforcement is enabled.");
    }
  }

  get isConfigured() {
    return Boolean(this.teamIdentifier && this.bundleIdentifier);
  }

  async initialize() {
    await mkdir(this.dataDir, { recursive: true });

    try {
      const parsed = JSON.parse(await readFile(this.stateFile, "utf8"));
      this.state = {
        version: 1,
        challenges: parsed.challenges && typeof parsed.challenges === "object" ? parsed.challenges : {},
        keys: parsed.keys && typeof parsed.keys === "object" ? parsed.keys : {}
      };
    } catch (error) {
      if (error?.code !== "ENOENT") throw error;
      this.state = emptyState();
      await this.persist();
    }

    await this.enqueue(async () => {
      this.removeExpiredChallenges();
      await this.persist();
    });
  }

  status() {
    return {
      mode: this.mode,
      configured: this.isConfigured,
      allowDevelopmentEnvironment: this.allowDevelopmentEnvironment,
      registeredKeyCount: Object.keys(this.state.keys).length
    };
  }

  async issueChallenge(purpose) {
    return this.enqueue(async () => {
      if (!VALID_PURPOSES.has(purpose)) {
        throw new AppAttestError("app_attest_invalid_purpose", "Invalid App Attest challenge purpose.", 400);
      }

      this.removeExpiredChallenges();
      this.trimChallenges();

      const challenge = crypto.randomBytes(32).toString("base64url");
      const createdAt = this.now();
      this.state.challenges[hashChallenge(challenge)] = {
        purpose,
        createdAt,
        expiresAt: createdAt + CHALLENGE_TTL_MS
      };
      await this.persist();

      return {
        challenge,
        expiresInSeconds: Math.floor(CHALLENGE_TTL_MS / 1_000)
      };
    });
  }

  async register({ keyId, challenge, attestationObject }) {
    return this.enqueue(async () => {
      if (!this.isConfigured) {
        throw new AppAttestError("app_attest_not_configured", "App Attest is not configured on this server.", 503);
      }

      validateKeyId(keyId);
      await this.consumeChallenge(challenge, "attestation");

      let result;
      try {
        result = await this.verifier.verifyAttestation({
          attestation: decodeBase64(attestationObject, "attestation object", 512 * 1_024),
          challenge,
          keyId,
          bundleIdentifier: this.bundleIdentifier,
          teamIdentifier: this.teamIdentifier,
          allowDevelopmentEnvironment: this.allowDevelopmentEnvironment
        });
      } catch {
        throw new AppAttestError("app_attest_invalid_attestation", "The Apple attestation could not be verified.");
      }

      if (!result?.publicKey) {
        throw new AppAttestError("app_attest_invalid_attestation", "Apple attestation did not contain a public key.");
      }

      const existing = this.state.keys[keyId];
      if (existing && existing.publicKey !== result.publicKey) {
        throw new AppAttestError("app_attest_key_conflict", "This App Attest key is already registered with different key material.");
      }

      const now = new Date(this.now()).toISOString();
      this.state.keys[keyId] = {
        keyId,
        publicKey: result.publicKey,
        receipt: encodeOptionalBuffer(result.receipt),
        environment: result.environment || (this.allowDevelopmentEnvironment ? "development-or-production" : "production"),
        signCount: existing?.signCount || 0,
        createdAt: existing?.createdAt || now,
        lastSeenAt: now
      };
      await this.persist();

      return { keyId, registered: true };
    });
  }

  async verifyProtectedRequest({ method, requestPath, rawBody, headers }) {
    return this.enqueue(async () => {
      if (this.mode === "off") {
        return { status: "disabled" };
      }

      if (!this.isConfigured) {
        return this.handleVerificationFailure(
          new AppAttestError("app_attest_not_configured", "App Attest is not configured on this server.", 503)
        );
      }

      const keyId = headerValue(headers, APP_ATTEST_HEADERS.keyId);
      const challenge = headerValue(headers, APP_ATTEST_HEADERS.challenge);
      const assertionValue = headerValue(headers, APP_ATTEST_HEADERS.assertion);

      if (!keyId || !challenge || !assertionValue) {
        return this.handleVerificationFailure(
          new AppAttestError("app_attest_missing", "This request does not include an App Attest assertion.")
        );
      }

      try {
        validateKeyId(keyId);
        await this.consumeChallenge(challenge, "assertion");

        const keyRecord = this.state.keys[keyId];
        if (!keyRecord) {
          throw new AppAttestError("app_attest_key_unknown", "The App Attest key is not registered.");
        }

        const payload = buildProtectedPayload(method, requestPath, challenge, rawBody);
        const result = await this.verifier.verifyAssertion({
          assertion: decodeBase64(assertionValue, "assertion", 128 * 1_024),
          payload,
          publicKey: keyRecord.publicKey,
          bundleIdentifier: this.bundleIdentifier,
          teamIdentifier: this.teamIdentifier,
          signCount: keyRecord.signCount
        });

        if (!Number.isInteger(result?.signCount) || result.signCount <= keyRecord.signCount) {
          throw new AppAttestError("app_attest_counter_replay", "The App Attest assertion counter did not advance.");
        }

        keyRecord.signCount = result.signCount;
        keyRecord.lastSeenAt = new Date(this.now()).toISOString();
        await this.persist();
        return { status: "verified", keyId, signCount: result.signCount };
      } catch (error) {
        const normalized = error instanceof AppAttestError
          ? error
          : new AppAttestError("app_attest_invalid", "The App Attest assertion could not be verified.");
        return this.handleVerificationFailure(normalized);
      }
    });
  }

  handleVerificationFailure(error) {
    if (this.mode === "enforce") {
      throw error;
    }

    console.warn(`[AppAttest monitor] ${error.code}: ${error.message}`);
    return { status: "monitor-allowed", reason: error.code };
  }

  async consumeChallenge(challenge, purpose) {
    if (typeof challenge !== "string" || challenge.length < 32 || challenge.length > 256) {
      throw new AppAttestError("app_attest_challenge_invalid", "The App Attest challenge is invalid.");
    }

    const challengeKey = hashChallenge(challenge);
    const record = this.state.challenges[challengeKey];
    delete this.state.challenges[challengeKey];
    await this.persist();

    if (!record || record.purpose !== purpose || record.expiresAt <= this.now()) {
      throw new AppAttestError("app_attest_challenge_expired", "The App Attest challenge is missing, expired, or already used.");
    }
  }

  removeExpiredChallenges() {
    const now = this.now();
    for (const [key, value] of Object.entries(this.state.challenges)) {
      if (!value?.expiresAt || value.expiresAt <= now) {
        delete this.state.challenges[key];
      }
    }
  }

  trimChallenges() {
    const entries = Object.entries(this.state.challenges);
    if (entries.length < MAX_CHALLENGES) return;

    entries
      .sort((a, b) => (a[1]?.createdAt || 0) - (b[1]?.createdAt || 0))
      .slice(0, entries.length - MAX_CHALLENGES + 1)
      .forEach(([key]) => delete this.state.challenges[key]);
  }

  async persist() {
    const temporaryPath = `${this.stateFile}.${crypto.randomUUID()}.tmp`;
    await writeFile(temporaryPath, JSON.stringify(this.state, null, 2), { mode: 0o600 });
    await rename(temporaryPath, this.stateFile);
  }

  enqueue(operation) {
    const result = this.operationQueue.then(operation, operation);
    this.operationQueue = result.catch(() => {});
    return result;
  }
}

export function buildProtectedPayload(method, requestPath, challenge, rawBody) {
  const prefix = Buffer.from(`${String(method).toUpperCase()}\n${requestPath}\n${challenge}\n`, "utf8");
  return Buffer.concat([prefix, Buffer.isBuffer(rawBody) ? rawBody : Buffer.from(rawBody || "")]);
}

function emptyState() {
  return { version: 1, challenges: {}, keys: {} };
}

function hashChallenge(challenge) {
  return crypto.createHash("sha256").update(challenge, "utf8").digest("hex");
}

function validateKeyId(keyId) {
  if (typeof keyId !== "string" || keyId.length < 20 || keyId.length > 256) {
    throw new AppAttestError("app_attest_key_invalid", "The App Attest key identifier is invalid.", 400);
  }
}

function decodeBase64(value, label, maximumBytes) {
  if (typeof value !== "string" || !value.length) {
    throw new AppAttestError("app_attest_payload_invalid", `The ${label} is missing.`, 400);
  }

  const normalized = value.replace(/\s/g, "");
  if (!/^[A-Za-z0-9+/]*={0,2}$/.test(normalized)) {
    throw new AppAttestError("app_attest_payload_invalid", `The ${label} is not valid Base64.`, 400);
  }

  const decoded = Buffer.from(normalized, "base64");
  if (!decoded.length || decoded.length > maximumBytes) {
    throw new AppAttestError("app_attest_payload_invalid", `The ${label} has an invalid size.`, 400);
  }
  return decoded;
}

function encodeOptionalBuffer(value) {
  if (!value) return null;
  if (Buffer.isBuffer(value)) return value.toString("base64");
  if (value instanceof Uint8Array) return Buffer.from(value).toString("base64");
  return typeof value === "string" ? value : null;
}

function headerValue(headers, name) {
  const value = headers?.[name];
  return Array.isArray(value) ? value[0] : value;
}
