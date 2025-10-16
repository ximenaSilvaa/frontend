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
        let registrationResponse = try await httpClient.registerUser(name: name, email: email, password: password)
        return registrationResponse
    }
    func loginUser(email: String, password: String) async throws -> Bool{
        let loginResponse = try await httpClient.loginUser(email: email, password: password)

        TokenStorage.shared.save(token: loginResponse.accessToken, identifier: "accessToken")
        TokenStorage.shared.save(token: loginResponse.refreshToken, identifier: "refreshToken")

        return !loginResponse.accessToken.isEmpty

    }

    func validateToken() async throws -> Bool {
        do {
            _ = try await httpClient.getUserProfile()
            return true
        } catch {
            TokenStorage.shared.remove(identifier: "accessToken")
            TokenStorage.shared.remove(identifier: "refreshToken")
            return false
        }
    }
}
