//
//  NotificationSettingsController.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//
import Foundation

class NotificationSettingsController: ObservableObject {
    // Establecer de la bd
    @Published var isPaused: Bool = false
    @Published var isActivated: Bool = true
    @Published var isReactionsEnabled: Bool = true
    @Published var isReviewEnabled: Bool = true
    @Published var isReportsEnabled: Bool = true

    func setPaused(_ value: Bool) {
        isPaused = value
        if value {
            isReactionsEnabled = false
            isReviewEnabled = false
            isReportsEnabled = false
            isActivated = false
        }
    }

    func setActivated(_ value: Bool) {
        isActivated = value
        if value {
            isReactionsEnabled = true
            isReviewEnabled = true
            isReportsEnabled = true
            isPaused = false
        }
    }

    func updateStatesFromIndividualToggles() {
        let allOn = isReactionsEnabled && isReviewEnabled && isReportsEnabled
        let allOff = !isReactionsEnabled && !isReviewEnabled && !isReportsEnabled

        isActivated = allOn
        isPaused = allOff
    }
}
