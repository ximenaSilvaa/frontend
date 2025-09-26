//
//  TermsAndConditionsScreen.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import SwiftUI

struct TermsAndConditionsScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                        }

                        Spacer()

                        Text("Términos y Condiciones")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)

                        Spacer()

                        // Invisible spacer for balance
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .opacity(0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Red por la Ciberseguridad - Términos y Condiciones")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)

                        Text("Última actualización: 17 de septiembre de 2025")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)

                        Group {
                            sectionView(title: "1. Aceptación de los Términos", content: """
                            Al acceder y utilizar la aplicación Red por la Ciberseguridad, usted acepta estar sujeto a estos términos y condiciones. Si no está de acuerdo con alguna parte de estos términos, no debe utilizar nuestra aplicación.
                            """)

                            sectionView(title: "2. Uso de la Aplicación", content: """
                            Esta aplicación está diseñada para proporcionar información y herramientas relacionadas con la ciberseguridad. El usuario se compromete a:
                            • Utilizar la aplicación de manera responsable y ética
                            • No intentar comprometer la seguridad de la aplicación
                            • Proporcionar información veraz y actualizada
                            • Mantener la confidencialidad de sus credenciales de acceso
                            """)

                            sectionView(title: "3. Privacidad y Protección de Datos", content: """
                            Nos comprometemos a proteger su privacidad y datos personales de acuerdo con las leyes aplicables de protección de datos. La información recopilada se utiliza únicamente para los fines establecidos en nuestra política de privacidad.
                            """)

                            sectionView(title: "4. Responsabilidades del Usuario", content: """
                            El usuario es responsable de:
                            • Mantener la seguridad de su cuenta
                            • Utilizar contraseñas seguras
                            • Reportar cualquier actividad sospechosa
                            • Cumplir con las leyes locales aplicables
                            """)

                        }
                    }
                    .padding(.horizontal, 20)

                    // Bottom spacing
                    Spacer(minLength: 40)
                }
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }

    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            Text(content)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .lineSpacing(4)
        }
    }
}

#Preview {
    TermsAndConditionsScreen()
}
