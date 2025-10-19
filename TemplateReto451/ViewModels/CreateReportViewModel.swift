//
//  CreateReportViewModel.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 18/10/25.
//

import Foundation

@MainActor
final class CreateReportViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var reportURL: String = ""
    @Published var imageData: Data? = nil
    @Published var selectedCategoryId: Int? = nil
    @Published var isAnonymousPreferred: Bool = false
    
    @Published var categories: [CategoryDTO] = []
    @Published var isLoading: Bool = false
    @Published var alertMessage: String?
    @Published var showAlert: Bool = false
    
    private let httpClient = HTTPClient()
    private var currentUserId: Int? = nil
    
    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            async let fetchedCategories = httpClient.getCategories()
            async let settings = httpClient.getUserSettingsInfo()
            async let user = httpClient.getUserProfile()
            
            let (categoriesResult, settingsResult, userResult) = try await (fetchedCategories, settings, user)
            
            categories = categoriesResult
            isAnonymousPreferred = settingsResult.anonymousReportsBool
            currentUserId = userResult.id
            
        } catch {
            handleError(error)
        }
    }
    
    func createReport() async {
        guard validateInputs() else { return }
        guard currentUserId != nil else {
            showAlert(message: "No se pudo identificar al usuario. Intenta iniciar sesión nuevamente.")
            return
        }

        let safeReportURL = reportURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "https://no-url-provided.com"
            : reportURL.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let safeImagePath = imageData != nil
            ? "profile-pictures/dummy.jpg"
            : "profile-pictures/default.jpg"

        let dto = CreateReportRequestDTO(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            status_id: 1,
            category: selectedCategoryId != nil ? [selectedCategoryId!] : [],
            report_url: safeReportURL,
            image: safeImagePath,
            is_anonymous: isAnonymousPreferred ? 1 : 0
        )

        isLoading = true
        defer { isLoading = false }

        do {
            try await httpClient.createReport(dto)
            showAlert(message: "Reporte creado exitosamente")
            resetForm()
        } catch {
            handleError(error)
        }
    }

    
    private func validateInputs() -> Bool {
        if title.isEmpty {
            showAlert(message: "El título no puede estar vacío.")
            return false
        }
        if description.isEmpty {
            showAlert(message: "La descripción no puede estar vacía.")
            return false
        }
        if selectedCategoryId == nil {
            showAlert(message: "Debes seleccionar una categoría.")
            return false
        }
        if !reportURL.isEmpty {
            let pattern = #"^(https?:\/\/)([\w\-]+(\.[\w\-]+)+)(:\d+)?(\/\S*)?$"#
                   if reportURL.range(of: pattern, options: .regularExpression) == nil {
                       showAlert(message: "La URL no es válida. Ejemplo: https://pagina.com")
                       return false
                   }
        }
        return true
    }
    
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func resetForm() {
        title = ""
        description = ""
        reportURL = ""
        imageData = nil
        selectedCategoryId = nil
        isAnonymousPreferred = false
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            showAlert(message: networkError.localizedDescription)
        } else {
            showAlert(message: "Error inesperado: \(error.localizedDescription)")
        }
    }
}
