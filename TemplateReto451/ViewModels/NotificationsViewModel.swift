//
//  NotificationsViewModel.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 17/10/25.
//

import Foundation

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let service: HTTPClientProtocol
    init(service: HTTPClientProtocol = HTTPClient()) {
        self.service = service
    }
    
    func fetchNotifications() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result = try await service.getNotifications()
            notifications = result
        } catch {
            errorMessage = "Error loading notifications"
            print("Error fetching notifications:", error)
        }
    }
}
