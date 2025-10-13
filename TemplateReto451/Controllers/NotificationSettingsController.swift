//
//  NotificationSettingsController.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//

import Foundation

@MainActor
class NotificationSettingsController: ObservableObject {
    @Published var isActivated: Bool = true
    @Published var isReactionsEnabled: Bool = true
    @Published var isReviewEnabled: Bool = true
    @Published var isReportsEnabled: Bool = true
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let httpClient = HTTPClient()

    init() {
        Task {
            await loadSettings()
        }
    }

    func loadSettings() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let dto = try await httpClient.getUserSettingsInfo()
            isReactionsEnabled = dto.reactionsEnabledBool
            isReviewEnabled = dto.reviewEnabledBool
            isReportsEnabled = dto.reportsEnabledBool
            isActivated = isReactionsEnabled && isReviewEnabled && isReportsEnabled
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveSettings() async {
        let dto = SettingsRequestDTO(
            isReactionsEnabled: isReactionsEnabled,
            isReviewEnabled: isReviewEnabled,
            isReportsEnabled: isReportsEnabled,
            isAnonymousPreferred: false
        )

        do {
            try await httpClient.updateUserSettingsInfo(dto)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func setActivated(_ value: Bool) {
        isActivated = value
        isReactionsEnabled = value
        isReviewEnabled = value
        isReportsEnabled = value
        Task {
            await saveSettings()
        }
    }

    func updateState() {
        isActivated = isReactionsEnabled && isReviewEnabled && isReportsEnabled
        Task {
            await saveSettings()
        }
    }
}

