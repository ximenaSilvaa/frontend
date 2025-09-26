//
//  ScreenNotificationSettings.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//

import SwiftUI

struct ScreenUserSettings: View {
    @Environment(\.dismiss) private var dismiss

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
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    }
                    .padding(.leading)

                    Spacer()

                    Text("Ajustes")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))

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
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    .padding(.horizontal)
                // change destination
                sectionNav(icon: "person", text: "Centro de cuentas", destination: ScreenAccountSettings())
                
                Divider()
        
                NavigationLink(destination: ScreenNotificationSettings()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notificaciones")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                            .padding(.horizontal)

                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.blue)
                            Text("Notificaciones")
                                .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
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
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    .padding(.horizontal)
                //change destination
                sectionNav(icon: "lock", text: "Privacidad de la cuenta",  destination: ScreenPasswordChange())
                Divider()
                Text("Acceso")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    .padding(.horizontal)
                
                Button(action: {
                    // Eliminar tokens
                }) {
                    Text("Cerrar sesión")
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                
                //Change
                Spacer()
                NavigationLink(destination: TermsAndConditionsScreen()) {
                    Text("Términos y condiciones")
                        .foregroundColor(.blue)
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
}

extension ScreenUserSettings {
    @ViewBuilder
    func sectionNav(icon: String, text: String, destination: some View) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(text).foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
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
