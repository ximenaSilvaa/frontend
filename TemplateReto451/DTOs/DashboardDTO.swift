//
//  DashboardDTO.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 13/10/25.
//

import Foundation

// MARK: - DashboardResponse
struct DashboardResponse: Codable {
    let stats: Stats
    let topCategoriesReports: [CategoryReport]
    let reportsPerMonth: [MonthlyReport]
    let topUsers: [TopUser]
    let recentAlerts: [RecentAlert]
    let topReportsMonth: [TopReport]
}

// MARK: - Stats
struct Stats: Codable {
    let totalReports: Int
    let approvedReports: Int
    let rejectedReports: Int
    let pendingReports: Int
    let protectedPeople: Int
    let totalUsers: Int

    enum CodingKeys: String, CodingKey {
        case totalReports = "total_reports"
        case approvedReports = "approved_reports"
        case rejectedReports = "rejected_reports"
        case pendingReports = "pending_reports"
        case protectedPeople = "protected_people"
        case totalUsers = "total_users"
    }
}

// MARK: - CategoryReport
struct CategoryReport: Codable {
    let name: String
    let totalReports: Int

    enum CodingKeys: String, CodingKey {
        case name
        case totalReports = "total_reportes"
    }
}

// MARK: - MonthlyReport
struct MonthlyReport: Codable {
    let month: String
    let totalReports: Int

    enum CodingKeys: String, CodingKey {
        case month
        case totalReports = "total_reports"
    }
}

// MARK: - TopUser
struct TopUser: Codable {
    let name: String
    let totalReports: Int

    enum CodingKeys: String, CodingKey {
        case name
        case totalReports = "total_reports"
    }
}

// MARK: - RecentAlert
struct RecentAlert: Codable {
    let id: Int
    let title: String
}

// MARK: - TopReport
struct TopReport: Codable {
    let id: Int
    let title: String
    let upvotes: Int
}
