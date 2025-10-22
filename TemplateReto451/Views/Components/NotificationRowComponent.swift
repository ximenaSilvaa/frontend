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
            HStack(spacing: 12) {

                Image(systemName: "bell.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.brandPrimary)
                        .multilineTextAlignment(.leading)
                        .bold()

                    Text(notification.message)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.brandSecondary.opacity(0.1), lineWidth: 1)
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
