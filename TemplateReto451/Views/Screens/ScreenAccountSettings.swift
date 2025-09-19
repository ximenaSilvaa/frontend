//
//  ScreenAccountSettings.swift
//  TemplateReto451
//
//  Created by Claude on 19/09/25.
//

import SwiftUI

struct ScreenAccountSettings: View {
    @Environment(\.dismiss) private var dismiss
    @State private var anonymousReports: Bool = true

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

                        Text("Privacidad")
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

                    VStack(alignment: .leading, spacing: 16) {
                        privacyToggle(
                            title: "Reportes anónimos",
                            description: "Los reportes se crean con un nombre de usuario aleatorio.",
                            isOn: $anonymousReports
                        )
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
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
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
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