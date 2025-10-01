//
//  ColorExtension.swift
//  TemplateReto451
//
//  Created by Claude on 26/09/25.
//

import SwiftUI

extension Color {
    // Brand Color System
    static let brandPrimary = Color(hex: "#1B365D")     // Dark Blue - Primary text, headers, main UI
    static let brandSecondary = Color(hex: "#2E5A87")   // Medium Blue - Secondary elements
    static let brandAccent = Color(hex: "#E74C3C")      // Red - Accent color, buttons, selected states

    // Legacy color replacement
    static let appBlue = brandPrimary // Replaces Color(red: 4/255, green: 9/255, blue: 69/255)

    // Convenience initializer for hex colors
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}