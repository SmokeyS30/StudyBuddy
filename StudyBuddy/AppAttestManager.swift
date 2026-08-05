import CryptoKit
import DeviceCheck
import Foundation
import Security

actor StudyBuddyAppAttest {
    static let shared = StudyBuddyAppAttest()

    static let assertionHeader = "X-StudyBuddy-App-Attest-Assertion"
    static let challengeHeader = "X-StudyBuddy-App-Attest-Challenge"
    static let keyIDHeader = "X-StudyBuddy-App-Attest-Key-ID"

    private let service = DCAppAttestService.shared
    private var registrationTask: Task<String, Error>?

    func authorizationHeaders(
        baseURL: URL,
        method: String,
        path: String,
        body: Data
    ) async throws -> [String: String] {
        guard service.isSupported else { return [:] }

        let keyID = try await attestedKeyID(baseURL: baseURL)
        let challenge = try await Self.fetchChallenge(baseURL: baseURL, purpose: "assertion")
        let payload = Self.protectedPayload(
            method: method,
            path: Self.normalizedPath(path),
            challenge: challenge.challenge,
            body: body
        )
        let clientDataHash = Data(SHA256.hash(data: payload))

        do {
            let assertion = try await service.generateAssertion(keyID, clientDataHash: clientDataHash)
            return Self.headers(keyID: keyID, challenge: challenge.challenge, assertion: assertion)
        } catch {
            resetKey()
            let replacementKeyID = try await attestedKeyID(baseURL: baseURL)
            let replacementChallenge = try await Self.fetchChallenge(baseURL: baseURL, purpose: "assertion")
            let replacementPayload = Self.protectedPayload(
                method: method,
                path: Self.normalizedPath(path),
                challenge: replacementChallenge.challenge,
                body: body
            )
            let replacementHash = Data(SHA256.hash(data: replacementPayload))
            let assertion = try await service.generateAssertion(replacementKeyID, clientDataHash: replacementHash)
            return Self.headers(
                keyID: replacementKeyID,
                challenge: replacementChallenge.challenge,
                assertion: assertion
            )
        }
    }

    func resetKey() {
        registrationTask?.cancel()
        registrationTask = nil
        AppAttestKeyStore.clear()
    }

    private func attestedKeyID(baseURL: URL) async throws -> String {
        if let storedKeyID = AppAttestKeyStore.load() {
            return storedKeyID
        }

        if let registrationTask {
            return try await registrationTask.value
        }

        let task = Task<String, Error> {
            try await Self.createAndRegisterKey(baseURL: baseURL)
        }
        registrationTask = task

        do {
            let keyID = try await task.value
            try AppAttestKeyStore.save(keyID)
            registrationTask = nil
            return keyID
        } catch {
            registrationTask = nil
            throw error
        }
    }

    private static func createAndRegisterKey(baseURL: URL) async throws -> String {
        let service = DCAppAttestService.shared
        let keyID = try await service.generateKey()
        let challenge = try await fetchChallenge(baseURL: baseURL, purpose: "attestation")
        let challengeData = Data(challenge.challenge.utf8)
        let clientDataHash = Data(SHA256.hash(data: challengeData))
        let attestationObject = try await service.attestKey(keyID, clientDataHash: clientDataHash)

        let payload = AppAttestRegistrationRequest(
            keyId: keyID,
            challenge: challenge.challenge,
            attestationObject: attestationObject.base64EncodedString()
        )
        var url = baseURL
        url.append(path: "api/app-attest/register")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 45
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response, data: data)
        return keyID
    }

    private static func fetchChallenge(baseURL: URL, purpose: String) async throws -> AppAttestChallengeResponse {
        var url = baseURL
        url.append(path: "api/app-attest/challenge")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15
        request.httpBody = try JSONEncoder().encode(AppAttestChallengeRequest(purpose: purpose))

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response, data: data)
        return try JSONDecoder().decode(AppAttestChallengeResponse.self, from: data)
    }

    private static func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StudyBuddyAppAttestError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            let serverError = try? JSONDecoder().decode(AppAttestServerError.self, from: data)
            throw StudyBuddyAppAttestError.server(
                serverError?.code ?? "app_attest_request_failed",
                serverError?.error ?? "The App Attest server request failed."
            )
        }
    }

    private static func normalizedPath(_ path: String) -> String {
        "/" + path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }

    private static func protectedPayload(
        method: String,
        path: String,
        challenge: String,
        body: Data
    ) -> Data {
        var payload = Data("\(method.uppercased())\n\(path)\n\(challenge)\n".utf8)
        payload.append(body)
        return payload
    }

    private static func headers(keyID: String, challenge: String, assertion: Data) -> [String: String] {
        [
            keyIDHeader: keyID,
            challengeHeader: challenge,
            assertionHeader: assertion.base64EncodedString()
        ]
    }
}

private struct AppAttestChallengeRequest: Encodable {
    let purpose: String
}

private struct AppAttestChallengeResponse: Decodable {
    let challenge: String
    let expiresInSeconds: Int
}

private struct AppAttestRegistrationRequest: Encodable {
    let keyId: String
    let challenge: String
    let attestationObject: String
}

struct AppAttestServerError: Decodable {
    let error: String
    let code: String?
}

enum StudyBuddyAppAttestError: LocalizedError {
    case invalidResponse
    case keychain(OSStatus)
    case server(String, String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The App Attest server returned an unreadable response."
        case .keychain(let status):
            return "StudyBuddy could not securely save its App Attest key (\(status))."
        case .server(_, let message):
            return message
        }
    }
}

private enum AppAttestKeyStore {
    private static let account = "studybuddy-app-attest-key-id-v1"
    private static let service = "com.smokeys30.studybuddy.app-attest"

    static func load() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    static func save(_ keyID: String) throws {
        let data = Data(keyID.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            var item = query
            item.merge(attributes) { _, new in new }
            let addStatus = SecItemAdd(item as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw StudyBuddyAppAttestError.keychain(addStatus)
            }
        } else if status != errSecSuccess {
            throw StudyBuddyAppAttestError.keychain(status)
        }
    }

    static func clear() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
