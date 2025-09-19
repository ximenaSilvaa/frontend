//
//  LoginDTO.swift
//  TemplateReto451
//
//  Created by José Molina on 09/09/25.
//

import Foundation


struct UserLoginRequest: Codable {
    let email, password: String
}

struct UserLoginResponse: Decodable {
    let accessToken, refreshToken: String
}
