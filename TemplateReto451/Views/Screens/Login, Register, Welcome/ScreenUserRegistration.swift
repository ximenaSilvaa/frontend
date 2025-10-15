//
//  ScreenUserRegistration.swift
//  TemplateReto451
//
//  Created by José Molina on 26/08/25.
//

import SwiftUI

struct ScreenUserRegistration: View {
    @Environment(\.authenticationViewModel) var authenticationViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var errors: [String] = []
    @State private var userForm = UserForm()
    @State private var acceptTerms = false
    @State private var showTerms = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showSuccessAlert: Bool = false

    func register() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await authenticationViewModel.registerUser(name: userForm.name, email: userForm.email, password: userForm.password)
            isLoading = false
            showSuccessAlert = true
        } catch {
            isLoading = false
            print("❌ Error al realizar el registro: \(error)")
            print("❌ Error description: \(error.localizedDescription)")

            // Set user-friendly error message
            if error.localizedDescription.contains("Email already exists") || error.localizedDescription.contains("already exists") || error.localizedDescription.contains("Conflict") {
                errorMessage = "Este correo ya está registrado"
            } else if error.localizedDescription.contains("network") || error.localizedDescription.contains("Network") {
                errorMessage = "Error de conexión. Verifica tu internet"
            } else if error.localizedDescription.contains("404") || error.localizedDescription.contains("Not Found") {
                errorMessage = "Error del servidor. El endpoint no existe."
            } else {
                errorMessage = "Error al crear la cuenta. Intenta de nuevo: \(error.localizedDescription)"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Back Button and Title
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                            }

                            Spacer()

                            Text("Crear Cuenta")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)

                            Spacer()

                            // Invisible spacer for balance
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .opacity(0)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // Form Fields
                        VStack(spacing: 20) {
                            // Full Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nombre Completo")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)

                                TextField("Ej. Papa Francisco", text: $userForm.name)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }

                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correo Electrónico")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)

                                TextField("ejemplo@email.com", text: $userForm.email)
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

                                SecureFieldWithToggle(placeholder: "Contraseña", text: $userForm.password)
                            }

                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirmar Contraseña")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)

                                SecureFieldWithToggle(placeholder: "Contraseña", text: $userForm.confirmPassword)
                            }
                        }
                        .padding(.horizontal, 32)

                        // Terms and Conditions
                        HStack(spacing: 12) {
                            Button(action: {
                                acceptTerms.toggle()
                            }) {
                                Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 20))
                                    .foregroundColor(acceptTerms ? .blue : .gray)
                            }

                            HStack(spacing: 4) {
                                Text("Acepto los")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)

                                Button(action: {
                                    showTerms = true
                                }) {
                                    Text("Términos y Condiciones")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.blue)
                                        .underline()
                                }
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 32)

                        // Validation Errors
                        if !errors.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(errors, id: \.self) { error in
                                    HStack(spacing: 6) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.brandAccent)
                                            .font(.system(size: 12))

                                        Text(error)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.brandAccent)
                                    }
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.brandAccent.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal, 32)
                        }

                        // Backend Error Message
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

                        // Create Account Button
                        Button(action: {
                            errors = userForm.validate()
                            if !acceptTerms {
                                errors.append("Debes aceptar los términos y condiciones")
                            }
                            print(errors)
                            if errors.isEmpty {
                                Task {
                                    await register()
                                }
                            }
                        }) {
                            Text("Crear Cuenta")
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

                      
                        // Bottom spacing for keyboard
                        Spacer(minLength: 60)

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
        .sheet(isPresented: $showTerms) {
            TermsAndConditionsScreen()
        }
        .alert("Cuenta Creada", isPresented: $showSuccessAlert) {
            Button("Iniciar Sesión") {
                dismiss()
            }
        } message: {
            Text("Tu cuenta ha sido creada exitosamente. Ahora puedes iniciar sesión.")
        }
    }
}

extension ScreenUserRegistration {
    private struct UserForm{
        var name: String = ""
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""

        func validate() -> [String] {
            var errors:[String] = []
            if name.isEmptyOrWhitespace{
                errors.append("El nombre es requerido")
            }
            if email.isEmptyOrWhitespace{
                    errors.append("El correo es requerido")
                }
            if password.isEmptyOrWhitespace{
                    errors.append("La contraseña es requerida")
                }
            if confirmPassword.isEmptyOrWhitespace{
                    errors.append("La confirmación de contraseña es requerida")
                }
            if !email.isValidEmail{
                    errors.append("Correo no es válido")
                }
            if !password.isValidPassword{
                    errors.append("La contraseña debe tener al menos 8 caracteres")
                }
            if password != confirmPassword {
                    errors.append("Las contraseñas no coinciden")
                }
            return errors
        }
    }
}

#Preview {
    ScreenUserRegistration()
}
