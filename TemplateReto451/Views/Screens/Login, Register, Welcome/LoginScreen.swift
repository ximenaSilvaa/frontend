//
//  LoginScreen.swift
//  TemplateReto451
//
//  Created by José Molina on 09/09/25.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(\.authenticationViewModel) var authenticationViewModel
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
            isLoggedIn = try await authenticationViewModel.loginUser(email: email, password: password)
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
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {
                        // Top spacing
                        Spacer(minLength: 120)

        
                        // Title with gradient
                        VStack(spacing: 6) {
                            Text("Bienvenido")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.brandPrimary)

                            Text("Inicia sesión para continuar")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.brandSecondary)
                        }

                        // Form Fields
                        VStack(spacing: 18) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correo Electrónico")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.brandPrimary)

                                TextField("ejemplo@email.com", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
                                    )
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }

                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contraseña")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.brandPrimary)

                                SecurePasswordField(placeholder: "Contraseña", password: $password)
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
                            HStack(spacing: 8) {
                                Text("Ingresar")
                                    .font(.system(size: 16, weight: .bold))
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [Color.brandAccent, Color.brandPrimary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.brandAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(isLoading)
                        .opacity(isLoading ? 0.7 : 1.0)
                        .padding(.horizontal, 32)

                        // Create Account Link
                        HStack(spacing: 4) {
                            Text("¿No tienes cuenta?")
                                .font(.system(size: 14))
                                .foregroundColor(.brandSecondary)

                            NavigationLink(destination: ScreenUserRegistration()) {
                                Text("Regístrate")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.brandAccent)
                            }
                        }

                        // Bottom spacing
                        Spacer(minLength: 20)
                        HStack{
                            // Bottom Logo - Red
                            Image("app-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                                .padding(.bottom, 20)
                            Image("falcon-logo-icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                                .padding(.bottom, 20)
                        }
                       
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
        // ✅ SECURITY: Prevent screenshot and app switcher visibility
        .privacySensitive()
    }
}

#Preview {
    LoginScreen()
}
