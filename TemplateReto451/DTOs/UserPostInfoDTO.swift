//
//  UserPostInfoDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 18/09/25.
//

import Foundation

struct UserPostInfoDTO: Codable {
    let total: Int
    let protegidas: Int
    let pendiente: Int?
    let aprobada: Int?
    let rechazada: Int?

    enum CodingKeys: String, CodingKey {
        case total
        case protegidas
        case pendiente
        case aprobada
        case rechazada
    }

    // Computed properties for easier access
    var totalReports: Int {
        return total
    }

    var protectedPeople: Int {
        return protegidas
    }

    var inProcess: Int {
        return pendiente ?? 0
    }

    var approved: Int {
        return aprobada ?? 0
    }

    var rejected: Int {
        return rechazada ?? 0
    }
}
