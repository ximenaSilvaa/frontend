//
//  ScreenNotificationSettings.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//
import SwiftUI

struct ScreenNotificationSettings: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var nsc = NotificationSettingsController()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
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

                    Text("Notificaciones")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.brandPrimary)

                    Spacer()

                    
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .opacity(0)
                        .padding(.trailing)
                }
                
                sectionToggle(
                    icon: "bell",
                    text: "Activar todas",
                    isOn: Binding(
                        get: { nsc.isActivated },
                        set: { nsc.setActivated($0) }
                    )
                )
                
                Text("Comunidad")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal)
                
                sectionToggle(
                    icon: "bell",
                    text: "Notificarme reacciones",
                    isOn: Binding(
                        get: { nsc.isReactionsEnabled },
                        set: {
                            nsc.isReactionsEnabled = $0
                            nsc.updateState()
                        }
                    )
                )
                
                Text("Mis reportes")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal)
                
                sectionToggle(
                    icon: "bell",
                    text: "Notificarme procesos",
                    isOn: Binding(
                        get: { nsc.isReviewEnabled },
                        set: {
                            nsc.isReviewEnabled = $0
                            nsc.updateState()
                        }
                    )
                )
                
                Text("Reportes recomendados")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal)
                
                sectionToggle(
                    icon: "bell",
                    text: "Notificarme reportes",
                    isOn: Binding(
                        get: { nsc.isReportsEnabled },
                        set: {
                            nsc.isReportsEnabled = $0
                            nsc.updateState()
                        }
                    )
                )
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func sectionToggle(icon: String, text: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.brandAccent)
            Text(text)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.brandAccent))
        }
        .padding(.horizontal)
    }
}

struct ScreenNotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
        ScreenNotificationSettings()
    }
}
