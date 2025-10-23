//
//  NotificationDetailScreen.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import SwiftUI

struct NotificationDetailScreen: View {
    let notification: NotificationDTO
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header with back button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Atrás")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.brandPrimary)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    ScrollView {
                        VStack(spacing: 24) {
                            // Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.brandAccent.opacity(0.15), Color.brandPrimary.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)

                                Image(systemName: "bell.fill")
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(.brandAccent)
                            }
                            .padding(.top, 20)

                            // Content card
                            VStack(spacing: 16) {
                                Text(notification.title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.brandPrimary)
                                    .multilineTextAlignment(.center)

                                Divider()
                                    .background(Color.brandSecondary.opacity(0.2))

                                Text(notification.message)
                                    .font(.system(size: 16))
                                    .foregroundColor(.brandSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 28)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.brandSecondary.opacity(0.15), lineWidth: 1.5)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let sampleNotification = NotificationDTO(
        id: 1,
        created_by: 101,
        title: "Nuevos términos y condiciones",
        message: "Consultalos en tu perfil."
    )

    return NotificationDetailScreen(notification: sampleNotification)
}
