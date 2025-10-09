//
//  UpvoteDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena
//

import Foundation

struct UpvoteResponse: Codable {
    let likes: Int
    let reportId: String
    let userId: String
}
