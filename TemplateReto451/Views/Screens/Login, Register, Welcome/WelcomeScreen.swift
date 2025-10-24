//
//  WelcomeScreen.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 17/09/25.
//

import SwiftUI

struct WelcomeScreen: View {
    @Environment(\.authenticationViewModel) var authenticationViewModel
    @State private var isActive = false
    @State private var isValidatingToken = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [
                    Color.brandPrimary,
                    Color.brandPrimary.opacity(0.9),
                    Color.brandAccent.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 50) {
                Spacer()

                // Main Logo - Falcon
                VStack(spacing: 20) {
                    Image("falcon-logo-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 220)
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)

                    // App Name/Tagline
                    Text("FalconAlert")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }

                Spacer()

                // Loading Indicator
                if isValidatingToken {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .padding(.bottom, 40)
                }
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            Task {
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
