//
//  AuthenticationController.swift
//  TemplateReto451
//
//  Created by José Molina on 02/09/25.
//

import Foundation

struct AuthenticationController{
    let httpClient: HTTPClient
    
    func registerUser(name: String, email: String, password: String) async throws -> Bool{
        let registrationResponse = try await httpClient.registerUser(name: name, email: email, password: password)
        return registrationResponse
        
    }
    func loginUser(email: String, password: String) async throws -> Bool{
        let loginResponse = try await httpClient.loginUser(email: email, password: password)
        
        TokenStorage.set(identifier: "accessToken", value: loginResponse.accessToken)
        TokenStorage.set(identifier: "refreshToken", value: loginResponse.refreshToken)
        
        return !loginResponse.accessToken.isEmpty

    }
}
