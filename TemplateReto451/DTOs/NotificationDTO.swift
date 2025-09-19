//
//  NotificationDTO.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import Foundation
import SwiftUI

enum NotificationType {
    case comunidad
    case misReportes
    case favoritos
}

enum NotificationStatus {
    case pending
    case accepted
    case rejected
    case created
    case liked
    case trend
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let type: NotificationType
    let status: NotificationStatus
    let title: String
    let description: String?
    let timeAgo: String
    let iconName: String
    let iconColor: Color
    let date: Date
}

class NotificationData: ObservableObject {
    @Published var notifications: [NotificationItem] = []

    init() {
        loadMockData()
    }

    private func loadMockData() {
        let calendar = Calendar.current
        let now = Date()

        notifications = [
            // Hoy - Resumen
            NotificationItem(
                type: .misReportes,
                status: .pending,
                title: "9 reportes nuevos en automóviles",
                description: nil,
                timeAgo: "Hoy",
                iconName: "clock",
                iconColor: .orange,
                date: now
            ),

            NotificationItem(
                type: .comunidad,
                status: .liked,
                title: "150 me gusta en tu reporte \"Estafa venta ...\"",
                description: nil,
                timeAgo: "Hoy",
                iconName: "mappin",
                iconColor: .blue,
                date: calendar.date(byAdding: .hour, value: -2, to: now) ?? now
            ),

            // Últimos 7 días
            NotificationItem(
                type: .misReportes,
                status: .accepted,
                title: "Reporte \"Phishing Banco\" aceptado.",
                description: nil,
                timeAgo: "1 d",
                iconName: "checkmark.square",
                iconColor: .blue,
                date: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),

            NotificationItem(
                type: .misReportes,
                status: .rejected,
                title: "Reporte \"Virus link\" rechazado...",
                description: "el link no es válido.",
                timeAgo: "2 d",
                iconName: "minus.square",
                iconColor: .red,
                date: calendar.date(byAdding: .day, value: -2, to: now) ?? now
            ),

            // Últimos 30 días
            NotificationItem(
                type: .comunidad,
                status: .created,
                title: "Reporte \"Virus link\" creado...",
                description: nil,
                timeAgo: "1 s",
                iconName: "person.crop.circle",
                iconColor: .blue,
                date: calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            ),

            NotificationItem(
                type: .comunidad,
                status: .created,
                title: "Reporte \"Phishing Banco\" creado...",
                description: nil,
                timeAgo: "2 s",
                iconName: "person.crop.circle",
                iconColor: .blue,
                date: calendar.date(byAdding: .weekOfYear, value: -2, to: now) ?? now
            ),

            // Favoritos
            NotificationItem(
                type: .favoritos,
                status: .trend,
                title: "Nueva tendencia de fraude detectada en tu área",
                description: "Phishing bancario incrementó 40% esta semana",
                timeAgo: "3 d",
                iconName: "chart.line.uptrend.xyaxis",
                iconColor: .purple,
                date: calendar.date(byAdding: .day, value: -3, to: now) ?? now
            ),

            NotificationItem(
                type: .favoritos,
                status: .trend,
                title: "Alerta de seguridad en tu sector",
                description: "Nuevas técnicas de ingeniería social reportadas",
                timeAgo: "5 d",
                iconName: "exclamationmark.triangle",
                iconColor: .orange,
                date: calendar.date(byAdding: .day, value: -5, to: now) ?? now
            )
        ]
    }

    func getFilteredNotifications(for type: NotificationType?) -> [NotificationItem] {
        guard let type = type else {
            return notifications
        }
        return notifications.filter { $0.type == type }
    }

    func getGroupedNotifications() -> [(String, [NotificationItem])] {
        let calendar = Calendar.current
        let now = Date()

        let today = notifications.filter { calendar.isDateInToday($0.date) }
        let last7Days = notifications.filter {
            let daysDiff = calendar.dateComponents([.day], from: $0.date, to: now).day ?? 0
            return daysDiff > 0 && daysDiff <= 7
        }
        let last30Days = notifications.filter {
            let daysDiff = calendar.dateComponents([.day], from: $0.date, to: now).day ?? 0
            return daysDiff > 7 && daysDiff <= 30
        }

        var sections: [(String, [NotificationItem])] = []

        if !today.isEmpty {
            sections.append(("Hoy", today))
        }
        if !last7Days.isEmpty {
            sections.append(("Últimos 7 días", last7Days))
        }
        if !last30Days.isEmpty {
            sections.append(("Últimos 30 días", last30Days))
        }

        return sections
    }
}