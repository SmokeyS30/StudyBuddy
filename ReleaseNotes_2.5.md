# StudyBuddy 2.5 Build 11

## What This Release Does

- Sets the live Render AI server as the default AI Tutor Server URL:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```

- Migrates older saved placeholder or localhost defaults to the live Render URL.
- Keeps custom user-entered AI server URLs unchanged.
- Keeps the AI server health check running automatically when StudyBuddy opens.
- Updates Settings copy so testers know the production AI tutor server is already configured.
- Bumps the AI server package to `1.1.0`.

## Verified

- `GET /health` on the Render server returned `HTTP 200`.
- Render health returned `openaiConfigured: true`.
- Render health returned `openaiKeyStatus: configured`.
- `POST /api/tutor/mistake` returned a live AI tutor response with `source: openai`.
- Xcode project file passed `plutil` validation.
- AI server JavaScript passed syntax validation.
- iPhoneOS build passed with code signing disabled for validation.

## Version Info For Xcode

- Marketing Version: `2.5`
- Build: `11`
- Bundle ID currently in the project: `com.smokeys30.studybuddy`
- iOS target: `iOS 17+`
- Main project file: `StudyBuddy.xcodeproj`

## TestFlight Action Steps

1. Open `StudyBuddy.xcodeproj` in Xcode.
2. Select the `StudyBuddy` target.
3. Confirm Signing & Capabilities uses your Apple Developer Team.
4. Confirm Version is `2.5` and Build is `11`.
5. Run the app in the simulator or on your iPhone.
6. Open Settings and confirm the AI Tutor Server URL is:

```text
https://studybuddy-ai-server-m5zi.onrender.com
```

7. Tap `Check AI Server Now`.
8. Confirm Status is `Online` and OpenAI key is `Configured`.
9. Select `Any iOS Device` as the destination.
10. Choose Product > Archive.
11. Upload through Organizer to App Store Connect.

## Notes

The app does not store the OpenAI API key. The key stays in Render environment variables on the server.
