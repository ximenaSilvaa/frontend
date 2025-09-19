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

                    Text("Notificaciones")
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
                
                // Usamos métodos seguros para cambiar el estado
                sectionToggle(
                    icon: "bell",
                    text: "Pausar todas",
                    isOn: Binding(
                        get: { nsc.isPaused },
                        set: { nsc.setPaused($0) }
                    )
                )
                
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
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    .padding(.horizontal)
                
                sectionToggle(
                    icon: "bell",
                    text: "Notificarme reacciones",
                    isOn: Binding(
                        get: { nsc.isReactionsEnabled },
                        set: {
                            nsc.isReactionsEnabled = $0
                            nsc.updateStatesFromIndividualToggles()
                        }
                    )
                )
                
                Text("Mis reportes")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    .padding(.horizontal)
                
                sectionToggle(
                    icon: "bell",
                    text: "Notificarme procesos",
                    isOn: Binding(
                        get: { nsc.isReviewEnabled },
                        set: {
                            nsc.isReviewEnabled = $0
                            nsc.updateStatesFromIndividualToggles()
                        }
                    )
                )
                
                Text("Reportes recomendados")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    .padding(.horizontal)
                
                sectionToggle(
                    icon: "bell",
                    text: "Notificarme reportes",
                    isOn: Binding(
                        get: { nsc.isReportsEnabled },
                        set: {
                            nsc.isReportsEnabled = $0
                            nsc.updateStatesFromIndividualToggles()
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
                .foregroundColor(.blue)
            Text(text)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(.horizontal)
    }
}

// Changed from #Preview to struct PreviewProvider
struct ScreenNotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
        ScreenNotificationSettings()
    }
}
