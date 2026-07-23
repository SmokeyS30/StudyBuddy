# StudyBuddy 3.0 Build 19

## What This Release Adds

- Replaces decision-question labs with stateful, hands-on training environments.
- Adds two original environments for each supported exam.
- Adds Guided mode with coaching and mobile command shortcuts.
- Adds Challenge mode without coaching or command shortcuts.
- Grades completed actions and resulting environment state rather than selected answers.
- Saves the best score for each environment under its matching exam.
- Includes lab progress in StudyBuddy's started-studying state and Reset All Progress flow.

## Hands-On Environments

### A+ Core 1 220-1201

- **Floor 2 Name Resolution:** A virtual command terminal that accepts typed `ipconfig`, `ping`, and `nslookup` commands. The terminal maintains simulated network and DNS state, returns realistic output, recognizes unsupported commands, and grades diagnosis, repair, and verification.
- **Loose Toner Service Call:** An interactive printer workbench with inspectable tray, toner, fuser, and output components; media configuration; test printing; rub testing; and service-ticket documentation.

### A+ Core 2 220-1202

- **Service Fails After Reboot:** An in-app support workstation with Services, Event Log, System, and Ticket tools. Startup configuration and service state persist through the simulated reboot.
- **Redirecting Browser Ticket:** An incident workstation with network isolation, startup-item inspection, scanner updates, full scanning, quarantine, connectivity restoration, browser verification, and documentation.

### Security+ SY0-701

- **Exposed Admin Interface:** A firewall console with a rule list, source-scope editor, logging control, apply state, packet tester, and audit trail.
- **Impossible Travel Investigation:** A SOC dashboard with identity evidence, MFA events, mailbox activity, evidence preservation, incident classification, containment actions, and analyst notes.

## Safety And App Store Scope

- Every environment is an isolated SwiftUI simulation.
- Terminal commands are parsed by StudyBuddy and never execute on iOS.
- Simulated configuration changes never alter the device, a real account, or a real network.
- The app does not bundle, emulate, or redistribute Microsoft Windows.
- The support workstation uses original StudyBuddy interface assets and generic system-tool concepts.
- Lab content is original and is not copied from CompTIA exams or paid study banks.
- StudyBuddy does not claim that these are official CompTIA labs or live exam items.

## Verified

- iPhoneOS build passed with code signing disabled.
- iPhone 17 Pro simulator build passed.
- App launch and Learn > Labs navigation passed.
- Typed terminal command parsing, changing DNS state, guided command shortcuts, scoring, and results passed.
- Support workstation Event Log and Services interactions passed.
- Firewall rule selection, source restriction, logging, apply state, and packet tester navigation passed.
- Security+ SOC alert and evidence navigation passed.

## Version Info For Xcode

- Marketing Version: `3.0`
- Build: `19`
- Bundle ID: `com.smokeys30.studybuddy`
- iOS target: `iOS 17+`
- Main project file: `StudyBuddy.xcodeproj`
- Hosted AI server: `https://studybuddy-ai-server-m5zi.onrender.com`

## Xcode Test Steps

1. Open `StudyBuddy.xcodeproj`.
2. Select the `StudyBuddy` scheme and an iPhone simulator.
3. Run the app and wait for the welcome screen to finish.
4. Select an exam, open Learn, open the mode menu, and select Labs.
5. Run each environment in Guided mode first.
6. In the Core 1 terminal, type `ipconfig /all`, test both IP paths, observe the failed name lookup, flush DNS, and verify name resolution.
7. In the printer bench, inspect the tray and fuser, set Labels, print a test, perform the rub test, and document the ticket.
8. In the Core 2 service workstation, review events, configure Automatic startup, restart, refresh status, and document the result.
9. In the malware workstation, isolate, inspect startup, update and scan, quarantine, restore connectivity, verify the browser, and document.
10. In the firewall console, edit Admin HTTPS, select the admin subnet, enable logging, apply, and test all three packet sources.
11. In the SOC dashboard, correlate identity and mailbox evidence, preserve it, classify the compromise, contain the account, and save an analyst note.
12. Confirm each results screen shows score, elapsed time, completed objectives, missing work, and recent activity.
13. Repeat selected environments in Challenge mode and confirm coaching and command shortcuts are hidden.
14. Reset all progress in Settings and confirm environment best scores clear with the rest of StudyBuddy.

## Important Note

These are purpose-built educational simulations, not full operating-system virtual machines. They reproduce the tools, state changes, troubleshooting flow, and grading needed for the learning objectives while remaining safe, offline-capable, mobile-friendly, and suitable for an iOS application.
