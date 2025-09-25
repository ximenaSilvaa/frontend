//
//  NotificationSettingsController.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//
import Foundation

class NotificationSettingsController: ObservableObject {
    // Establecer de la bd
    @Published var isActivated: Bool = true
    @Published var isReactionsEnabled: Bool = true
    @Published var isReviewEnabled: Bool = true
    @Published var isReportsEnabled: Bool = true

    func setActivated(_ value: Bool) {
        isActivated = value
        if value {
            isReactionsEnabled = true
            isReviewEnabled = true
            isReportsEnabled = true
        } else {
            isReactionsEnabled = false
            isReviewEnabled = false
            isReportsEnabled = false
        }
    }
    
    func updateState() {
        let allOn = isReactionsEnabled && isReviewEnabled && isReportsEnabled
        isActivated = allOn
    }
}
