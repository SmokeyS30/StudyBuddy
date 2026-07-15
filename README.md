# StudyBuddy

StudyBuddy is a native SwiftUI iOS app starter for exam study planning, tuned first for CompTIA A+ Core 1 220-1201, CompTIA A+ Core 2 220-1202, and CompTIA Security+ SY0-701.

## What is included

- Today dashboard with countdown, daily study target, progress, focus areas, and coaching notes.
- Active exam picker for switching between A+ Core 1, A+ Core 2, and Security+.
- Study plan organized by objective domain.
- Learn tab with objectives, randomized flashcard decks, and exam strategy tips.
- Practice tab with randomized 10-question short tests, original prompts, and explanations.
- Exam simulation mode with randomized 90-question sessions, a 90-minute timer, PBQ-style items, matching scenarios, drag-to-order scenarios, scaled-score estimates, and result review.
- Settings tab for changing the active exam, displayed exam label, personal focus notes, and current-exam progress.
- Local-only storage with `UserDefaults`. No account, tracking, ads, or network calls.
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

## Fine-tune exam content

Edit `StudyBuddy/ExamCatalog.swift`.

Useful places to update:

- `domains`: official objectives, weighting, and focus summaries.
- `studyTasks`: daily checklist items.
- `flashcards`: quick recall material.
- `practiceQuestions`: original practice prompts and explanations.
- `simulations(for:)`: short and full exam simulator profiles and PBQ-style items.
- `quickTips`: short coaching notes.
- `exams`: the built-in list shown by the Settings exam picker.

Avoid adding real exam questions or copied paid question-bank content. For App Review and exam-vendor rules, keep questions original and include the existing independent-study disclaimer.

## Practice exam scoring

StudyBuddy uses CompTIA-style scaled-score estimates on a 100-900 range with public-style pass thresholds. CompTIA's exact scoring algorithm and real item weights are proprietary, so the app does not claim to reproduce official scoring exactly.

## App Store notes

- App category: Education.
- Privacy: No data collected, if you keep the app local-only.
- Suggested age rating: 4+ unless you add web access, social features, or user-generated content.
- Do not imply endorsement by CompTIA. Keep the app name as `StudyBuddy`, not `CompTIA StudyBuddy`.
- Before release, compare all objectives and weights against the current official CompTIA 220-1201, 220-1202, and Security+ objectives PDFs.
- App updates, bug fixes, and future iOS compatibility releases should be delivered through TestFlight and the App Store.
