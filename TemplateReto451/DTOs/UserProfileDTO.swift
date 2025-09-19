//
//  UserProfileDTO.swift
//  TemplateReto451
//
//  Created by User on 18/09/25.
//

import SwiftUI

struct UserProfileDTO {
    let username: String
    let name: String
    let location: String
    let email: String
    let profileImage: Image
    let stats: ProfileStats

    struct ProfileStats {
        let reports: Int
        let protectedPeople: Int
        let inProcess: Int
    }
}

// Sample data for preview/testing
extension UserProfileDTO {
    static let sample = UserProfileDTO(
        username: "AnaTrailera300",
        name: "Ana Sánchez Ramos",
        location: "Ciudad de México, México",
        email: "ana@gmail.com",
        profileImage: Image(systemName: "person.circle.fill"),
        stats: ProfileStats(
            reports: 3,
            protectedPeople: 2,
            inProcess: 1
        )
    )
}