//
//  UserProfileDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 18/09/25.
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
        profileImage: Image("userprofile"),
        stats: ProfileStats(
            reports: 8,
            protectedPeople: 1,
            inProcess: 1
        )
    )
}
