//
//  SecureLogger.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 26/10/25.
//  Secure logging system that sanitizes PII and sensitive data
//

import Foundation
import os.log

/// Secure logging system that prevents PII (Personally Identifiable Information) exposure
/// - CRITICAL: Never log emails, passwords, tokens, or personal data
/// - IMPORTANT: This logger sanitizes sensitive information
/// - GDPR/CCPA compliant logging
@available(iOS 14.0, *)
class SecureLogger {

    // MARK: - Log Levels

    enum LogLevel: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        case critical = "CRITICAL"

        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .warning:
                return .default
            case .error:
                return .error
            case .critical:
                return .error
            }
        }
    }

    // MARK: - Private Properties

    private static let osLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.app", category: "Security")

    // MARK: - Main Logging Methods

    /// Log a message safely (automatic sanitization)
    /// - Parameters:
    ///   - message: The message to log (PII will be automatically removed)
    ///   - level: The log level
    ///   - sensitiveDataKeys: Keys that contain sensitive data to sanitize
    static func log(_ message: String,
                    level: LogLevel = .info,
                    sensitiveDataKeys: [String] = [],
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {

        // Sanitize message automatically
        let sanitizedMessage = sanitize(message, sensitiveKeys: sensitiveDataKeys)

        // Only log in DEBUG builds
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let formattedMessage = "[\(fileName):\(line)] \(function) - \(sanitizedMessage)"

        os_log("%{public}@", log: osLog, type: level.osLogType, formattedMessage)
        print("\(level.rawValue) \(formattedMessage)")
        #else
        // In RELEASE: Only log critical errors without details
        if level == .critical {
            os_log("%{public}@", log: osLog, type: level.osLogType, message)
        }
        #endif
    }

    // MARK: - Specialized Logging Methods

    /// Log authentication events WITHOUT exposing user data
    /// - Parameters:
    ///   - action: The authentication action (e.g., "login", "logout", "register")
    ///   - success: Whether the action succeeded
    static func logAuthenticationEvent(_ action: String, success: Bool) {
        let status = success ? "successful" : "failed"
        let message = "Authentication event: \(action) - \(status)"
        log(message, level: success ? .info : .warning)
    }

    /// Log network request WITHOUT exposing user data
    /// - Parameters:
    ///   - endpoint: The endpoint path (e.g., "/auth/login" - not full URL)
    ///   - method: HTTP method (GET, POST, etc.)
    ///   - statusCode: HTTP response status code
    static func logNetworkRequest(endpoint: String, method: String, statusCode: Int) {
        let message = "Network: \(method) \(endpoint) - Status: \(statusCode)"
        let level: LogLevel = statusCode < 400 ? .info : .warning
        log(message, level: level)
    }

    /// Log data access WITHOUT exposing the data itself
    /// - Parameters:
    ///   - resource: What resource is being accessed
    ///   - success: Whether access succeeded
    static func logDataAccess(_ resource: String, success: Bool) {
        let status = success ? "accessible" : "not accessible"
        let message = "Data access: \(resource) - \(status)"
        log(message, level: success ? .debug : .warning)
    }

    /// Log errors WITHOUT exposing sensitive error details
    /// - Parameters:
    ///   - error: The error that occurred
    ///   - context: Context where error occurred
    static func logError(_ error: Error, context: String) {
        // Don't log full error description (may contain sensitive data)
        let errorType = String(describing: type(of: error))
        let message = "Error in \(context): \(errorType)"
        log(message, level: .error)
    }

    // MARK: - Data Sanitization

    /// Sanitize a message by removing or masking sensitive data
    /// - Parameters:
    ///   - message: The original message
    ///   - sensitiveKeys: Keys to treat as sensitive
    /// - Returns: Sanitized message with sensitive data removed/masked
    private static func sanitize(_ message: String, sensitiveKeys: [String]) -> String {
        var sanitized = message

        // Remove common PII patterns
        // Email pattern
        sanitized = sanitized.replacingOccurrences(
            of: "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}",
            with: "[email]",
            options: .regularExpression
        )

        // Phone pattern (various formats)
        sanitized = sanitized.replacingOccurrences(
            of: "\\+?[1-9]\\d{1,14}",
            with: "[phone]",
            options: .regularExpression
        )

        // Social Security Number pattern
        sanitized = sanitized.replacingOccurrences(
            of: "\\d{3}-\\d{2}-\\d{4}",
            with: "[ssn]",
            options: .regularExpression
        )

        // Credit card pattern
        sanitized = sanitized.replacingOccurrences(
            of: "\\d{4}[\\s-]?\\d{4}[\\s-]?\\d{4}[\\s-]?\\d{4}",
            with: "[card]",
            options: .regularExpression
        )

        // Token-like patterns (long alphanumeric strings that look like JWTs or API keys)
        sanitized = sanitized.replacingOccurrences(
            of: "eyJ[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]+",
            with: "[token]",
            options: .regularExpression
        )

        // API Key patterns (if field names indicate API keys)
        if sensitiveKeys.contains("apiKey") || sensitiveKeys.contains("api_key") {
            sanitized = sanitized.replacingOccurrences(
                of: "api[_-]?key[\":]?\\s*[\":]?[^\\s,}]+",
                with: "[api_key]",
                options: [.regularExpression, .caseInsensitive]
            )
        }

        // Password patterns
        if sensitiveKeys.contains("password") {
            sanitized = sanitized.replacingOccurrences(
                of: "password[\":]?\\s*[\":]?[^\\s,}]+",
                with: "password: [redacted]",
                options: [.regularExpression, .caseInsensitive]
            )
        }

        // Custom sensitive keys
        for key in sensitiveKeys {
            let pattern = "\(key)[\":]?\\s*[\":]?([^\\s,}]+)"
            sanitized = sanitized.replacingOccurrences(
                of: pattern,
                with: "\(key): [redacted]",
                options: .regularExpression
            )
        }

        return sanitized
    }

    // MARK: - Utility Methods

    /// Hash a value for logging (useful for identifying users without exposing PII)
    /// - Parameter value: The value to hash (e.g., email)
    /// - Returns: A hashed version safe to log
    static func hashForLogging(_ value: String) -> String {
        let data = value.data(using: .utf8) ?? Data()
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.prefix(8).joined()
    }

    /// Mask a value for logging (show first 3 and last 3 characters)
    /// - Parameter value: The value to mask
    /// - Returns: Masked version like "exa...com"
    static func maskForLogging(_ value: String) -> String {
        guard value.count > 6 else {
            return String(repeating: "*", count: value.count)
        }
        let prefix = String(value.prefix(3))
        let suffix = String(value.suffix(3))
        return "\(prefix)...\(suffix)"
    }
}

// MARK: - Convenience Functions (Module-level)

/// Convenience function for secure logging
func secureLog(_ message: String,
               level: SecureLogger.LogLevel = .info,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {
    SecureLogger.log(message, level: level, file: file, function: function, line: line)
}

// MARK: - SHA256 Helper (for hashing)

import CryptoKit

extension SHA256 {
    static func hash(data: Data) -> SHA256Digest {
        return CryptoKit.SHA256.hash(data: data)
    }
}
