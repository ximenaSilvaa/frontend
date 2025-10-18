//
//  NotificationDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 17/09/25.
//

import Foundation

struct NotificationDTO: Codable, Identifiable {
    let id: Int?
    let title: String
    let message: String
}
