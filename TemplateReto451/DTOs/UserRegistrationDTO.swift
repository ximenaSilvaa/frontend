//
//  UserRegistrationDTO.swift
//  TemplateReto451
//
//  Created by José Molina on 02/09/25.
//

import Foundation

struct UserRequest: Codable {
    let email: String
    let name: String
    let password: String
    let role_id: String
}

struct UserSettingsResponse: Codable {
    let id: Int
    let user_id: Int
    let is_reactions_enabled: Int
    let is_review_enabled: Int
    let is_reports_enabled: Int
}

struct UserResponse: Codable {
    let id: Int
    let name: String
    let email: String
    let username: String
    let salt: String
    let created_at: String
    let updated_at: String
    let image_path: String
    let role_id: Int
}

struct RegisterResponse: Codable {
    let user: UserResponse
    let settings: [UserSettingsResponse]
}
