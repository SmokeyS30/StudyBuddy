# StudyBuddy App Attest Deployment Guide

## Release Decision

- Marketing version: `3.0`
- New build: `20`
- Previous compatible build: `19`
- Server package: `1.2.0`
- Initial server mode: `monitor`
- Final server mode: `enforce`

App Attest changes the signed iOS binary and its entitlements, so build 20 must be archived and uploaded. It does not require a new App Store version: keep version `3.0` and increment only the build from `19` to `20`.

## What Is Protected

Build 20 obtains a one-time challenge, registers an Apple-attested key, and adds a signed assertion to these requests:

- `POST /api/tutor/mistake`
- `POST /api/tutor/chat`
- `POST /api/learning/attempt`
- `POST /api/study-path`

The server verifies the app identity, assertion signature, challenge, request bytes, and increasing counter. The challenge and registration endpoints remain publicly reachable because they bootstrap the trust relationship.

## Why Monitor Comes First

In `monitor` mode, valid build-20 assertions are verified and recorded, while requests without a usable assertion are temporarily allowed. This keeps build 19, the simulator, and unsupported devices working during rollout. In `enforce` mode, protected routes return `401` for missing or invalid App Attest proof.

## Render Configuration

The root and server-only `render.yaml` files specify:

```yaml
plan: starter
disk:
  name: studybuddy-data
  mountPath: /var/data
  sizeGB: 1
```

They also configure:

```text
STUDYBUDDY_DATA_DIR=/var/data/studybuddy
APP_ATTEST_MODE=monitor
APP_ATTEST_TEAM_ID=S6L62N62M4
APP_ATTEST_BUNDLE_ID=com.smokeys30.studybuddy
APP_ATTEST_ALLOW_DEVELOPMENT=false
```

Keep `OPENAI_API_KEY` as a secret value in Render. Never put it in GitHub or `render.yaml`.

## Deploy In This Order

1. Commit and push the server and iOS changes.
2. In Render, open the StudyBuddy service and apply or sync the updated Blueprint.
3. Confirm the service uses the Starter instance and has a 1 GB disk mounted at `/var/data`.
4. Confirm the environment variables above are present and `APP_ATTEST_MODE` is `monitor`.
5. Deploy the latest commit.
6. Open `https://studybuddy-ai-server-m5zi.onrender.com/health`.
7. Confirm `ok` is `true` and `appAttest.mode` is `monitor`.
8. Confirm a build-19 AI action still works before uploading build 20.
9. Archive StudyBuddy version `3.0` build `20` in Xcode and upload it to TestFlight.
10. Install build 20 from TestFlight on a physical iPhone. App Attest cannot be fully production-tested in the simulator.
11. Complete an AI tutor action and submit a practice result.
12. Check Render logs for a successfully verified App Attest request and confirm no persistence errors.
13. Restart or redeploy the service, repeat an AI action, and confirm the registered key still works. This verifies the disk is preserving state.

## Move To Enforcement

Do not enforce immediately after the first successful request. Leave `monitor` enabled while build 19 remains in meaningful use and while build 20 is being tested.

When ready:

1. In Render, change `APP_ATTEST_MODE` from `monitor` to `enforce`.
2. Deploy the environment-variable change.
3. Confirm build 20 can submit an AI request.
4. Confirm malformed or unsigned requests receive `401`.
5. Watch error rates and Render logs during the rollout.

## Rollback

If legitimate build-20 users are rejected, change only `APP_ATTEST_MODE` back to `monitor` and redeploy. Do not delete `/var/data/studybuddy/app-attest.json`; it contains registered public keys and counters needed for existing installations.

## Expected Render Cost

The configured target is a Starter web service plus a 1 GB persistent disk. At the currently listed rates, budget approximately `$7.25/month` before bandwidth, OpenAI usage, workspace charges, and tax: about `$7/month` for Starter plus `$0.25/month` for the disk. Check the Render confirmation screen before applying the plan because provider pricing can change.

## App Store Privacy

The privacy policy now describes the App Attest key identifier, attestation material, integrity receipt, signed assertions, and counters. In App Store Connect, use a conservative disclosure of `Identifiers > Device ID` for `App Functionality`, linked to the device, and not used for tracking. Keep the existing study-performance and usage disclosures for the AI tutor.

App privacy answers are a factual declaration of the released app and server, not a one-time setup choice. Recheck them whenever data storage, analytics, advertising, accounts, or third-party services change.
