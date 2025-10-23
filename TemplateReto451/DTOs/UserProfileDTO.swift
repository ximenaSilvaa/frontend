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

extension UserProfileDTO {
    static var sample: UserProfileDTO {
        UserProfileDTO(
            username: "usuario_ejemplo",
            name: "Usuario Ejemplo",
            location: "Ciudad, País",
            email: "ejemplo@correo.com",
            profileImage: Image(systemName: "person.circle.fill"),
            stats: ProfileStats(
                reports: 5,
                protectedPeople: 10,
                inProcess: 2
            )
        )
    }
}
