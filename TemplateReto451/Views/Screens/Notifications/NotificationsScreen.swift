//
//  NotificationsScreen.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import SwiftUI

struct NotificationsScreen: View {
    @StateObject private var notificationData = NotificationData()
    @State private var selectedFilter: NotificationType? = nil
    @State private var selectedNotification: NotificationItem? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Title
                Text("Notificaciones")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.brandPrimary)
                    .padding(.top, 20)

                // Filter Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterTab(
                            title: "Resumen",
                            isSelected: selectedFilter == nil,
                            action: { selectedFilter = nil }
                        )

                        FilterTab(
                            title: "Mis reportes",
                            isSelected: selectedFilter == .misReportes,
                            action: { selectedFilter = .misReportes }
                        )

                        FilterTab(
                            title: "Comunidad",
                            isSelected: selectedFilter == .comunidad,
                            action: { selectedFilter = .comunidad }
                        )

                        FilterTab(
                            title: "Recomendados",
                            isSelected: selectedFilter == .favoritos,
                            action: { selectedFilter = .favoritos }
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)

                // Notifications List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if selectedFilter == nil {
                            // Show grouped notifications (Resumen)
                            let groupedNotifications = notificationData.getGroupedNotifications()
                            ForEach(Array(groupedNotifications.enumerated()), id: \.offset) { index, group in
                                NotificationGroupSection(
                                    title: group.0,
                                    notifications: group.1,
                                    onNotificationTap: { notification in
                                        selectedNotification = notification
                                    }
                                )
                            }
                        } else {
                            // Show filtered notifications
                            let filteredNotifications = notificationData.getFilteredNotifications(for: selectedFilter)
                            ForEach(filteredNotifications) { notification in
                                NotificationRowComponent(notification: notification) {
                                    selectedNotification = notification
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(.bottom, 20) // Space for TabView navbar
                }
            }
            .background(Color.gray.opacity(0.05))
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedNotification) { notification in
            NotificationDetailScreen(notification: notification)
        }
    }
}


struct NotificationGroupSection: View {
    let title: String
    let notifications: [NotificationItem]
    let onNotificationTap: (NotificationItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.brandPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)

            ForEach(notifications) { notification in
                NotificationRowComponent(notification: notification) {
                    onNotificationTap(notification)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    NotificationsScreen()
}
