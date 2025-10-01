//
//  NotificationRowComponent.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import SwiftUI

struct NotificationRowComponent: View {
    let notification: NotificationItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: notification.iconName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(notification.iconColor)
                    .frame(width: 24, height: 24)

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.brandPrimary)
                        .multilineTextAlignment(.leading)

                    if let description = notification.description {
                        Text(description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()

                // Time
                Text(notification.timeAgo)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
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
    let sampleNotification = NotificationItem(
        type: .misReportes,
        status: .accepted,
        title: "Reporte \"Phishing Banco\" aceptado.",
        description: nil,
        timeAgo: "1 d",
        iconName: "checkmark.square",
        iconColor: .blue,
        date: Date()
    )

    return NotificationRowComponent(notification: sampleNotification) {
        print("Tapped notification")
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}