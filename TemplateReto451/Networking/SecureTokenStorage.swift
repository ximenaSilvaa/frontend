//
//  SecureTokenStorage.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 26/10/25.
//  Secure token storage using iOS Keychain
//

import Foundation
import Security

/// Secure token storage implementation using iOS Keychain
/// - CRITICAL: Never store authentication tokens in UserDefaults or other insecure storage
/// - Keychain provides:
///   * Encrypted storage
///   * Automatic protection with device security
///   * Isolated access per app
///   * Automatic cleanup on app uninstall
class SecureTokenStorage: TokenStorageProtocol {

    static let shared = SecureTokenStorage()

    private let serviceIdentifier = Bundle.main.bundleIdentifier ?? "com.default.app"

    // MARK: - Protocol Implementation

    /// Save token securely to Keychain
    /// - Parameters:
    ///   - token: The token to save (e.g., accessToken, refreshToken)
    ///   - identifier: The key identifier (e.g., "accessToken", "refreshToken")
    func save(token: String, identifier: String) {
        // Remove existing token first
        remove(identifier: identifier)

        guard let tokenData = token.data(using: .utf8) else {
            Logger.log("Failed to encode token data", level: .error)
            return
        }

        // Prepare Keychain query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            // kSecAttrAccessibleWhenUnlockedThisDeviceOnly ensures token is only accessible
            // when device is unlocked (best security)
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecSuccess {
            Logger.log("Token saved securely: \(identifier)", level: .debug)
        } else {
            Logger.log("Failed to save token: \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)", level: .error)
        }
    }

    /// Retrieve token from Keychain
    /// - Parameter identifier: The key identifier (e.g., "accessToken", "refreshToken")
    /// - Returns: The token string if found and valid, nil otherwise
    func get(identifier: String) -> String? {
        // Prepare Keychain query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status != errSecItemNotFound {
                Logger.log("Failed to retrieve token: \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)", level: .error)
            }
            return nil
        }

        guard let data = result as? Data else {
            Logger.log("Invalid token data format", level: .error)
            return nil
        }

        guard let token = String(data: data, encoding: .utf8) else {
            Logger.log("Failed to decode token data", level: .error)
            return nil
        }

        Logger.log("Token retrieved securely: \(identifier)", level: .debug)
        return token
    }

    /// Remove token from Keychain
    /// - Parameter identifier: The key identifier (e.g., "accessToken", "refreshToken")
    func remove(identifier: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: identifier
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess || status == errSecItemNotFound {
            Logger.log("Token removed: \(identifier)", level: .debug)
        } else {
            Logger.log("Failed to remove token: \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)", level: .error)
        }
    }

    // MARK: - Additional Security Methods

    /// Clear all stored tokens (useful for logout)
    func clearAllTokens() {
        remove(identifier: "accessToken")
        remove(identifier: "refreshToken")
        Logger.log("All tokens cleared from Keychain", level: .info)
    }

    /// Check if token exists in Keychain
    /// - Parameter identifier: The key identifier
    /// - Returns: true if token exists, false otherwise
    func tokenExists(identifier: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: identifier
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Migrate tokens from insecure UserDefaults to secure Keychain
    /// - IMPORTANT: Call this once during app initialization if upgrading from old version
    func migrateFromUserDefaults() {
        Logger.log("Starting migration from UserDefaults to Keychain...", level: .warning)

        let defaults = UserDefaults.standard
        let tokensToMigrate = ["accessToken", "refreshToken"]

        for tokenKey in tokensToMigrate {
            if let oldToken = defaults.string(forKey: tokenKey) {
                // Save to secure Keychain
                save(token: oldToken, identifier: tokenKey)

                // Remove from UserDefaults (IMPORTANT: Remove insecure storage)
                defaults.removeObject(forKey: tokenKey)

                Logger.log("Migrated token: \(tokenKey)", level: .info)
            }
        }

        // Mark migration as complete
        defaults.set(true, forKey: "kTokensMigratedToKeychain")

        Logger.log("Migration completed successfully", level: .info)
    }
}

// MARK: - Error Handling Helper

extension SecureTokenStorage {
    /// Get human-readable error message from Security framework status code
    private func getErrorDescription(_ status: OSStatus) -> String {
        switch status {
        case errSecSuccess:
            return "Success"
        case errSecItemNotFound:
            return "Item not found"
        case errSecDuplicateItem:
            return "Duplicate item"
        case errSecInvalidItemRef:
            return "Invalid item reference"
        case errSecUnimplemented:
            return "Unimplemented"
        case errSecAuthFailed:
            return "Authentication failed"
        case errSecNoDefaultKeychain:
            return "No default keychain"
        default:
            return "Unknown error (status: \(status))"
        }
    }
}
