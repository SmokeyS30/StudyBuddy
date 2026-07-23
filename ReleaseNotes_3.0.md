# StudyBuddy 3.0 Build 18

## What This Release Adds

- Restores Learn > Labs as a true in-app interactive experience rather than a checklist.
- Adds a reusable lab engine shared by A+ Core 1 220-1201, A+ Core 2 220-1202, and Security+ SY0-701.
- Includes six original launch labs, with two labs mapped to each supported exam.
- Adds Guided mode with optional coaching, immediate decision feedback, and explanations.
- Adds Challenge mode with no hints or explanations until the scored result.
- Supports single-choice diagnosis, choose-two/choose-three decisions, and touch-built ordered workflows.
- Randomizes answer and action order each time a lab starts or restarts.
- Adds evidence panels, technician roles, realistic support scenarios, and exam-objective labels.
- Adds a scored results screen with pass status, time, mode, decision review, explanations, and best responses.
- Saves the best score for each lab under the active exam.
- Includes lab work in StudyBuddy's started-studying state and clears all lab progress during Reset All Progress.

## Included Labs

### A+ Core 1 220-1201

- Floor 2 Name Resolution
- Loose Toner Service Call

### A+ Core 2 220-1202

- Service Fails After Reboot
- Redirecting Browser Ticket

### Security+ SY0-701

- Exposed Admin Interface
- Impossible Travel Investigation

## Verified

- iPhoneOS build passed with code signing disabled.
- iPhone 17 Pro simulator build passed.
- App launch passed on an iPhone 17 Pro simulator running iOS 26.5.
- Learn > Labs navigation passed.
- Guided single-choice, multiple-select, ordered-workflow, immediate feedback, scoring, result review, and persisted best-score flows passed.

## Version Info For Xcode

- Marketing Version: `3.0`
- Build: `18`
- Bundle ID: `com.smokeys30.studybuddy`
- iOS target: `iOS 17+`
- Main project file: `StudyBuddy.xcodeproj`
- Hosted AI server: `https://studybuddy-ai-server-m5zi.onrender.com`

## Xcode Test Steps

1. Open `StudyBuddy.xcodeproj`.
2. Select the `StudyBuddy` scheme and an iPhone simulator.
3. Run the app and wait for the welcome screen to finish.
4. Select the Learn tab.
5. Open the Learn mode menu and select Labs.
6. Confirm the selected exam shows two matching labs.
7. Run one lab in Guided mode and confirm Check provides immediate feedback.
8. Return to Learn > Labs, select Challenge, and confirm coaching is unavailable during the lab.
9. Complete a lab and confirm the results screen shows score, time, mode, review, and best responses.
10. Start Fresh Variation and confirm answer/action ordering changes.
11. Switch to each supported exam and confirm its two labs are different and exam-specific.
12. Reset all progress in Settings and confirm lab best scores return to zero with the rest of the app.

## Scope Note

This release establishes the polished reusable lab foundation and the first six simulations. Terminal emulation, network topology builders, desktop simulators, hardware workbenches, and AI lab-action telemetry are planned expansions that can now be added without replacing this engine.

All lab scenarios and responses are original StudyBuddy content. They are not official CompTIA labs, copied exam questions, or live exam items.
