//
//  CategoryDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 07/10/25.
//

import Foundation

struct CategoryDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
}
