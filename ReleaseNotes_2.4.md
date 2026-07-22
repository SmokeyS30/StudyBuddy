# StudyBuddy 2.4 Build 10

## What This Release Does

- Adds safer OpenAI API key validation for the AI server.
- Shows `configured`, `missing`, or `invalid-prefix` server key status in the app health flow.
- Keeps the AI server checking automatically when StudyBuddy opens.
- Keeps OpenAI keys on the server only, never inside the iOS app.
- Confirms live AI tutor calls work when billing is active.

## Verified Locally

- `GET /health` returned `openaiConfigured: true`.
- `GET /health` returned `openaiKeyStatus: configured`.
- `POST /api/tutor/mistake` returned a live AI tutor response with `source: openai`.
- iOS build passed with code signing disabled for validation.
- `StudyBuddy.zip` excludes `AI_SERVER/.env`, generated profile data, DerivedData, Git metadata, and Xcode user state.

## Version Info For Xcode

- Marketing Version: `2.4`
- Build: `10`
- Bundle ID currently in the project: `com.smokeys30.studybuddy`
- iOS target: `iOS 17+`
- Main project file: `StudyBuddy.xcodeproj`

## Local Run Steps

1. Open Terminal.
2. Run:

```bash
cd "/Users/smokeys30/Documents/Codex/2026-07-07/c/outputs/StudyBuddy/AI_SERVER"
./start-ai-server.command
```

3. Leave that Terminal window open while testing the simulator.
4. Open `StudyBuddy.xcodeproj` in Xcode.
5. Select the shared `StudyBuddy` scheme.
6. Run StudyBuddy in the iPhone simulator.
7. In the app, open `Settings` and confirm AI server status is `Online` and OpenAI key is `Configured`.

## TestFlight Action Steps

1. Host `AI_SERVER/` on a Node-capable provider such as Render, Railway, Fly.io, Heroku, or a VPS.
2. Add these environment variables on the host:

```bash
OPENAI_API_KEY=sk-your-key-here
OPENAI_MODEL=gpt-5.6-terra
PORT=8787
HOST=0.0.0.0
STUDYBUDDY_DATA_DIR=./data
ALLOWED_ORIGINS=*
```

3. Use persistent storage for `STUDYBUDDY_DATA_DIR`.
4. Confirm the hosted URL returns healthy JSON at `/health`.
5. In StudyBuddy Settings, set the AI Tutor Server URL to your hosted HTTPS server URL.
6. In Xcode, archive version `2.4`, build `10`.
7. Upload through Organizer to App Store Connect.
8. Test the TestFlight build and confirm the hosted server status is online.

## Cost Estimate

Measured sample AI tutor interaction:

- Input tokens: `310`
- Output tokens: `567`
- Total tokens: `877`
- Estimated cost: about `$0.0093`

Monthly examples:

- 10 AI tutor responses per day: about `$2.78` per month.
- 25 per day: about `$6.96` per month.
- 50 per day: about `$13.92` per month.
- 100 per day: about `$27.84` per month.

Health checks, built-in practice questions, flashcards, and normal app screens do not use OpenAI tokens.
