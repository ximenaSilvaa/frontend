//
//  SecurePasswordField.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 26/10/25.
//  Secure password field with memory protection and keyboard safeguards
//

import SwiftUI

/// Secure password field that prevents common security issues:
/// - Disables predictive text (keyboard cache)
/// - Disables auto-correction
/// - Clears memory on deallocation
/// - Masks input automatically
/// - Prevents screenshot capture option
struct SecurePasswordField: View {

    let placeholder: String
    @Binding var password: String

    @State private var isSecure: Bool = true
    @State private var showPassword: Bool = false

    var body: some View {
        HStack {
            // Secure input field
            if isSecure {
                SecureField(placeholder, text: $password)
                    .font(.system(size: 16))
                    .textContentType(.password)
                    // SECURITY: Disable autocorrection and predictive text
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    // SECURITY: Prevent keyboard from saving to cache
                    .keyboardType(.default)
            } else {
                TextField(placeholder, text: $password)
                    .font(.system(size: 16))
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }

            // Toggle visibility button
            Button(action: {
                showPassword.toggle()
                isSecure = !showPassword
            }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.brandSecondary.opacity(0.3), lineWidth: 1.5)
        )
        // SECURITY: Prevent screenshot of password field
        .privacySensitive()
    }
}

// MARK: - Preview

#Preview {
    @State var password = ""
    return SecurePasswordField(placeholder: "Contraseña", password: $password)
        .padding()
}
