//
//  ReportDTO.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 03/10/25.
//

import Foundation

struct ReportDTO: Codable, Identifiable,  Hashable {
    let id: Int
    let title: String
    let image: String
    let description: String
    let user_name: String
    let created_by: Int
    let user_image: String
    let report_url: String
    let categories: [Int]

    
    var imageURL: String {
        return "http://18.222.210.25/\(image)"
    }

 
    var userImageURL: String {
        return "http://18.222.210.25/\(user_image)"
    }
}

// Sample data for preview/testing
extension ReportDTO {
    static let sample = ReportDTO(
        id: 1,
        title: "Reporte de sitio fraudulento",
        image: "report-pictures/1d92a0a7cbb8f6a32b6ff1a98ecf2af4f13293be20e38e7db23ccfca9a412b8a.jpg",
        description: "Este sitio web solicita datos bancarios sin medidas de seguridad y redirige a páginas falsas.",
        user_name: "Skibidi Toilet",
        created_by: 1,
        user_image: "user-pictures/default-avatar.jpg",
        report_url: "http://banco-seguro-falso.com",
        categories: [1, 5]
    )
}

struct CreateReportRequestDTO: Encodable {
    let title: String
    let description: String
    let status_id: Int
    let category: [Int]
    let report_url: String?
    let image: String?
    let is_anonymous: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case status_id
        case category
        case report_url
        case image
        case is_anonymous
    }
}

