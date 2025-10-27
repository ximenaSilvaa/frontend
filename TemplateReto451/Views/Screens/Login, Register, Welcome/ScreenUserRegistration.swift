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
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Back Button
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.brandPrimary)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // FalconAlert Logo
                        Image("falcon-logo-full")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                            .padding(.horizontal, 40)

                        // Title
                        VStack(spacing: 4) {
                            Text("Crear Cuenta")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.brandPrimary)

                            Text("Únete a la comunidad")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.brandSecondary)
                        }

                        // Form Fields
                        VStack(spacing: 20) {
                            // Full Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nombre Completo")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.brandPrimary)

                                TextField("Ej. Papa Francisco", text: $userForm.name)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
                                    )
                            }

                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correo Electrónico")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.brandPrimary)

                                TextField("ejemplo@email.com", text: $userForm.email)
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

                                SecurePasswordField(placeholder: "Contraseña", password: $userForm.password)
                            }

                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirmar Contraseña")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.brandPrimary)

                                SecurePasswordField(placeholder: "Confirmar Contraseña", password: $userForm.confirmPassword)
                            }
                        }
                        .padding(.horizontal, 32)

                        // Terms and Conditions
                        HStack(spacing: 12) {
                            Button(action: {
                                acceptTerms.toggle()
                            }) {
                                Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 22))
                                    .foregroundColor(acceptTerms ? .brandAccent : .gray.opacity(0.5))
                            }

                            HStack(spacing: 4) {
                                Text("Acepto los")
                                    .font(.system(size: 14))
                                    .foregroundColor(.brandSecondary)

                                Button(action: {
                                    showTerms = true
                                }) {
                                    Text("Términos y Condiciones")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.brandAccent)
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
                            HStack(spacing: 8) {
                                Text("Crear Cuenta")
                                    .font(.system(size: 16, weight: .bold))
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
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



                        // Bottom spacing for keyboard
                        Spacer(minLength: 60)

                        // Bottom Logo - Falcon Icon
                        Image("falcon-logo-icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
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
        // ✅ SECURITY: Prevent screenshot and app switcher visibility
        .privacySensitive()
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
