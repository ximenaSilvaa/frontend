//
//  SettingsDTO.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 09/10/25.
//

import Foundation


// MARK: - SettingsDTO GET

struct SettingsResponseDTO: Decodable {
    let isReactionsEnabled: Int
    let isReviewEnabled: Int
    let isReportsEnabled: Int
    let isAnonymousReportsEnabled: Int

    enum CodingKeys: String, CodingKey {
        case isReactionsEnabled = "is_reactions_enabled"
        case isReviewEnabled = "is_review_enabled"
        case isReportsEnabled = "is_reports_enabled"
        case isAnonymousReportsEnabled = "is_anonymous_reports_enabled"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        func decodeInt(_ key: CodingKeys) -> Int {
            if let value = try? container.decodeIfPresent(Int.self, forKey: key) {
                return value
            }
            if let boolValue = try? container.decodeIfPresent(Bool.self, forKey: key) {
                return boolValue == true ? 1 : 0
            }
            if let stringValue = try? container.decodeIfPresent(String.self, forKey: key),
               let intValue = Int(stringValue) {
                return intValue
            }
            return 0
        }

        isReactionsEnabled = decodeInt(.isReactionsEnabled)
        isReviewEnabled = decodeInt(.isReviewEnabled)
        isReportsEnabled = decodeInt(.isReportsEnabled)
        isAnonymousReportsEnabled = decodeInt(.isAnonymousReportsEnabled)
    }

    var reactionsEnabledBool: Bool { isReactionsEnabled == 1 }
    var reviewEnabledBool: Bool { isReviewEnabled == 1 }
    var reportsEnabledBool: Bool { isReportsEnabled == 1 }
    var anonymousReportsEnabledBool: Bool { isAnonymousReportsEnabled == 1 }
}



// MARK: - SettingsDTO put
struct SettingsRequestDTO: Encodable {
    let isReactionsEnabled: Int
    let isReviewEnabled: Int
    let isReportsEnabled: Int
    let isAnonymousPreferred: Int

    enum CodingKeys: String, CodingKey {
        case isReactionsEnabled = "is_reactions_enabled"
        case isReviewEnabled = "is_review_enabled"
        case isReportsEnabled = "is_reports_enabled"
        case isAnonymousPreferred = "is_anonymous_preferred"
    }

    init(
        isReactionsEnabled: Bool,
        isReviewEnabled: Bool,
        isReportsEnabled: Bool,
        isAnonymousPreferred: Bool = false
    ) {
        self.isReactionsEnabled = isReactionsEnabled ? 1 : 0
        self.isReviewEnabled = isReviewEnabled ? 1 : 0
        self.isReportsEnabled = isReportsEnabled ? 1 : 0
        self.isAnonymousPreferred = isAnonymousPreferred ? 1 : 0
    }
}

