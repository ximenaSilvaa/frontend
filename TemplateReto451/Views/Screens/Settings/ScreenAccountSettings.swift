//
//  ScreenAccountSettings.swift
//  TemplateReto451
//
//  Created by Claude on 19/09/25.
//

import SwiftUI

struct ScreenAccountSettings: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AccountSettingsViewModel()
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

                    Text("Privacidad")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.brandPrimary)

                    Spacer()


                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .opacity(0)
                        .padding(.trailing)
                }

                VStack(alignment: .leading, spacing: 16) {
                    privacyToggle(
                        title: "Reportes anónimos",
                        description: "Los reportes se crean con un nombre de usuario aleatorio.",
                        isOn: Binding(
                            get: { vm.isAnonymousPreferred },
                            set: {
                                vm.isAnonymousPreferred = $0
                                Task {
                                    await vm.saveSettings()
                                }
                            }
                        )
                    )
                }
                .padding(.horizontal)

                if vm.isLoading {
                    ProgressView("Guardando cambios...")
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .task {
            await vm.loadSettings()
        }
    }

    @ViewBuilder
    func privacyToggle(title: String, description: String, isOn: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)

                Spacer()

                Toggle("", isOn: isOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color.brandAccent))
            }

            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ScreenAccountSettings()
}
