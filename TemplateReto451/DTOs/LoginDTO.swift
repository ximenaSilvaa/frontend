//
//  LoginDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 09/09/25.
//

import Foundation


struct UserLoginRequest: Codable {
    let email, password, type: String
}

struct UserLoginResponse: Decodable {
    let accessToken, refreshToken: String
}
