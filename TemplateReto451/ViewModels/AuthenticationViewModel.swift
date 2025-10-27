//
//  AuthenticationController.swift
//  TemplateReto451
//
//  Created by José Molina on 02/09/25.
//

import Foundation

struct AuthenticationViewModel{
    let httpClient: HTTPClient

    func registerUser(name: String, email: String, password: String) async throws -> RegisterResponse {
        // ✅ SECURE: Protect password in memory
        let securePassword = MemorySecureString(password)
        defer {
            // ✅ CRITICAL: Clean password from memory immediately after use
            securePassword.clear()
        }

        let registrationResponse = try await httpClient.registerUser(
            name: name,
            email: email,
            password: securePassword.plaintext()
        )

        SecureLogger.logAuthenticationEvent("register", success: true)
        return registrationResponse
    }
    func loginUser(email: String, password: String) async throws -> Bool {
        // ✅ SECURE: Protect password in memory
        let securePassword = MemorySecureString(password)
        defer {
            // ✅ CRITICAL: Clean password from memory immediately after use
            securePassword.clear()
        }

        let loginResponse = try await httpClient.loginUser(email: email, password: securePassword.plaintext())

        // ✅ SECURE: Using Keychain via SecureTokenStorage
        SecureTokenStorage.shared.save(token: loginResponse.accessToken, identifier: "accessToken")
        SecureTokenStorage.shared.save(token: loginResponse.refreshToken, identifier: "refreshToken")

        SecureLogger.logAuthenticationEvent("login", success: true)
        return !loginResponse.accessToken.isEmpty
    }

    func validateToken() async throws -> Bool {
        do {
            _ = try await httpClient.getUserProfile()
            return true
        } catch {
            // ✅ SECURE: Clearing tokens from Keychain
            SecureTokenStorage.shared.remove(identifier: "accessToken")
            SecureTokenStorage.shared.remove(identifier: "refreshToken")
            Logger.log("Invalid token - cleared from secure storage", level: .warning)
            return false
        }
    }
}
