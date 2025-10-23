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
    let created_at: String
    let updated_at: String
    let status_id: Int


    var imageURL: String {
        return "http://18.222.210.25/\(image)"
    }


    var userImageURL: String {
        return "http://18.222.210.25/\(user_image)"
    }

    var createdDate: Date? {
        // Intentar ISO8601DateFormatter primero
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso8601Formatter.date(from: created_at) {
            return date
        }

        // Intentar sin milisegundos
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        if let date = iso8601Formatter.date(from: created_at) {
            return date
        }

        // Intentar con DateFormatter como fallback
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: created_at) {
            return date
        }

        // Intentar sin milisegundos
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: created_at)
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
        categories: [1, 5],
        created_at: "2025-09-27T23:50:39.000Z",
        updated_at: "2025-09-27T23:50:39.000Z",
        status_id: 2
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

