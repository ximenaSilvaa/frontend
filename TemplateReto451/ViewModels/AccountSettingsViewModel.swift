//
//  AccountSettingsViewModel.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 15/10/25.
//

import Foundation

@MainActor
class AccountSettingsViewModel: ObservableObject {
    @Published var isAnonymousPreferred: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: HTTPClientProtocol

    init(service: HTTPClientProtocol = HTTPClient()) {
        self.service = service
        Task { await loadSettings() }
    }

    func loadSettings() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let dto = try await service.getUserSettingsInfo()
            isAnonymousPreferred = dto.anonymousReportsBool
            errorMessage = nil
        } catch {
            errorMessage = "Error load settings: \(error.localizedDescription)"
        }
    }

    func saveSettings() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let current = try await service.getUserSettingsInfo()
            let dto = SettingsRequestDTO(
                isReactionsEnabled: current.reactionsEnabledBool,
                isReviewEnabled: current.reviewEnabledBool,
                isReportsEnabled: current.reportsEnabledBool,
                isAnonymousPreferred: isAnonymousPreferred
            )

            try await service.updateUserSettingsInfo(dto)
            errorMessage = nil
        } catch {
            errorMessage = "Error save settings: \(error.localizedDescription)"
        }
    }
}

