//
//  ValidationExtension.swift
//  TemplateReto451
//
//  Created by José Molina on 26/08/25.
//

import Foundation
extension String {
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    var isValidPassword: Bool {
        return count >= 4
    }
}
