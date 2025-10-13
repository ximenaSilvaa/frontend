//
//  URLEndpoints.swift
//  TemplateReto451
//
//  Created by José Molina on 09/09/25.
//

import Foundation

struct URLEndpoints {
    static let server: String = "http://18.221.59.69"
    static let login: String = String(server+"/auth/login")
    static let register: String = String(server+"/users/register")
    static let users: String = String(server+"/users")
    static let userReports: String = String(server+"/users/reports")
    static let reports: String = String(server+"/reports")
    static let categories: String = String(server+"/categories")
    static let upvotes: String = String(server+"/upvotes")
    static let upvotesTotal: String = String(server+"/upvotes/total")
    static let uploadProfileImage: String = String(server+"/images/profile-pictures")
    static let userPostInfo: String = String(server+"/users/post-info")
    static let userSettingsInfo: String = String(server+"/users/settings-info")
}
