# PrepNexus Android

This folder contains the native Android version of **PrepNexus: IT Certs**. It uses Kotlin, Jetpack Compose, Material 3, adaptive window layouts, and a catalog exported from the iOS source of truth.

## Release Identity

- Application ID: `com.smokeys30.prepnexus`
- Android version: `1.0`
- Android version code: `1`
- Minimum Android version: Android 8.0 / API 26
- Target and compile SDK: Android 16 / API 36
- App label: `PrepNexus: IT Certs`

## Open And Run

1. Open Android Studio.
2. Select **Open**.
3. Choose the `Android` folder itself, not the repository root.
4. Allow the Gradle sync to finish and use Android Studio's bundled JDK.
5. Select an Android phone, resizable emulator, or foldable emulator running API 36 or newer.
6. Click **Run app**.

The app checks the hosted study service automatically. All catalog, practice, flashcard, plan, result, and lab features continue to work if the server is unavailable.

## Keep Exam Content In Sync

Edit exam material in `StudyBuddy/ExamCatalog.swift`, then run:

```bash
./Tools/export-shared-catalog.command
```

This regenerates `Android/app/src/main/assets/exam_catalog.json`. Commit the Swift source and regenerated JSON together.

## Command-Line Verification

From the `Android` folder:

```bash
JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" ./gradlew testDebugUnitTest lintDebug assembleDebug bundleRelease
```

Useful outputs:

- Debug APK: `app/build/outputs/apk/debug/app-debug.apk`
- Release app bundle: `app/build/outputs/bundle/release/app-release.aab`

The generated release bundle is unsigned until Android Studio's signed-bundle workflow is completed.

## Sign The Release Bundle

PrepNexus includes a local signing helper that keeps passwords out of source files and command arguments:

```bash
./sign-release.command
```

The script asks for the keystore password, displays the aliases in the keystore, asks which alias to use, runs tests and lint, creates the signed `.aab`, and verifies its signature. Passwords are held only as temporary environment variables for that run. Keystores and local signing properties are ignored by Git.

## Foldable Support

The app responds to the available window instead of checking for one device model. Compact windows use bottom navigation and a focused single-pane workflow. Wider windows use a navigation rail and two-pane study, practice, results, and lab layouts. WindowManager posture information supports book and tabletop positions without locking orientation or aspect ratio.

Test at minimum:

- Folded portrait phone
- Unfolded portrait inner display
- Unfolded landscape inner display
- Split-screen at approximately half width
- A rotate, fold, or resize operation while the app is open

## AI Security Gate

The production server enforces Apple App Attest for protected iOS AI routes. Android must use Google Play Integrity before those routes are enabled for Android clients. Do not turn off App Attest or put the OpenAI API key in the Android app. See `AndroidMigrationGuide.md` for the release gate.
