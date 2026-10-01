# PrepNexus Windows browser client

This is a browser-based study client for Windows browsers such as Edge. It is not a native Windows executable or a SwiftUI port.

The client reads the repository's existing Android exam catalog at `Android/app/src/main/assets/exam_catalog.json`. Available tracks follow that public catalog; this change adds no catalog entries or practice questions.

## Run locally

Use Node.js 20 or later. From the repository root:

```powershell
cd Windows
npm start
```

Open `http://127.0.0.1:4173` in Edge. The static host binds to loopback and serves only its known files plus the existing Android catalog. Run `npm test` for the client-core tests. `PREPNEXUS_WINDOWS_PORT` changes the local client port.

## Current server compatibility

The client can use the study-attempt, study-path, mistake-tutor, and tutor-chat actions. The current public server does not provide an authenticated browser-session route or enforce a trusted account identity for browser requests. The client accepts a missing session route only on loopback; a UUID generated in the browser is a local profile identifier, not authentication. With the current upstream server, use the client and server on the same computer over loopback only. Do not expose the raw server API or use this client over a LAN or the internet until the server has reviewed account authentication and authorization for every student route.

A Windows browser cannot provide Apple App Attest. A server that enforces App Attest will reject protected browser actions. This client does not change server authentication, network binding, firewall, or App Attest settings.

Cross-host use requires a separately implemented and reviewed server-side sign-in/session boundary, stable account-to-profile mapping, authorization on each student action, and a policy compatible with Windows browsers. That server work is outside this PR.

## Platform validation

This folder is a Windows browser client. It does not prove a native Windows application, macOS/Xcode build, or iOS behavior. Mac/Xcode/iOS acceptance remains with the project maintainer on macOS.
