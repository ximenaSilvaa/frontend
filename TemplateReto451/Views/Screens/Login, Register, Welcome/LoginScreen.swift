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
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    private func login() async {
        // Temporary bypass for testing - allows any login
        isLoggedIn = true

        // Original login code (commented out for testing)
        /*
        do {
            isLoggedIn = try await authenticationController.loginUser(email: email, password: password)
        } catch {
            print("Error en login \(error.localizedDescription)")
        }
        */
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
                                .background(Color.blue)
                                .cornerRadius(25)
                        }
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
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginScreen()
}
