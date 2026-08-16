# PrepNexus Google Play Data Safety Checklist

This checklist describes Android version 1.0 before protected personalized AI tutoring is enabled. Recheck every answer against the final production build and deployed server.

## Current Android Build

- No account is required.
- Study progress, answers, results, plans, and preferences are stored locally on the device.
- No advertising SDK or third-party analytics SDK is included.
- The app does not request location, contacts, camera, microphone, photo, storage, or advertising-ID permissions.
- The app automatically makes an HTTPS health request to the hosted PrepNexus study server. Normal network metadata such as IP address may be processed by the hosting provider's infrastructure.
- Protected study attempts and AI Tutor messages are not submitted by Android until Play Integrity verification is implemented.

## Play Console Answers For This Build

- **Does your app collect or share any of the required user data types?** Verify Render's transient server and access-log handling before answering. If the health endpoint logs or retains IP addresses, disclose the applicable approximate location or device/other identifier category required by Play's current form.
- **Is all user data encrypted in transit?** Yes for the hosted service because the app uses HTTPS.
- **Can users request deletion?** Local data can be deleted with Reset All Progress or by uninstalling. Server deletion requests go to `edwardbloomfield@mac.com`.
- **Ads:** No.
- **Tracking or advertising:** No.

## When Android AI Tutoring Is Enabled

Update the Data safety form and privacy policy before release. The protected AI flow is expected to process:

- Random student profile ID
- Exam selection and study activity
- Attempts, scores, objective performance, missed-answer context, confidence inference, flags, PBQ performance, and time spent
- Tutor messages and optional study context
- Play Integrity tokens and server-side integrity verdicts for security and fraud prevention

Declare these for app functionality and personalization, not advertising or cross-app tracking. Confirm collection, sharing, retention, and deletion behavior with the final server implementation before submitting.

This is a product-specific engineering checklist, not legal advice. Google changes the Play Console form over time, so read each live definition before selecting an answer.
