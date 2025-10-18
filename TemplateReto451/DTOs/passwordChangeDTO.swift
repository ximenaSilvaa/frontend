//
//  passwordChangeDTO.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 16/10/25.
//

import Foundation
// MARK: - PasswordChangeDTO
struct PasswordChangeDTO: Codable {
    let oldPassword, newPassword: String
}

struct PasswordChangeResponse: Codable {
    let message: String
}
