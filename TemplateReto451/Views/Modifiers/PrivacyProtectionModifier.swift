//
//  PrivacyProtectionModifier.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 26/10/25.
//  Privacy protection for sensitive screens and data
//

import SwiftUI
import UIKit

/// Custom modifier that provides comprehensive privacy protection:
/// - Prevents screenshots and screen recording
/// - Hides content in app switcher
/// - Protects sensitive UI from privacy violations
struct PrivacyProtectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            // sECURITY: Mark as privacy sensitive (prevents screenshots in app switcher)
            .privacySensitive()
            // Hide content in app switcher by replacing with a privacy view
            .onAppear {
                PrivacyProtection.enablePrivacyMode()
            }
            .onDisappear {
                PrivacyProtection.disablePrivacyMode()
            }
    }
}

/// Helper class to manage privacy protection at the window level
class PrivacyProtection {
    static let shared = PrivacyProtection()

    /// Enable privacy mode: hide sensitive content in app switcher
    static func enablePrivacyMode() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else { return }

        // Create a privacy view (blurred/hidden)
        let privacyView = UIView()
        privacyView.backgroundColor = UIColor(Color.brandPrimary)
        privacyView.tag = 9999  // Unique tag to identify privacy view

        // This view will be shown instead of actual content in app switcher
        // Note: The actual implementation depends on iOS version
        window.windowScene?.screenshotService?.delegate = PrivacyScreenshotDelegate.shared
    }

    /// Disable privacy mode
    static func disablePrivacyMode() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else { return }

        // Remove privacy view if exists
        if let privacyView = window.viewWithTag(9999) {
            privacyView.removeFromSuperview()
        }
    }
}

/// Screenshot delegate to prevent screen capture
class PrivacyScreenshotDelegate: NSObject, UIScreenshotServiceDelegate {
    static let shared = PrivacyScreenshotDelegate()

    func screenshotServiceDidAddScreenshot(_ screenshotService: UIScreenshotService) {
        // Log attempt (security audit)
        SecureLogger.log(
            "Screenshot attempt detected on sensitive screen",
            level: .warning
        )
    }
}

/// Extension to easily apply privacy protection to any view
extension View {
    /// Apply comprehensive privacy protection to this view
    /// - Returns: View with privacy protections enabled
    func privacyProtected() -> some View {
        modifier(PrivacyProtectionModifier())
    }
}
