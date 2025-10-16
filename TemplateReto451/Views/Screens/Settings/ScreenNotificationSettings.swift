//
//  ScreenNotificationSettings.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//
import SwiftUI

struct ScreenNotificationSettings: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = NotificationSettingsViewModel()

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


                Text("Mis reportes")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal)

                sectionToggle(
                    icon: "bell",
                    text: "Notificarme procesos",
                    isOn: Binding(
                        get: { vm.isReviewEnabled },
                        set: {
                            vm.isReviewEnabled = $0
                            Task {
                                await vm.saveSettings()
                            }
                        }
                    )
                )

                if vm.isLoading {
                    ProgressView("Guardando cambios...")
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .task {
            await vm.loadSettings()
        }
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

#Preview {
    ScreenNotificationSettings()
}
