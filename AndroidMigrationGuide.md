# PrepNexus Android Migration And Google Play Guide

## What Is Already Migrated

PrepNexus now has two native clients in one repository:

- `StudyBuddy.xcodeproj`: SwiftUI app for iPhone and iPad
- `Android/`: Kotlin and Jetpack Compose app for Android phones, tablets, and foldables

The Android app includes all three exam catalogs, first-run defaults, Today, Plan, Learn, adaptive flashcards, cheat sheets, interactive command labs, Quick Practice, 90-question exam mode, PBQs, confidence inference, results, progress reset, randomized answer order, local persistence, and automatic server health monitoring.

The Android interface is adaptive rather than tied to a specific Fold model. It supports a folded phone window, the large inner screen, landscape, tabletop/book posture, and split-screen.

## First Android Studio Run

1. Install the current stable Android Studio.
2. Open Android Studio and choose **Open**.
3. Open the exact folder `PrepNexus/Android`.
4. If prompted for a Gradle JDK, choose **Embedded JDK**.
5. Open **Tools > SDK Manager** and confirm Android SDK Platform 36 and Android SDK Build-Tools 36 are installed.
6. Open **Tools > Device Manager**.
7. Create a **Resizable** or **Foldable** virtual device with an API 36 Google Play image.
8. Start the device, choose the `app` run configuration, and click the Run triangle.
9. Confirm the five-second PrepNexus welcome screen appears.
10. Select each exam and verify Today, Learn, Practice, Results, and one lab.

## Create A Signing Key

Keep this keystore backed up. Losing it can prevent future updates unless Play App Signing recovery is available.

An existing StudyBuddy upload keystore was found during this migration. Reuse that keystore if it is the one previously associated with your Google Play app. Do not create a replacement upload key for an existing Play listing unless Google approves an upload-key reset.

Recommended protected local path:

```text
~/Documents/PrepNexus Signing/prepnexus-upload-key.jks
```

To sign from Terminal, open the `Android` folder and run `./sign-release.command`. The script validates the password and alias before building, and it never writes either password into the repository.

1. In Android Studio choose **Build > Generate Signed App Bundle or APK**.
2. Select **Android App Bundle**, then **Next**.
3. Beside **Key store path**, choose **Create new**.
4. Save it somewhere private outside the repository, such as `~/Documents/PrepNexus Signing/prepnexus-upload.jks`.
5. Use `prepnexus-upload` as the key alias.
6. Create strong, unique keystore and key passwords and store them in your password manager.
7. Set validity to at least 25 years.
8. Enter your owner or organization certificate details, then click **OK**.
9. Select the `release` variant and finish the wizard.
10. Back up the `.jks` file and passwords in two secure locations. Never commit them to GitHub.

## Google Play Console Setup

1. Create the app in Play Console with the name **PrepNexus: IT Certs**.
2. Set the default language and choose **App** and **Education**.
3. Accept Play App Signing when prompted; upload using the key created above.
4. Complete App access, Ads, Content rating, Target audience, Data safety, Privacy policy, and Store listing.
5. Use `GooglePlayDataSafety.md` as the product-specific data-safety checklist and verify it against the final build.
6. Open **Testing > Internal testing** and create a release.
7. Upload `Android/app/build/outputs/bundle/release/app-release.aab` from the signed-bundle wizard.
8. Add release notes, save, review, and start the internal rollout.
9. Add tester email addresses or a Google Group and open the opt-in link on the test device.
10. Complete a closed test and device-catalog review before production submission.

## Protected AI Tutoring Release Gate

The current Android client checks server availability automatically, but protected personalized AI submissions are intentionally held behind this gate:

1. Create the Play Console app with application ID `com.smokeys30.prepnexus`.
2. Link the Play Console app to a Google Cloud project.
3. Enable the Play Integrity API.
4. Configure the Android client to request a standard integrity token for each protected request.
5. Configure the server to decode the token with Google and require the expected package name, certificate digest, app recognition, licensing, and device-integrity verdicts.
6. Bind the verified token to the request payload and reject replayed request hashes.
7. Keep Apple App Attest enforced for iOS requests.
8. Test internal Play builds before enabling Android protected routes in production.

Until this gate is complete, the Android app's offline learning features remain available and the OpenAI key remains safely on the server. Never place an OpenAI key, Google service-account key, keystore password, or signing key inside the app or repository.

## Versioning

- iOS remains version `3.2`, build `22`.
- The first Android release is version `1.0`, version code `1`.
- Increment Android `versionCode` for every Play upload, even when the public `versionName` is unchanged.
- iOS and Android build numbers do not need to match.
