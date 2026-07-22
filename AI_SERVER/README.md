# StudyBuddy AI Server

This is the server-side AI tutor and adaptive learning engine for StudyBuddy. Keep your OpenAI API key here, not inside the iOS app.

## Current Status

- App version: `2.6`
- App build: `14`
- Server package version: `1.1.0`
- Server model: `gpt-5.6-terra`
- Hosted Render URL: `https://studybuddy-ai-server-m5zi.onrender.com`
- Local health check: `openaiConfigured: true`
- Live tutor verification: returned `source: openai`
- Measured sample usage: `310` input tokens, `567` output tokens, `877` total tokens.
- Measured sample cost: about `$0.0093` for one AI tutor response.

## What It Does

- Supports all three StudyBuddy exams: A+ Core 1 220-1201, A+ Core 2 220-1202, and Security+ SY0-701.
- Learns from full exam attempts, weak domains, PBQ scores, flags, inferred confidence signals, and missed-question review.
- Teaches with guiding questions instead of simply giving answers.
- Assigns targeted questions, spaced flashcards, PBQ drills, and video review after mistakes.
- Supports the app's Results and Plan flow by learning from repeated attempts, inferred confidence signals, weak objectives, and recovery exams.
- Runs with local fallback coaching when no OpenAI key is configured.

## Local Setup

1. Install Node.js 18 or newer.
2. Open Terminal.
3. Go to the server folder:

```bash
cd /Users/smokeys30/Documents/Codex/2026-07-07/c/outputs/StudyBuddy/AI_SERVER
```

4. Create your environment file:

```bash
cp .env.example .env
```

5. Edit `.env` and set your OpenAI key:

```bash
OPENAI_API_KEY=sk-your-key-here
OPENAI_MODEL=gpt-5.6-terra
PORT=8787
HOST=127.0.0.1
```

6. Start the server:

```bash
npm start
```

You can also double-click:

```text
start-ai-server.command
```

If `.env` is missing or does not have `OPENAI_API_KEY`, `start-ai-server.command` asks you to paste the key one time with hidden input, saves it locally in `AI_SERVER/.env`, and starts the server. The key is not stored in the iOS app. OpenAI API keys start with `sk-`; GitHub tokens such as `github_pat_...` will not work for this server.

Do not put `AI_SERVER/.env` into GitHub or a public zip. The project zip excludes `.env` on purpose.

For Xcode simulator runs, the shared `StudyBuddy` scheme automatically runs:

```text
ensure-ai-server.command
```

That script checks whether the server is already online. If it is not online, it starts the server in the background before the app launches.

7. Check it manually when needed:

```bash
curl http://127.0.0.1:8787/health
```

## Startup Behavior

The iOS app checks `/health` automatically when StudyBuddy opens and keeps retrying in the background. In `Settings`, the app shows whether the AI server is online, which model the server reports, and whether the OpenAI key is configured on the server.

The iOS app cannot start Node.js by itself on an iPhone or in TestFlight. For local simulator testing, the Xcode scheme runs `ensure-ai-server.command` before launch. For TestFlight or App Store, host this server so it is already running at an HTTPS URL.

## Connect From The iOS App

For the iPhone simulator:

1. Open StudyBuddy in Xcode.
2. Select the shared `StudyBuddy` scheme.
3. Run the app.
4. The scheme auto-starts the server.
5. StudyBuddy defaults to the hosted Render server. To test this local server, open Settings and change the AI Tutor Server URL to:

```text
http://127.0.0.1:8787
```

6. Take a practice exam.
7. Submit the exam.
8. Open a missed question.
9. Tap `Study Mistake with AI Tutor`.

For TestFlight or App Store, StudyBuddy now defaults to the hosted Render HTTPS URL:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```

The app will connect automatically at launch, but the hosted server must stay deployed and running.

## Hosting

You can host this server on Render, Railway, Fly.io, Heroku, a VPS, or another Node-capable provider.

For Render, use GitHub source code rather than an image URL. If you push the whole StudyBuddy project, set Render's Root Directory to `AI_SERVER`. If you push only the AI server files, leave Root Directory blank. This folder includes a `render.yaml` for a server-only GitHub repo, and the main StudyBuddy folder includes a root `render.yaml` for the full project.

Required environment variables:

```bash
OPENAI_API_KEY=sk-your-key-here
OPENAI_MODEL=gpt-5.6-terra
HOST=0.0.0.0
STUDYBUDDY_DATA_DIR=./data
ALLOWED_ORIGINS=*
```

Do not set `PORT` manually on Render unless Render tells you to. Render provides the `PORT` value for web services, and the server now binds to `0.0.0.0` automatically when a production port is supplied.

For production, use persistent storage for `STUDYBUDDY_DATA_DIR` so student learning profiles are not erased when the server restarts.

## Cost Estimate

The verified sample tutor response used `310` input tokens and `567` output tokens. At the listed `gpt-5.6-terra` pricing of `$2.50` per 1M input tokens and `$15.00` per 1M output tokens, that sample costs about `$0.0093`.

Estimated monthly AI tutor cost:

- 10 AI tutor responses per day: about `$2.78` per month.
- 25 AI tutor responses per day: about `$6.96` per month.
- 50 AI tutor responses per day: about `$13.92` per month.
- 100 AI tutor responses per day: about `$27.84` per month.

Budget around `$0.01` to `$0.02` per AI tutor interaction because longer chats, longer explanations, and larger learner profiles use more tokens. Health checks, built-in practice questions, flashcards, and normal app navigation do not call OpenAI.

## API Endpoints

- `GET /health`
- `POST /api/tutor/mistake`
- `POST /api/tutor/chat`
- `POST /api/learning/attempt`
- `POST /api/study-path`

## Privacy Notes

The app sends study context, not account passwords or payment information. Before launch, update your privacy policy to disclose that StudyBuddy may send exam performance, selected answers, inferred confidence signals, and study activity to your AI tutoring server to personalize learning.

## Legal Notes

StudyBuddy should use original practice content and public exam mechanics. Do not upload copied CertBlaster banks, exam dumps, or proprietary CompTIA/Pearson exam screens to this server.
