//
//  TemplateReto451App.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 26/08/25.
//

import SwiftUI

@main
struct TemplateReto451App: App {

    init() {
        // ✅ SECURITY FIX: Migrate tokens from insecure UserDefaults to secure Keychain
        // This ensures tokens are encrypted and properly protected
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "kTokensMigratedToKeychain") {
            Logger.log("Performing security migration: UserDefaults → Keychain", level: .warning)
            SecureTokenStorage.shared.migrateFromUserDefaults()
        }
    }

    var body: some Scene {
        WindowGroup {
            WelcomeScreen()
        }
    }
}
