//
//  UserPostInfoDTO.swift
//  TemplateReto451
//
//  Created by Claude Code
//

import Foundation

struct UserPostInfoDTO: Codable {
    let total: Int
    let protegidas: Int
    let pendiente: Int?
    let proceso: Int?
    let resuelto: Int?

    enum CodingKeys: String, CodingKey {
        case total
        case protegidas
        case pendiente
        case proceso
        case resuelto
    }

    // Computed properties for easier access
    var totalReports: Int {
        return total
    }

    var protectedPeople: Int {
        return protegidas
    }

    var inProcess: Int {
        return (proceso ?? 0) + (pendiente ?? 0)
    }
}
