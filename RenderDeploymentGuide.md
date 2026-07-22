# Deploy StudyBuddy AI Server On Render

## Recommended Source

Use GitHub source code, not an image URL.

You have two clean choices:

- Whole app repo: push the full `StudyBuddy` folder to GitHub. Render will use the root `render.yaml` and deploy only `AI_SERVER/`.
- Server-only repo: push the contents of `AI_SERVER/` to a new GitHub repo. Use the `render.yaml` inside `AI_SERVER/`.

Do not commit `AI_SERVER/.env`. That file contains your local OpenAI key and is intentionally ignored and excluded from zips.

## Live Production URL

Your Render service is live at:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```

Health check:

```text
https://studybuddy-ai-server-m5zi.onrender.com/health
```

StudyBuddy version `2.5` build `11` uses this URL by default for new installs and migrates older saved placeholder or localhost defaults to this hosted server.

## Render Settings

If you create the Render Web Service manually, use:

- Source: GitHub repo
- Runtime: Node
- Root Directory: `AI_SERVER` if you pushed the whole StudyBuddy project, blank if you pushed only the AI server files
- Build Command: `npm install`
- Start Command: `npm start`
- Health Check Path: `/health`
- Environment Variables:

```bash
OPENAI_API_KEY=sk-your-real-openai-key
OPENAI_MODEL=gpt-5.6-terra
HOST=0.0.0.0
STUDYBUDDY_DATA_DIR=./data
ALLOWED_ORIGINS=*
```

Do not set `PORT` manually unless Render tells you to. Render provides `PORT` for web services.

## Step By Step

1. Create a new GitHub repo, for example `studybuddy-ai-server`.
2. Upload the contents of `AI_SERVER/` to that repo, or upload the whole `StudyBuddy` project.
3. In Render, choose `New` > `Web Service`.
4. Select `Git Provider` and connect GitHub.
5. Choose the repo.
6. If using the whole StudyBuddy repo, set Root Directory to `AI_SERVER`.
7. Set Build Command to `npm install`.
8. Set Start Command to `npm start`.
9. Set Health Check Path to `/health`.
10. Add the environment variables above.
11. Click `Create Web Service`.
12. Wait for deploy to finish.
13. Open:

```text
https://your-render-service-name.onrender.com/health
```

14. Confirm the JSON says:

```json
{
  "ok": true,
  "openaiConfigured": true,
  "openaiKeyStatus": "configured"
}
```

15. Copy the Render URL into StudyBuddy Settings as the AI Tutor Server URL if you use a different hosted service later.

## Free Vs Paid Render

The included `render.yaml` uses `plan: free` so you can test without choosing a paid instance immediately. A free service can be slower to wake up. For production TestFlight/App Store use, switch the Render service to a paid instance so the AI tutor is more consistently available.

## Persistent Learning Profiles

The current server stores learning profiles in JSON under `data/`. On a free Render service this storage can reset after redeploys or restarts. For production, attach persistent storage or upgrade the server later to use a database.

## App Update After Deploy

For local simulator testing with a manually started local server, set StudyBuddy Settings to:

```text
http://127.0.0.1:8787
```

For TestFlight and real devices, StudyBuddy now defaults to your Render HTTPS URL:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```
