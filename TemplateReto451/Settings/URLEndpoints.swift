//
//  URLEndpoints.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 09/09/25.
//

import Foundation

struct URLEndpoints {
    static let server: String = "http://18.222.210.25"
    static let login: String = String(server+"/auth/login")
    static let register: String = String(server+"/users/register")
    static let users: String = String(server+"/users")
    static let userReports: String = String(server+"/users/reports")
    static let reports: String = String(server+"/reports")
    static func idReport(id: Int) -> String { "\(server)/reports?id=\(id)" }
    static let categories: String = String(server+"/categories")
    static let upvotes: String = String(server+"/upvotes")
    static let upvotesTotal: String = String(server+"/upvotes/total")
    static let uploadProfileImage: String = String(server+"/images/profile-pictures")
    static let userPostInfo: String = String(server+"/users/post-info")
    static let userSettingsInfo: String = String(server+"/users/settings-info")
    static let dashboard: String = String(server+"/dashboard")
    static let passwordReset: String = String(server+"/users/password")
    static let termsAndConditions: String = String(server+"/configurations/1")
    static let notifications: String = String(server+"/notifications")
    static let createReport: String = String(server+"/users/report")
    static func uploadReportImage() -> String { "\(server)/images/report-pictures" }
    static func deleteImage() -> String { "\(server)/images" }

}
