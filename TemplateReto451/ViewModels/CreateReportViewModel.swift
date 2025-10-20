//
//  CreateReportViewModel.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 18/10/25.
//

import Foundation
import SwiftUI

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

        isLoading = true
        defer { isLoading = false }

        do {
            let safeReportURL = reportURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "https://no-url-provided.com"
                : reportURL.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var uploadedImagePath: String = "profile-pictures/default.jpg"
            if let imageData = imageData {
                uploadedImagePath = try await httpClient.uploadReportImage(imageData: imageData)
            }

            let dto = CreateReportRequestDTO(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                status_id: 1,
                category: [selectedCategoryId ?? 0],
                report_url: safeReportURL,
                image: uploadedImagePath,
                is_anonymous: isAnonymousPreferred ? 1 : 0
            )
            
            try await httpClient.createReport(dto)

            showAlert(message: "Reporte creado exitosamente")
            resetForm()

        } catch {
            handleError(error)
        }
    }
    
    private func validateInputs() -> Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(message: "El título no puede estar vacío.")
            return false
        }
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(message: "La descripción no puede estar vacía.")
            return false
        }
        if selectedCategoryId == nil {
            showAlert(message: "Debes seleccionar una categoría.")
            return false
        }
       
        if !reportURL.isEmpty {
            let pattern = #"^(https?:\/\/)([A-Za-z0-9]+(?:-[A-Za-z0-9]+)*\.)+[A-Za-z]{2,}(\/\S*)?$"#
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
        Logger.log("Error en CreateReportViewModel: \(error)", level: .error)
    }
    
    func processImageData(_ data: Data) {
            guard let uiImage = UIImage(data: data) else {
                print("Error al crear UIImage desde data")
                return
            }

            let resizedImage = resizeImage(image: uiImage, maxDimension: 1024)
            let compressedData = resizedImage.jpegData(compressionQuality: 0.7)

            if let compressedData = compressedData, compressedData.count < 1048576 {
                DispatchQueue.main.async {
                    self.imageData = compressedData
                }
            } else {
    
                let moreCompressedData = resizedImage.jpegData(compressionQuality: 0.5)
                DispatchQueue.main.async {
                    self.imageData = moreCompressedData
                }
            }
        }

        private func resizeImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
            let size = image.size
            let aspectRatio = size.width / size.height
            var newSize: CGSize

            if size.width > size.height {
                newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
            } else {
                newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
            }

            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
            return newImage
        }
}
