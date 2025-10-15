//
//  DashboardViewModel.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 11/10/25.
//

import Foundation
@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var dashboard: DashboardResponse?
    @Published var recentAlerts: [RecentAlert] = []
    @Published var topReportsMonth: [TopReport] = []
    @Published var selectedReports: [ReportDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: HTTPClientProtocol
    init(service: HTTPClientProtocol = HTTPClient()) {
        self.service = service
    }

    func fetchDashboard() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.getDashboardInfo()
            dashboard = response
            recentAlerts = response.recentAlerts
            topReportsMonth = response.topReportsMonth
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching dashboard: \(error)")
        }

        isLoading = false
    }

    func fetchReportsFor(id: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            let reports = try await service.getIdReport(id: id)
            selectedReports = reports
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching reports for id \(id): \(error)")
        }

        isLoading = false
    }

    func clearSelectedReports() {
        selectedReports = []
    }
}
