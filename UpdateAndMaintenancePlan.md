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
- Version `1.2`, Build `4`: bug fix after tester feedback.
- Version `1.3`, Build `5`: larger content or feature update.

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
   - Randomized 90-question exam simulation
   - PBQ matching
   - Drag-to-order scenarios
   - Scaled-score results
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
