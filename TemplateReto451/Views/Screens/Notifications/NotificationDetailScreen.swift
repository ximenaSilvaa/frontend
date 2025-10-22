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
                
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()

                VStack {
    
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


                    VStack(spacing: 20) {
 
                        Image(systemName: "bell.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(.blue)

                        VStack(spacing: 12) {
                            Text(notification.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text(notification.message)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
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
    let sampleNotification = NotificationDTO(
        id: 1,
        created_by: 101,
        title: "Nuevos términos y condiciones",
        message: "Consultalos en tu perfil."
    )

    return NotificationDetailScreen(notification: sampleNotification)
}
