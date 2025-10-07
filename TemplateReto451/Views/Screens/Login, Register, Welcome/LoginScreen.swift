//
//  LoginScreen.swift
//  TemplateReto451
//
//  Created by José Molina on 09/09/25.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(\.authenticationController) var authenticationController
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    private func login() async {
        // Clear previous error
        errorMessage = nil
        isLoading = true

        do {
            isLoggedIn = try await authenticationController.loginUser(email: email, password: password)
            isLoading = false
        } catch {
            isLoading = false
            print("Error en login \(error.localizedDescription)")

            // Set user-friendly error message
            if error.localizedDescription.contains("User not found") {
                errorMessage = "No se encontró una cuenta con este correo"
            } else if error.localizedDescription.contains("Invalid password") {
                errorMessage = "Contraseña incorrecta"
            } else if error.localizedDescription.contains("network") {
                errorMessage = "Error de conexión. Verifica tu internet"
            } else {
                errorMessage = "Error al iniciar sesión. Intenta de nuevo"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 40) {
                        // Top spacing
                        Spacer(minLength: 60)

                        // Title
                        Text("Iniciar Sesión")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)

                        // Form Fields
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correo Electrónico")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)

                                TextField("ejemplo@email.com", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }

                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contraseña")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)

                                SecureFieldWithToggle(placeholder: "Contraseña", text: $password)
                            }
                        }
                        .padding(.horizontal, 32)

                        // Error Message
                        if let error = errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.brandAccent)
                                    .font(.system(size: 14))

                                Text(error)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.brandAccent)
                                    .multilineTextAlignment(.leading)

                                Spacer()
                            }
                            .padding(12)
                            .background(Color.brandAccent.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal, 32)
                        }

                        // Login Button
                        Button(action: {
                            Task {
                                await login()
                            }
                        }) {
                            Text("Ingresar")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.brandAccent)
                                .cornerRadius(25)
                        }
                        .disabled(isLoading)
                        .opacity(isLoading ? 0.6 : 1.0)
                        .padding(.horizontal, 32)

                        // Create Account Link
                        NavigationLink(destination: ScreenUserRegistration()) {
                            Text("Crear Cuenta")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .underline()
                        }

                        // Bottom spacing for keyboard
                        Spacer(minLength: 40)

                        // Bottom Logo
                        Image("app-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .padding(.bottom, 30)
                    }
                }
                .scrollDismissesKeyboard(.interactively)

                // Loading Overlay
                if isLoading {
                    LoadingView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginScreen()
}
