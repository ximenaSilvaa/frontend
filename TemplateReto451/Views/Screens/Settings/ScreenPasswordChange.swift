//
//  ScreenPasswordChange.swift
//  TemplateReto451
//
//  Created by Claude on 19/09/25.
//
import SwiftUI

struct ScreenPasswordChange: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ChangePasswordViewModel()

    @State private var showCurrentPassword: Bool = false
    @State private var showNewPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
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

                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .opacity(0)
                        .padding(.trailing)
                }

                Text("La contraseña debe tener al menos 8 caracteres")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)

                VStack(spacing: 16) {
                    passwordField(
                        placeholder: "Contraseña actual",
                        text: $vm.oldPassword,
                        isSecure: !showCurrentPassword,
                        showPassword: $showCurrentPassword
                    )

                    passwordField(
                        placeholder: "Contraseña nueva",
                        text: $vm.newPassword,
                        isSecure: !showNewPassword,
                        showPassword: $showNewPassword
                    )

                    passwordField(
                        placeholder: "Repetir contraseña",
                        text: $vm.confirmPassword,
                        isSecure: !showConfirmPassword,
                        showPassword: $showConfirmPassword
                    )
                }
                .padding(.horizontal)


                if !vm.validationErrors.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(vm.validationErrors, id: \.self) { error in
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color.brandAccent)
                                    .font(.system(size: 14))

                                Text(error)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.brandAccent)
                                    .multilineTextAlignment(.leading)

                                Spacer()
                            }
                            .padding(12)
                            .background(Color.brandAccent.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                }

                if let errorMessage = vm.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Color.brandAccent)
                            .font(.system(size: 14))

                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.brandAccent)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.brandAccent.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                if let successMessage = vm.successMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color.green)
                            .font(.system(size: 14))

                        Text(successMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.green)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                Button {
                    Task {
                        await vm.changePassword()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Cambiar contraseña")
                            .font(.system(size: 16, weight: .bold))
                        if vm.isLoading {
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
                .disabled(vm.isLoading)
                .opacity(vm.isLoading ? 0.7 : 1.0)
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

            Button {
                showPassword.wrappedValue.toggle()
            } label: {
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

