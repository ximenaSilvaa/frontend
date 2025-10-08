//
//  ScreenNotificationSettings.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//

import SwiftUI

struct ScreenUserSettings: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isLoggingOut: Bool = false

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

                    Text("Ajustes")
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

               

                Text("Tu cuenta")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal)
                // change destination
                sectionNav(icon: "person", text: "Centro de cuentas", destination: ScreenAccountSettings())
                
                Divider()
        
                NavigationLink(destination: ScreenNotificationSettings()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notificaciones")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.brandPrimary)
                            .padding(.horizontal)

                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(Color.brandAccent)
                            Text("Notificaciones")
                                .foregroundColor(Color.brandPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                Divider()

                Text("Privacidad")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal)
                //change destination
                sectionNav(icon: "lock", text: "Privacidad de la cuenta",  destination: ScreenPasswordChange())
                Divider()
                Text("Acceso")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal)
                
                Button(action: {
                    logout()
                }) {
                    HStack {
                        if isLoggingOut {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text("Cerrar sesión")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(isLoggingOut ? Color.brandAccent.opacity(0.6) : Color.brandAccent)
                    .cornerRadius(20)
                    .shadow(color: Color.brandAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(isLoggingOut)
                
                //Change
                Spacer()
                NavigationLink(destination: TermsAndConditionsScreen()) {
                    Text("Términos y condiciones")
                        .foregroundColor(Color.brandAccent)
                        .underline()
                        .frame(maxWidth: .infinity) // Ocupa todo el ancho
                        .multilineTextAlignment(.center) // Centra el texto
                        .padding()
                }


        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        }
    }

    private func logout() {
        isLoggingOut = true

        // Clear tokens
        TokenStorage.shared.remove(identifier: "accessToken")
        TokenStorage.shared.remove(identifier: "refreshToken")

        // Small delay to show loading indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoggedIn = false
            isLoggingOut = false
        }
    }
}

extension ScreenUserSettings {
    @ViewBuilder
    func sectionNav(icon: String, text: String, destination: some View) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.brandAccent)
                Text(text).foregroundColor(Color.brandPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    ScreenUserSettings()
}
