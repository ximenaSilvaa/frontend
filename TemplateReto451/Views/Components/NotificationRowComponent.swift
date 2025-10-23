//
//  NotificationRowComponent.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 17/09/25.
//

import SwiftUI
struct NotificationRowComponent: View {
    let notification: NotificationDTO
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon container
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.brandAccent.opacity(0.15), Color.brandPrimary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)

                    Image(systemName: "bell.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.brandAccent)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(notification.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Text(notification.message)
                        .font(.system(size: 14))
                        .foregroundColor(.brandSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.brandSecondary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.brandSecondary.opacity(0.15), lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
#Preview {
    let sampleNotification = NotificationDTO(
        id: 1,
        created_by: 1,
        title: "Reporte \"Phishing Banco\" aceptado.",
        message: "Tu reporte fue revisado y aprobado exitosamente."
    )

    NotificationRowComponent(notification: sampleNotification) {
        print("Tapped notification")
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
