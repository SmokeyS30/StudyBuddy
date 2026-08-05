# Deploy StudyBuddy AI Server On Render

## Current Production Target

- App: StudyBuddy `3.0` build `20`
- Server package: `1.2.0`
- Service URL: `https://studybuddy-ai-server-m5zi.onrender.com`
- Health URL: `https://studybuddy-ai-server-m5zi.onrender.com/health`
- Instance: Render Starter
- Persistent disk: 1 GB mounted at `/var/data`
- Initial App Attest mode: `monitor`

Use GitHub source code, not an image URL. The Starter service keeps the AI server available without free-tier spin-down, and the disk preserves learner profiles plus registered App Attest public keys and counters across deploys.

## Which Blueprint To Use

- Whole StudyBuddy repository: use the root `render.yaml`. It sets `rootDir: AI_SERVER`.
- Server-only repository containing the contents of `AI_SERVER/`: use `AI_SERVER/render.yaml` as that repository's root Blueprint.

Do not commit `AI_SERVER/.env`. The local file contains your OpenAI key and is intentionally ignored.

## Blueprint Settings

The included Blueprints configure:

```yaml
runtime: node
plan: starter
buildCommand: npm install
startCommand: npm start
healthCheckPath: /health
disk:
  name: studybuddy-data
  mountPath: /var/data
  sizeGB: 1
```

They also set these non-secret environment values:

```text
OPENAI_MODEL=gpt-5.6-terra
HOST=0.0.0.0
STUDYBUDDY_DATA_DIR=/var/data/studybuddy
ALLOWED_ORIGINS=*
APP_ATTEST_MODE=monitor
APP_ATTEST_TEAM_ID=S6L62N62M4
APP_ATTEST_BUNDLE_ID=com.smokeys30.studybuddy
APP_ATTEST_ALLOW_DEVELOPMENT=false
```

`OPENAI_API_KEY` is declared with `sync: false`; enter its value in the Render dashboard. Do not set `PORT` manually because Render supplies it.

## Apply The Update

1. Push the updated StudyBuddy repository to GitHub.
2. Sign in to Render and open the existing `studybuddy-ai-server` service or its Blueprint.
3. Sync the latest Blueprint commit.
4. Review the billing confirmation before applying it.
5. Confirm the instance type is `Starter`.
6. Confirm the disk is 1 GB and mounted at `/var/data`.
7. Confirm `OPENAI_API_KEY` still has its secret value.
8. Confirm `APP_ATTEST_MODE` is `monitor`, not `enforce`.
9. Deploy the latest commit.
10. Open the health URL and confirm a response shaped like:

```json
{
  "ok": true,
  "openaiConfigured": true,
  "openaiKeyStatus": "configured",
  "appAttest": {
    "mode": "monitor",
    "configured": true
  }
}
```

11. Test one AI action from build 19 to confirm backward compatibility.
12. Upload build 20 to TestFlight and test an AI action on a physical iPhone.
13. Follow `AppAttestDeploymentGuide.md` before changing App Attest to `enforce`.

## Persistent State

The server writes these files beneath `/var/data/studybuddy`:

- `profiles.json`: adaptive learner profiles.
- `app-attest.json`: verified public keys, receipts, assertion counters, and registration timestamps.

Do not delete the disk or `app-attest.json` during a routine deploy. Losing App Attest state forces installed apps to register a new key and can interrupt protected AI requests.

## Cost

At current listed rates, budget approximately `$7.25/month` before bandwidth, OpenAI usage, workspace charges, and taxes:

- Starter web service: about `$7/month`.
- 1 GB persistent disk: `$0.25/month`.

The disk is the extra `$0.25`; the Starter service itself is the larger part of the monthly hosting cost. Confirm the total shown by Render before accepting the plan change because prices can change.

## Local Simulator

For a manually started local server, use:

```text
http://127.0.0.1:8787
```

Local development may use `APP_ATTEST_ALLOW_DEVELOPMENT=true`. The simulator does not provide production App Attest, so final validation must use a physical device with the TestFlight build.

For TestFlight and App Store installs, keep the default HTTPS URL:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```
