//
//  NotificationDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 17/09/25.
//

import Foundation

struct NotificationDTO: Decodable, Identifiable {
    var id = UUID()
    let created_by: Int
    let title: String
    let message: String
}
