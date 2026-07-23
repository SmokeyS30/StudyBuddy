# StudyBuddy 3.0 App Review Notes

Use the following in App Store Connect under App Review Information > Notes:

```text
StudyBuddy includes educational lab simulations under Learn > Labs.

These labs are fully contained SwiftUI training experiences. The command terminal parses a fixed set of educational commands and changes only in-memory lab state. It does not invoke a shell, execute user-supplied code, download executable code, access files outside the app container, or modify the iOS device.

The support workstation, printer workbench, firewall console, packet tester, and SOC dashboard are original in-app simulations. They do not launch other apps, replace the iOS Home Screen, connect to real infrastructure, or bundle another operating system.

The app uses original StudyBuddy interface assets and original exam-objective-aligned scenarios. It does not contain copied certification exam questions, exam dumps, official vendor logos, or claims of vendor endorsement.

Review path:
1. Open Learn.
2. Open the mode menu and select Labs.
3. Select Guided or Challenge.
4. Open either environment for the selected exam.
5. Complete actions and select Submit Work to view grading.
```

## Review Preparation

- Keep the in-app statement that each lab is isolated and cannot change a real device or network.
- Do not describe the terminal as a real shell, remote shell, virtual machine, or code runner.
- Do not use Microsoft, Windows, CompTIA, or certification-vendor logos without documented permission.
- Keep `StudyBuddy` as the app name and use certification names only to describe compatibility or study coverage.
- Keep the independent-study disclaimer visible in the app and metadata.
- Confirm the AI server is online for AI tutor review, although the hands-on labs themselves work locally.
- Include screenshots showing the lab inside StudyBuddy navigation so it cannot be mistaken for an alternate iOS Home Screen.

The design is intended to align with Apple's self-contained-app and intellectual-property requirements, but App Review decisions remain Apple's. Recheck the current guidelines before each submission:

https://developer.apple.com/app-store/review/guidelines/
