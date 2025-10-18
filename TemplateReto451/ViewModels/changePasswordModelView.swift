//
//  changePasswordModelView.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 16/10/25.
//

import Foundation

@MainActor
class ChangePasswordViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""

    @Published var validationErrors: [String] = []
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    @Published var isLoading = false
    
    private let service: HTTPClientProtocol
    init(service: HTTPClientProtocol = HTTPClient()) {
        self.service = service
    }

    func validate() -> Bool {
        var errors = [String]()

        if newPassword.count < 8 {
            errors.append("La contraseña nueva debe tener al menos 8 caracteres")
        }
        if newPassword != confirmPassword {
            errors.append("Las contraseñas nuevas no coinciden")
        }

        validationErrors = errors
        return errors.isEmpty
    }

    func changePassword() async {
        errorMessage = nil
        successMessage = nil
        
        // Primero validar localmente (sin validar oldPassword aquí)
        guard validate() else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let dto = PasswordChangeDTO(oldPassword: oldPassword, newPassword: newPassword)
            let response = try await service.passwordReset(dto)
            
            // Asumimos que si no hay error, es éxito
            successMessage = "Contraseña cambiada correctamente"
            validationErrors = []
            
        } catch let error as NetworkError {
            // Manejo específico para contraseña actual incorrecta
            switch error {
            case .serverError(let statusCode, let message):
                if let message = message, message.contains("contraseña actual") || message.contains("old password") {
                    errorMessage = "La contraseña actual es incorrecta"
                } else {
                    // No mostramos otros errores del servidor
                    errorMessage = nil
                }
            default:
                errorMessage = nil
            }
            
        } catch {
            // Otros errores genéricos
            errorMessage = nil
        }
    }
}
