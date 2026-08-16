# PrepNexus App Store Connect Privacy Answers

These answers describe PrepNexus iOS 3.2 build 22 with the hosted AI Tutor and App Attest enforcement enabled. Recheck them against the deployed server before publishing. Android disclosures are documented separately in `GooglePlayDataSafety.md`.

## Data Collection

Choose `Yes, we collect data from this app`.

## Data Types

### Identifiers > User ID

- Collected: Yes
- Purpose: App Functionality and Product Personalization
- Linked to the user: Yes
- Used for tracking: No
- Reason: A random PrepNexus student profile ID connects adaptive learning history across requests.

### Identifiers > Device ID

- Collected: Yes
- Purpose: App Functionality
- Linked to the user: Yes
- Used for tracking: No
- Reason: The server stores an app-scoped App Attest key identifier and integrity state to verify the app and prevent replay.

### Usage Data > Product Interaction

- Collected: Yes
- Purpose: App Functionality and Product Personalization
- Linked to the user: Yes
- Used for tracking: No
- Reason: Exam selection, attempts, scores, weak objectives, confidence estimates, flags, PBQ performance, and study activity personalize coaching and study paths.

### User Content > Other User Content

- Collected: Yes
- Purpose: App Functionality and Product Personalization
- Linked to the user: Yes
- Used for tracking: No
- Reason: AI Tutor messages, optional study context, and missed-question prompts are processed to generate tutoring responses.

## Do Not Select Unless The App Changes

- Contact Info
- Location
- Financial Info
- Contacts
- Photos or Videos
- Audio Data
- Browsing History
- Advertising Data
- Diagnostics collected by PrepNexus
- Data Used to Track You

## Privacy URLs

- Privacy Policy: `https://smokeys30.github.io/StudyBuddy/PrivacyPolicy.html`
- Support: `https://smokeys30.github.io/StudyBuddy/Support.html`

## Important

Apple requires the answers to include data collected by the app and integrated third-party partners. Update and republish the answers whenever the released build or server behavior changes. This checklist is a conservative product-specific recommendation, not legal advice.
