//
//  MonthExtension.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 15/10/25.
//

import Foundation

extension String {
    func monthAbbreviation() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM"
        inputFormatter.locale = Locale(identifier: "es_ES")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM"
        outputFormatter.locale = Locale(identifier: "es_ES")
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
}
