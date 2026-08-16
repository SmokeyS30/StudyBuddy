# PrepNexus: IT Certs Privacy Policy

Effective Date: August 16, 2026

PrepNexus: IT Certs, formerly StudyBuddy, helps users prepare for exams with study plans, flashcards, practice questions, progress tracking, exam simulations, and AI-assisted tutoring on supported Apple and Android devices.

## Summary

PrepNexus does not require an account and does not ask for your name, email address, phone number, location, payment information, contacts, photos, or advertising identifier.

The iOS version collects limited study-related data when the AI Tutor Server is used so the app can personalize coaching, remember weak objectives, and help users learn from mistakes. The initial Android version checks server health but does not submit protected study attempts or tutor messages until Google Play Integrity verification is enabled.

PrepNexus does not sell user data, does not use advertising networks, does not use third-party analytics SDKs, and does not track users across apps or websites.

## Data PrepNexus May Collect

When AI tutoring is enabled on a supported platform, PrepNexus may collect the following study-related data:

- A random PrepNexus student profile ID
- Selected exam and exam code
- Custom exam name or exam code if the user enters one
- Practice test and exam simulation results
- Raw score, estimated scaled score, pass estimate, and percentage score
- Objective or domain performance
- Missed-question context
- Selected answer summaries and correct-answer summaries
- Confidence estimates, guessed-answer counts, flagged-question counts, PBQ score, and time spent
- AI Tutor chat messages and follow-up questions
- AI Tutor assignments, study recommendations, and weak-area history
- On Apple devices, an App Attest cryptographic key identifier, integrity attestation, assertion counters, and related security status

This data is used to provide app functionality and personalize the learning experience.

## Data Stored on Your Device

PrepNexus stores study progress locally on your device. This may include:

- Selected exam
- Study task progress
- Flashcard progress
- Practice question progress
- Exam date
- Daily study target
- App-open streak history
- Optional personal study notes entered by the user
- On iOS, a random student profile ID used by the AI Tutor Server
- On iOS, an App Attest key identifier stored securely in the device Keychain

## Data Sent to the AI Tutor Server

On iOS, PrepNexus uses a hosted AI Tutor Server to provide adaptive coaching. When users complete practice exams, complete exam simulations, open AI Tutor review, or send AI Tutor chat messages, study-related data may be sent to the server.

The AI Tutor Server stores a learning profile connected to the random PrepNexus student profile ID. This profile helps PrepNexus remember weak domains, missed objectives, confidence patterns, and recent attempts.

PrepNexus uses Apple's App Attest service to help confirm that AI Tutor requests come from a genuine copy of PrepNexus running on an Apple device. The app may send a cryptographic key identifier, Apple attestation object, integrity receipt, signed assertions, and an increasing assertion counter to the AI Tutor Server. These security values are used for app integrity, fraud prevention, replay protection, and server security. They are not used for advertising or cross-app tracking.

PrepNexus does not collect a device serial number, advertising identifier, precise hardware identifier, or location through App Attest. App Attest keys are scoped to PrepNexus and the app installation.

The initial Android version makes an HTTPS request to the server health endpoint when the app opens. This request does not contain study answers, scores, tutor messages, an advertising identifier, or a PrepNexus student profile. Like ordinary internet requests, the hosting provider may process network metadata such as an IP address in operational logs. Before protected Android tutoring is enabled, this policy will be updated to describe Google Play Integrity tokens and Android study-data processing.

## Third-Party Services

PrepNexus does not use third-party advertising networks, analytics SDKs, or data brokers.

The PrepNexus AI Tutor Server may use OpenAI to generate coaching responses. OpenAI API keys are stored on the server, not in the app. Study data sent to the AI Tutor Server may be included in requests to OpenAI only for generating tutoring, explanations, study recommendations, and related app functionality.

PrepNexus uses Apple's DeviceCheck App Attest service for iOS app-integrity verification. Apple processes attestation requests under Apple's applicable privacy terms. App Attest security values are not sent to OpenAI for tutoring.

## Tracking

PrepNexus does not track users across apps or websites. PrepNexus does not share data with data brokers or advertising networks.

## Retention And Deletion

Study progress stored on the device remains until the user resets progress, deletes the app, or the operating system removes the app's data. Reset All Progress clears local PrepNexus progress but does not automatically erase a separate AI Tutor learning profile stored on the server.

Server learning profiles and App Attest security records are retained while needed to provide adaptive learning, protect the service, maintain request counters, and investigate abuse. To request deletion of a server learning profile, contact edwardbloomfield@mac.com and include the Student profile code shown in PrepNexus iOS Settings.

## Security

PrepNexus uses HTTPS for the hosted AI Tutor Server, keeps the OpenAI API key on the server, uses Apple App Attest for iOS app-integrity checks, and limits stored learning data to what is needed for the features described in this policy. Protected Android tutoring will require Google Play Integrity before it is enabled. No method of storage or transmission can be guaranteed to be completely secure.

## Data Not Collected

PrepNexus does not collect:

- Name
- Email address
- Phone number
- Physical address
- Precise or coarse location
- Payment information
- Contacts
- Health or fitness information
- Photos, videos, or audio recordings
- Browsing history
- Search history outside the app
- Advertising data

## Children's Privacy

PrepNexus does not knowingly collect personal information from children.

## Exam Content Disclaimer

PrepNexus is independent study software. It is not affiliated with, endorsed by, or sponsored by CompTIA. CompTIA, A+, and Security+ are trademarks of CompTIA, Inc. Practice questions are original study prompts, not real exam questions.

## Changes to This Policy

This privacy policy may be updated if PrepNexus adds new features or changes how data is handled. Any updates will be reflected by changing the effective date above.

## Contact

For privacy questions or data requests, contact:

edwardbloomfield@mac.com
