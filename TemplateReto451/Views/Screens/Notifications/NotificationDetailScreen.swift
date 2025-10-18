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
            VStack(spacing: 20) {
                Text(notification.title)
                    .font(.title)
                    .bold()

                Text(notification.message)
                    .font(.body)

                Spacer()
            }
            .padding()
            .navigationBarItems(leading: Button("Cerrar") {
                dismiss()
            })
        }
    }
}
