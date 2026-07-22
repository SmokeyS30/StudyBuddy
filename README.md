# StudyBuddy

StudyBuddy is a native SwiftUI iOS app starter for exam study planning, tuned first for CompTIA A+ Core 1 220-1201, CompTIA A+ Core 2 220-1202, and CompTIA Security+ SY0-701.

## Current Release

- Version: `2.7`
- Build: `17`
- Release focus: immediate Today-tab return after all-progress reset, app-open streak tracking, four-choice protection for randomized questions, active-exam-only Quick Practice, achievements, adaptive plan targets, in-app cheat-sheet PDFs, exam-specific Results screen, and TestFlight readiness.
- Main project: `StudyBuddy.xcodeproj`
- AI server: `AI_SERVER/`
- App Store/TestFlight guide: `TestFlightGuide.md`
- Release action guide: `ReleaseNotes_2.7.md`
- Render hosting guide: `RenderDeploymentGuide.md`

## What is included

- Today dashboard with countdown, daily study target, app-open streak tracking, progress, focus areas, and more useful exam-ready coaching notes.
- First-time dashboard state that shows starter defaults, grayed/zeroed metrics, and a baseline Quick Practice recommendation until the user starts studying.
- Achievement system with hard targets, progress bars, and an animated congratulations overlay when an achievement is completed.
- Active exam picker for switching between A+ Core 1, A+ Core 2, and Security+.
- Study plan organized by objective domain.
- Learn tab with objectives, adaptive flashcard decks, cheat-sheet PDFs, video links, and exam strategy tips.
- Practice tab with difficulty-aware randomized Quick Practice, Real Exam Mode, Speed Training, Exam Stress Mode, Nightmare Mode, and AI Targeted Recovery Exam.
- Quick Practice is filtered to the selected exam so A+ Core 1, A+ Core 2, and Security+ questions do not mix, and every randomized question is guarded to show at least four answer choices.
- Results tab with per-exam score history, latest score, readiness, confidence, PBQ average, objective progress, trend review, and next-step coaching.
- Exam simulation mode with randomized 90-question sessions, a 90-minute timer, PBQs first, flag-for-review, review screen, automatic confidence tracking, hard PBQ-style items, matching scenarios, drag-to-order scenarios, scaled-score estimates, and result review.
- Expanded difficulty-aware question generation for all three built-in exams, with scenario-based prompts, domain-specific plausible distractors, fresh ordering each run, and no copied paid-bank content.
- Plan tab AI study target with recommended daily minutes, suggested exam date, domain-by-domain time targets, and adaptive follow-up after tasks are completed.
- Learn tab in-app PDF cheat sheets rendered with PDFKit.
- Optional AI tutor server in `AI_SERVER/` that learns from full attempts and missed-question reviews for all three exams.
- Automatic AI server startup support for Xcode simulator runs through the shared `StudyBuddy` scheme.
- A welcoming splash screen that appears when the app opens and stays visible for about 5 seconds.
- Settings tab for changing the active exam, displayed exam label, personal focus notes, all-progress reset, and AI server URL.
- Local storage with `UserDefaults`. The app only makes network calls when you configure the optional AI tutor server.
- A simple app icon asset and App Store/TestFlight checklist.
- A detailed Xcode-to-TestFlight walkthrough in `TestFlightGuide.md`.
- An update and future iOS maintenance plan in `UpdateAndMaintenancePlan.md`.

## Open in Xcode

1. Open `StudyBuddy.xcodeproj`.
2. Select the `StudyBuddy` target.
3. In Signing & Capabilities, choose your Apple Developer Team.
4. Change the bundle identifier from `com.example.studybuddy` to one you own, for example `com.yourcompany.studybuddy`.
5. Run on an iPhone simulator or connected iPhone.

## TestFlight path

For the full upload path, read `TestFlightGuide.md`.

## AI tutor server

The iOS app can call the optional Node server in `AI_SERVER/` after a practice exam or missed-question review. The server keeps the OpenAI API key off the device, stores a per-student learning profile, and returns Socratic coaching, weak-objective assignments, PBQ drills, flashcards, scenario review, and video review tasks.

StudyBuddy automatically checks the AI server `/health` endpoint when the app opens and keeps retrying in the background. The user does not need to press a button to connect. The status appears in `Settings` under `AI Tutor Server`.

The local AI server was verified with OpenAI billing enabled. A sample AI tutor interaction returned `source: openai`. That measured request used `310` input tokens and `567` output tokens, about `$0.0093` on `gpt-5.6-terra` at the listed pricing of `$2.50` per 1M input tokens and `$15.00` per 1M output tokens.

Hosted production server:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```

StudyBuddy uses this Render URL as the default AI Tutor Server URL for new installs and migrates older saved placeholder or localhost defaults to it. You can still enter a different server URL in Settings if you host another backend later.

For local simulator testing with a local Node server:

1. Open `StudyBuddy.xcodeproj`.
2. Select the shared `StudyBuddy` scheme.
3. Run the app.
4. Xcode runs `AI_SERVER/ensure-ai-server.command` before launching the simulator app.
5. Change the AI Tutor Server URL in Settings to `http://127.0.0.1:8787` if you intentionally want the simulator to use your local Node server instead of Render.

To use live OpenAI tutoring locally, run `AI_SERVER/start-ai-server.command` once and paste your API key when it asks. The script hides the key while you type, saves it in `AI_SERVER/.env`, and starts the server.

For TestFlight or the App Store, the included default is the hosted Render HTTPS URL above. The iOS app cannot run Node.js directly on the device, so the production server must stay deployed as an always-on hosted service.

Your local `AI_SERVER/.env` file is intentionally excluded from `StudyBuddy.zip`. If you move the project to another Mac or upload it to a host, create the environment variables again on that machine or hosting provider.

For Render hosting, read `RenderDeploymentGuide.md`. The project includes a root `render.yaml` for deploying the full StudyBuddy repo and an `AI_SERVER/render.yaml` for deploying a server-only repo.

## Fine-tune exam content

Edit `StudyBuddy/ExamCatalog.swift`.

Useful places to update:

- `domains`: official objectives, weighting, and focus summaries.
- `studyTasks`: daily checklist items.
- `flashcards`: quick recall material.
- `practiceQuestions`: original practice prompts and explanations.
- `aPlusCore1ChallengeQuestions`, `aPlusCore2ChallengeQuestions`, and `securityPlusChallengeQuestions`: harder randomized scenario banks.
- `aPlusCore1HardPerformanceItems`, `aPlusCore2HardPerformanceItems`, and `securityPlusHardPerformanceItems`: hard PBQ-style simulation items.
- `simulations(for:)`: short and full exam simulator profiles and PBQ-style items.
- `quickTips`: short coaching notes.
- `exams`: the built-in list shown by the Settings exam picker.
- `AI_SERVER/server.js`: AI tutor behavior, learning profile logic, and server-side OpenAI call.

Avoid adding real exam questions or copied paid question-bank content. For App Review and exam-vendor rules, keep questions original and include the existing independent-study disclaimer.

## Practice exam scoring

StudyBuddy uses CompTIA-style scaled-score estimates on a 100-900 range with public-style pass thresholds. CompTIA's exact scoring algorithm and real item weights are proprietary, so the app does not claim to reproduce official scoring exactly.

## App Store notes

- App category: Education.
- Privacy: If you enable the AI tutor server, disclose that exam performance, selected answers, inferred confidence signals, and study activity may be sent to your server for personalization.
- Suggested age rating: 4+ unless you add web access, social features, or user-generated content.
- Do not imply endorsement by CompTIA. Keep the app name as `StudyBuddy`, not `CompTIA StudyBuddy`.
- Before release, compare all objectives and weights against the current official CompTIA 220-1201, 220-1202, and Security+ objectives PDFs.
- App updates, bug fixes, and future iOS compatibility releases should be delivered through TestFlight and the App Store.
