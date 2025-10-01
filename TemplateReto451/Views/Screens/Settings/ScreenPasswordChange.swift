//
//  ScreenPasswordChange.swift
//  TemplateReto451
//
//  Created by Claude on 19/09/25.
//

import SwiftUI

struct ScreenPasswordChange: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showCurrentPassword: Bool = false
    @State private var showNewPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    var body: some View {
        ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with back arrow
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(Color.brandPrimary)
                        }
                        .padding(.leading)

                        Spacer()

                        Text("Cambiar contraseña")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.brandPrimary)

                        Spacer()

                        // Invisible spacer to center the title
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .opacity(0)
                            .padding(.trailing)
                    }

                    Text("La contraseña debe tener al menos 6 caracteres e incluir una combinación de número, letras y caracteres especiales (0%).")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)

                    VStack(spacing: 16) {
                        passwordField(
                            placeholder: "Contraseña actual",
                            text: $currentPassword,
                            isSecure: !showCurrentPassword,
                            showPassword: $showCurrentPassword
                        )

                        passwordField(
                            placeholder: "Contraseña nueva",
                            text: $newPassword,
                            isSecure: !showNewPassword,
                            showPassword: $showNewPassword
                        )

                        passwordField(
                            placeholder: "Repetir contraseña",
                            text: $confirmPassword,
                            isSecure: !showConfirmPassword,
                            showPassword: $showConfirmPassword
                        )
                    }
                    .padding(.horizontal)

                    Button(action: {
                        // Handle password change
                    }) {
                        Text("Cambiar contraseña")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.brandAccent)
                            .cornerRadius(25)
                            .shadow(color: Color.brandAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    Spacer()
                }
                .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    func passwordField(placeholder: String, text: Binding<String>, isSecure: Bool, showPassword: Binding<Bool>) -> some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: text)
                    .font(.system(size: 16))
            } else {
                TextField(placeholder, text: text)
                    .font(.system(size: 16))
            }

            Button(action: {
                showPassword.wrappedValue.toggle()
            }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.brandSecondary.opacity(0.3), lineWidth: 1.5)
        )
    }
}

#Preview {
    ScreenPasswordChange()
}