# StudyBuddy 2.7 Build 17

## What This Release Does

- Adds a dedicated Results tab with separate progress for A+ Core 1 220-1201, A+ Core 2 220-1202, and Security+ SY0-701.
- Shows latest score, readiness percentage, confidence average, PBQ average, score trend, objective results, and attempt history for each exam.
- Improves Quick Practice so the final screen shows score, percentage, a visual confidence signal bar, missed-question review, and a fresh targeted restart option.
- Filters Quick Practice through the active exam's objective domains so the 10-question set stays relevant to the selected exam.
- Makes Quick Practice reshuffle into a new batch when restarted or when difficulty changes.
- Makes Exam simulations use the selected difficulty, with the selected mode shown in the exam card and result record.
- Adds an AI Targeted Recovery Exam that prioritizes weak objectives based on saved attempt history.
- Improves confidence learning so StudyBuddy infers guessed, narrowed, and knew-it signals from answer behavior instead of asking the user to decide.
- Adds a Plan tab AI study target with daily minutes, suggested exam date, domain-by-domain time targets, and adaptive follow-up after completed topics.
- Adds first-time study defaults and baseline guidance: starter exam date, daily study target, and a prompt to take Quick Practice before StudyBuddy routes next steps.
- Adds hard achievements with progress bars and an animated congratulations overlay when an achievement is completed.
- Grays/zeros home dashboard readiness and progress signals until the user starts studying.
- Makes Settings > Reset clear all exam progress, results, attempts, confidence learning, achievement progress, and streak history, then returns the app to the Today tab.
- Calls the Today-tab navigation directly from the reset confirmation so the app leaves Settings immediately after reset.
- Bumps the App Store release train from `2.6` to `2.7` because App Store Connect closed the `2.6` train after approval.
- Changes the streak tracker to count consecutive app-open days instead of question/task activity, with missed days breaking the streak.
- Adds a four-choice safety pass for all practice questions so randomized Quick Practice and exam-mode single-choice items cannot appear with only one answer choice.
- Removes the Learn > Labs section until true in-app lab simulators can be built.
- Reworks Learn > Sheets so cheat sheets open as readable in-app PDFs using PDFKit.
- Expands useful exam-readiness tips and difficulty-aware question generation for all three built-in exams.

## Verified

- Xcode project file passed `plutil` validation.
- AI server JavaScript passed syntax validation.
- AI server start script passed shell syntax validation.
- iPhoneOS build passed with code signing disabled for validation.

Validation command:

```bash
xcodebuild -quiet -project StudyBuddy.xcodeproj -scheme StudyBuddy -sdk iphoneos -destination generic/platform=iOS -derivedDataPath work/DerivedData CODE_SIGNING_ALLOWED=NO build
```

## Version Info For Xcode

- Marketing Version: `2.7`
- Build: `17`
- Bundle ID currently in the project: `com.smokeys30.studybuddy`
- iOS target: `iOS 17+`
- Main project file: `StudyBuddy.xcodeproj`
- Hosted AI server: `https://studybuddy-ai-server-m5zi.onrender.com`

## TestFlight Action Steps

1. Open `StudyBuddy.xcodeproj` in Xcode.
2. Select the `StudyBuddy` target.
3. Confirm Signing & Capabilities uses your Apple Developer Team.
4. Confirm Version is `2.7` and Build is `17`.
5. Run the app in the simulator or on your iPhone.
6. Confirm the Results tab opens and switches between all three exams.
7. Confirm Quick Practice shows a score screen after the last question.
8. Confirm Quick Practice questions match only the selected exam.
9. Confirm changing Quick or Exam difficulty creates a fresh difficulty-matched session.
10. Confirm the Today dashboard shows first-time defaults, zeroed/gray metrics, and achievements before studying.
11. Confirm completing an achievement displays the congratulations animation.
12. Confirm Learn > Sheets opens in-app PDFs.
13. Confirm Learn no longer shows the old Labs section.
14. In Practice > Quick, confirm every question shows multiple answer buttons, not a one-answer screen.
15. Open Settings, reset all StudyBuddy progress, and confirm the app returns to the Today tab with progress/results cleared.
16. Confirm the dashboard streak is based on opening the app on consecutive days, not simply answering a question.
17. Open Settings and confirm the AI Tutor Server URL is:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```

18. Tap `Check AI Server Now`.
19. Confirm Status is `Online` and OpenAI key is `Configured`.
20. Select `Any iOS Device` as the destination.
21. Choose Product > Archive.
22. Upload through Organizer to App Store Connect.

## Notes

StudyBuddy uses original objective-aligned practice content. It does not include copied paid-bank questions, real exam dumps, or CompTIA's proprietary scoring algorithm.
