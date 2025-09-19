//
//  NotificationDetailScreen.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import SwiftUI

struct NotificationDetailScreen: View {
    let notification: NotificationItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()

                VStack {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Spacer()

                    // Content Card
                    VStack(spacing: 20) {
                        // Icon
                        Image(systemName: notification.iconName)
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(notification.iconColor)

                        // Title and Description
                        VStack(spacing: 12) {
                            Text(notification.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            if let description = notification.description {
                                Text(description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }

                        // Action Button (Placeholder)
                        if notification.status == .rejected {
                            Button(action: {
                                // Placeholder action
                                print("Editar reporte tapped")
                            }) {
                                Text("Editar reporte")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 40)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 30)

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let sampleNotification = NotificationItem(
        type: .misReportes,
        status: .rejected,
        title: "Reporte \"Virus link\" rechazado",
        description: "el link no es válido.",
        timeAgo: "2 d",
        iconName: "minus.square",
        iconColor: .red,
        date: Date()
    )

    return NotificationDetailScreen(notification: sampleNotification)
}