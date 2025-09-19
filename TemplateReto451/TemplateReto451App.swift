//
//  TemplateReto451App.swift
//  TemplateReto451
//
//  Created by José Molina on 26/08/25.
//

import SwiftUI

@main
struct TemplateReto451App: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ComponentNavbar()
            } else if !hasSeenWelcome {
                WelcomeScreen()
                    .onAppear {
                        // Mark that user has seen welcome screen after showing it
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hasSeenWelcome = true
                        }
                    }
            } else {
                NavigationStack {
                    LoginScreen()
                }
            }
        }
    }
}
