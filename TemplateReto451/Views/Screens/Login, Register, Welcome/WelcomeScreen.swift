//
//  WelcomeScreen.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import SwiftUI

struct WelcomeScreen: View {
    @Environment(\.authenticationViewModel) var authenticationViewModel
    @State private var isActive = false
    @State private var isValidatingToken = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Logo Section
                VStack(spacing: 20) {
                    // Official Logo Image
                    Image("app-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }

                Spacer()
            }
        }
        .onAppear {
            Task {
                // If user is supposed to be logged in, validate the token first
                if isLoggedIn {
                    isValidatingToken = true
                    do {
                        let isValid = try await authenticationViewModel.validateToken()
                        if !isValid {
                            // Token is invalid, reset login state
                            isLoggedIn = false
                        }
                    } catch {
                        // Token validation failed, reset login state
                        isLoggedIn = false
                    }
                    isValidatingToken = false
                }

                // Wait 3 seconds (or remaining time if validation took time)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            if isLoggedIn {
                ComponentNavbar()
            } else {
                NavigationStack {
                    LoginScreen()
                }
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
