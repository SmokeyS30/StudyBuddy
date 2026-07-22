# StudyBuddy Update and Maintenance Plan

## Automatic updates

StudyBuddy should receive bug fixes and performance improvements through TestFlight and the App Store.

On iPhone, automatic updates are handled by iOS:

1. The user enables automatic app updates in iOS Settings.
2. You upload a new build from Xcode to App Store Connect.
3. Apple processes or reviews the build.
4. TestFlight testers or App Store users receive the updated app through Apple's update system.

The app should not download and run replacement app code by itself. Apple generally requires app binary changes to go through TestFlight or App Store review.

## Versioning

Use this pattern:

- Version `1.0`, Build `1`: first TestFlight build.
- Version `1.1`, Build `2`: practice exam simulator and PBQ update.
- Version `1.2`, Build `3`: randomized 10-question tests, 90-question simulations, answer choices, and flashcard decks.
- Version `1.3`, Build `4`: welcoming splash screen plus harder randomized question banks for A+ Core 1, A+ Core 2, and Security+.
- Version `1.4`, Build `5`: hard-only practice banks, tougher domain-specific distractors, harder PBQs for all three exams, and 5-second welcome screen.
- Version `2.2`, Build `8`: AI tutor server, adaptive coaching endpoints, and startup health checks.
- Version `2.3`, Build `9`: automatic AI server monitoring, background retry, and Xcode simulator auto-start helper.
- Version `2.4`, Build `10`: OpenAI key validation, invalid-token status reporting, and safer local server startup.
- Version `2.5`, Build `11`: live Render AI server wired into the app, production default server URL, and Xcode/TestFlight readiness update.
- Version `2.6`, Build `12`: harder randomized practice, selected difficulty fixes, Quick Practice score screen, per-exam Results tab, adaptive study targets, and in-app PDFs.
- Version `2.6`, Build `13`: automatic confidence inference, Quick Practice confidence signal bar, and Learn Labs removal until true in-app lab simulators are built.
- Version `2.6`, Build `14`: active-exam-only Quick Practice filtering, first-time study defaults, grayed starter dashboard, achievement progress bars, and completion celebration animation.
- Version `2.6`, Build `15`: complete all-progress reset with Today-tab navigation, app-open streak tracking, and four-choice protection for randomized practice questions.
- Version `2.6`, Build `16`: reset confirmation now directly returns the app to the Today page after clearing all progress.
- Version `2.7`, Build `17`: App Store Connect upload fix after the `2.6` pre-release train closed.

Every upload to App Store Connect must use a build number that has not already been uploaded for that version.

## Bug fixes and performance updates

For each update:

1. Fix the issue in Xcode.
2. Run the app on simulator and at least one real iPhone if possible.
3. Increase the build number.
4. Archive and upload from Xcode.
5. Test with internal TestFlight testers.
6. Send to external TestFlight or App Store review when stable.

## Future iOS compatibility

StudyBuddy is built with SwiftUI and a simple local-only architecture, which helps with future iOS compatibility.

Before each major iOS release:

1. Install the newest stable Xcode.
2. Run StudyBuddy on the latest iOS simulator.
3. Test the core flows:
   - Active exam switching
   - Study plan progress
   - Flashcards
   - Randomized flashcard deck order
   - Randomized 10-question quick practice
   - Quick Practice final score screen
   - Quick Practice questions stay inside the selected exam
   - First-time dashboard defaults and baseline recommendation
   - Achievement progress and completion celebration
   - Randomized 90-question exam simulation
   - Selected Exam difficulty reflected in simulations
   - PBQ matching
   - Drag-to-order scenarios
   - Scaled-score results
   - Results tab per-exam progress and attempt history
   - In-app PDF cheat sheets
   - Learn mode menu does not show Labs unless true in-app lab simulators are added
4. Fix warnings or layout issues.
5. Upload a compatibility update through TestFlight.

## Optional content updates later

The current app is local-only and collects no data.

If you later want exam content to update without a full app release, add a small content service that downloads signed JSON study content. That would require:

- A hosted content file or backend.
- Versioned content schemas.
- Signature or checksum validation.
- App Privacy review updates.
- Network error handling.
- A clear source and disclaimer for exam objective updates.

For now, keeping content bundled inside the app is simpler, safer for App Review, and easier to maintain.
