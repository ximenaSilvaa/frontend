//
//  UserRegistrationDTO.swift
//  TemplateReto451
//
//  Created by José Molina on 02/09/25.
//

import Foundation

struct UserRequest: Codable {
    let email, name, password: String
}

//To be defined by the endpoint
struct UserResponse: Decodable {
    let id: String, email: String, name: String

    // Ignore extra fields from backend (password_hash, salt)
    private enum CodingKeys: String, CodingKey {
        case id, email, name
    }
}
