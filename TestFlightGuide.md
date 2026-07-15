# StudyBuddy Xcode to TestFlight Guide

This guide walks you from the local Xcode project to a TestFlight build that testers can install.

## 1. What you need first

1. A Mac with the full Xcode app installed from the Mac App Store.
2. An Apple Developer Program membership.
3. Access to App Store Connect at `https://appstoreconnect.apple.com`.
4. A privacy policy URL and support URL. Apple usually requires these even when the app collects no data.
5. The StudyBuddy project folder:
   - `StudyBuddy.xcodeproj`
   - `StudyBuddy/`

## 2. Open the project

1. Open Xcode.
2. Choose File > Open.
3. Select `StudyBuddy.xcodeproj`.
4. Wait for Xcode to index the project.

## 3. Set signing and bundle ID

1. In the left sidebar, click the blue `StudyBuddy` project icon.
2. Under Targets, click `StudyBuddy`.
3. Open the Signing & Capabilities tab.
4. Check `Automatically manage signing`.
5. Select your Apple Developer Team.
6. Change Bundle Identifier from:

   `com.example.studybuddy`

   to something you own, such as:

   `com.yourname.studybuddy`

7. Leave Display Name as `StudyBuddy`.

Important: the bundle identifier must be unique across all App Store apps.

## 4. Set version and build

1. Still on the `StudyBuddy` target, open the General tab.
2. Set Version to `1.0`.
3. Set Build to `1`.
4. Each time you upload another TestFlight build, increase Build:
   - First upload: `1`
   - Second upload: `2`
   - Third upload: `3`

Apple will not accept two uploads with the same version and build number.

## 5. Run the app locally

1. At the top of Xcode, choose an iPhone simulator, such as iPhone 16.
2. Press the Run button.
3. Confirm the app opens and these tabs work:
   - Today
   - Plan
   - Learn
   - Practice
   - Settings
4. In Settings, switch between A+ Core 1, A+ Core 2, and Security+.
5. Try marking a study task complete in one exam.
6. Switch to another exam and confirm progress is separate.
7. Start an exam simulation and verify PBQ matching, drag-to-order items, timer, submission, and score review.
8. Close and reopen the app to confirm progress stays saved.

## 6. Run on your iPhone

1. Connect your iPhone with a cable or enable wireless debugging in Xcode.
2. Unlock the iPhone.
3. In Xcode, choose your iPhone as the run destination.
4. Press Run.
5. If iOS asks you to trust the developer profile, go to:

   Settings > General > VPN & Device Management

6. Trust your developer profile and run again.

## 7. Create the App Store Connect app record

1. Go to App Store Connect.
2. Open My Apps.
3. Click the plus button.
4. Choose New App.
5. Fill in:
   - Platform: iOS
   - Name: StudyBuddy
   - Primary Language: English
   - Bundle ID: choose the same bundle ID you set in Xcode
   - SKU: something unique, such as `studybuddy-ios-001`
   - User Access: Full Access, unless you need to restrict it
6. Click Create.

If your bundle ID does not appear, return to Xcode and confirm signing is set correctly. You can also create the identifier manually in the Apple Developer portal.

## 8. Prepare the archive

1. In Xcode, choose the run destination `Any iOS Device`.
2. In the menu bar, choose Product > Clean Build Folder.
3. Choose Product > Archive.
4. Wait for the archive to complete.
5. Xcode Organizer should open automatically.

If Archive is disabled, make sure the selected destination is `Any iOS Device`, not a simulator.

## 9. Validate and upload

1. In Xcode Organizer, select the newest StudyBuddy archive.
2. Click Distribute App.
3. Choose App Store Connect.
4. Choose Upload.
5. Keep Automatically manage signing selected.
6. Let Xcode analyze the archive.
7. If Xcode offers to strip Swift symbols or upload debug symbols, keep the default recommended options.
8. Click Upload.

After upload, Apple may take several minutes to process the build.

## 10. Finish TestFlight setup

1. Go back to App Store Connect.
2. Open My Apps > StudyBuddy > TestFlight.
3. Wait for the build to appear under Builds.
4. If prompted, answer export compliance questions.
   - If the app only uses Apple's standard encryption through iOS and has no custom encryption, answer accordingly.
5. Add Beta App Information:
   - What to test
   - Contact email
   - Beta app description
6. Add internal testers from your App Store Connect team.
7. Click Start Testing or make the build available to internal testers.

Internal testers can usually install quickly after processing finishes.

## 11. Add external testers

1. In TestFlight, create an external tester group.
2. Add email addresses or create a public invite link.
3. Add the build to the group.
4. Submit the build for Beta App Review.
5. Wait for Apple to approve external testing.

External TestFlight review is lighter than full App Store Review, but Apple still checks basic compliance.

## 12. Before App Store submission

Prepare these items in App Store Connect:

1. App screenshots for required device sizes.
2. Description, subtitle, and keywords.
3. Support URL.
4. Privacy policy URL.
5. App Privacy answers.
6. Age rating.
7. Copyright holder.
8. Review notes.

Recommended privacy answer for the current local-only app:

`Data Not Collected`

Only use that answer if you do not add analytics, ads, accounts, cloud sync, email collection, or network tracking.

## 13. Important education and trademark notes

1. Keep the app name as `StudyBuddy`.
2. Do not name it `CompTIA StudyBuddy` or anything that implies official endorsement.
3. Keep the disclaimer inside the app.
4. Do not add real exam questions, exam dumps, or copied paid question-bank content.
5. Use original practice prompts and explanations.
6. Compare StudyBuddy's topic list against the current official CompTIA 220-1201, 220-1202, and Security+ objectives before release.
7. Do not claim the practice exam scoring is official or identical to CompTIA's private scoring algorithm.

## 14. Common upload problems

### Bundle ID already exists

Choose a different bundle ID in Xcode and App Store Connect.

### No signing certificate found

Make sure your Apple Developer account is selected in Xcode under Settings > Accounts, then return to Signing & Capabilities.

### Archive is grayed out

Change the destination to `Any iOS Device`.

### Build number already uploaded

Increase the Build number in Xcode, archive again, and upload again.

### Missing app icon

Open `Assets.xcassets`, select `AppIcon`, and confirm the 1024x1024 icon is present.

### App Store asks for privacy details

Complete App Privacy in App Store Connect. If you keep the current app local-only, choose no data collected.

## 15. Suggested TestFlight test checklist

Ask testers to check:

1. The app opens without crashing.
2. The Today tab shows the right exam name and countdown.
3. Settings can switch between A+ Core 1, A+ Core 2, and Security+.
4. Study tasks can be marked complete.
5. Progress stays separate for each exam.
6. Progress stays saved after closing and reopening the app.
7. Flashcards can be marked known.
8. Flashcard order changes after tapping Shuffle deck.
9. Short practice starts a randomized 10-question test.
10. Restarting short practice changes question and answer order.
11. Full exam simulation starts a randomized 90-question session.
12. Restarting full simulation changes the question and PBQ order.
13. PBQ matching items work.
14. Drag-to-order scenarios work.
15. Estimated scaled score and pass threshold display after submission.
16. Settings can reset progress for the current exam.
17. Text is readable on smaller iPhones.
18. The disclaimer is visible in Learn and Settings.

## 16. When you are ready for full App Store review

1. Fix feedback from TestFlight testers.
2. Increase the build number.
3. Archive and upload the final build.
4. In App Store Connect, choose the build on the App Store tab.
5. Complete all metadata, screenshots, privacy, and age rating.
6. Submit for review.
