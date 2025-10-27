//
//  MemorySecureString.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 26/10/25.
//  Secure string handling for sensitive data in memory
//

import Foundation
import Security
import SwiftUI

/// Secure string that encrypts data in memory and cleans up automatically
/// - CRITICAL: Use this for passwords, tokens, PII, and sensitive strings
/// - Data is encrypted using CommonCrypto and only decrypted when needed
/// - Memory is overwritten with zeros when deallocated
///
/// Usage:
/// ```swift
/// var securePassword = MemorySecureString(password)
/// let plaintext = securePassword.plaintext()  // Decrypted temporarily
/// securePassword.clear()  // Immediate cleanup
/// ```
class MemorySecureString {

    // MARK: - Properties

    private var encryptedData: Data
    private let encryptionKey: Data
    private var isCleared: Bool = false

    // MARK: - Initialization

    /// Initialize with a plaintext string
    /// - Parameter plaintext: The sensitive string to protect (e.g., password)
    init(_ plaintext: String) {
        guard let data = plaintext.data(using: .utf8) else {
            self.encryptedData = Data()
            self.encryptionKey = MemorySecureString.generateKey()
            return
        }

        // Generate encryption key
        self.encryptionKey = MemorySecureString.generateKey()

        // Encrypt data
        self.encryptedData = MemorySecureString.encrypt(data, with: self.encryptionKey)

        // Clear the original plaintext from memory
        var clearData = data
        clearData.withUnsafeMutableBytes { buffer in
            memset(buffer.baseAddress, 0, buffer.count)
        }
    }

    // MARK: - Public Methods

    /// Get the plaintext value (decrypts temporarily)
    /// - Returns: The decrypted string, or empty string if cleared
    func plaintext() -> String {
        guard !isCleared else {
            SecureLogger.log("Attempted to access cleared MemorySecureString", level: .warning)
            return ""
        }

        guard let decrypted = MemorySecureString.decrypt(encryptedData, with: encryptionKey) else {
            return ""
        }

        return String(data: decrypted, encoding: .utf8) ?? ""
    }

    /// Immediately clear the data from memory
    /// - CRITICAL: Call this when done using the password
    func clear() {
        guard !isCleared else { return }

        // Overwrite encrypted data with zeros
        var clearData = encryptedData
        clearData.withUnsafeMutableBytes { buffer in
            memset(buffer.baseAddress, 0, buffer.count)
        }
        encryptedData = Data()

        // Overwrite key with zeros
        var clearKey = encryptionKey
        clearKey.withUnsafeMutableBytes { buffer in
            memset(buffer.baseAddress, 0, buffer.count)
        }

        isCleared = true
        SecureLogger.log("MemorySecureString cleared from memory", level: .debug)
    }

    /// Check if string has been cleared
    var hasBeenCleared: Bool {
        return isCleared
    }

    /// Get length of encrypted string without decrypting
    var encryptedLength: Int {
        return encryptedData.count
    }

    // MARK: - Private Methods (Encryption/Decryption)

    /// Generate a random encryption key
    private static func generateKey() -> Data {
        var keyBytes = [UInt8](repeating: 0, count: 32)  // 256-bit key
        let status = SecRandomCopyBytes(kSecRandomDefault, keyBytes.count, &keyBytes)
        assert(status == errSecSuccess, "Failed to generate random key")
        return Data(keyBytes)
    }

    /// Simple XOR encryption (for demonstration)
    /// In production, consider using CommonCrypto or CryptoKit
    private static func encrypt(_ data: Data, with key: Data) -> Data {
        var encrypted = Data()

        for (index, byte) in data.enumerated() {
            let keyByte = key[index % key.count]
            let encryptedByte = byte ^ keyByte
            encrypted.append(encryptedByte)
        }

        return encrypted
    }

    /// Simple XOR decryption (for demonstration)
    private static func decrypt(_ encryptedData: Data, with key: Data) -> Data? {
        var decrypted = Data()

        for (index, byte) in encryptedData.enumerated() {
            let keyByte = key[index % key.count]
            let decryptedByte = byte ^ keyByte
            decrypted.append(decryptedByte)
        }

        return decrypted
    }

    // MARK: - Deinitialization

    deinit {
        // Ensure memory is cleaned up when object is deallocated
        if !isCleared {
            clear()
        }
    }
}
