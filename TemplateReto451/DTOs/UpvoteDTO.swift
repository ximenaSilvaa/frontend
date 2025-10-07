//
//  UpvoteDTO.swift
//  TemplateReto451
//
//  Created by Claude Code
//

import Foundation

struct UpvoteResponse: Codable {
    let likes: Int
    let reportId: String
    let userId: String
}
