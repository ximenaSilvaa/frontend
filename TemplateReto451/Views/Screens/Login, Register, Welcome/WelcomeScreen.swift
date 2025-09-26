//
//  WelcomeScreen.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
//

import SwiftUI

struct WelcomeScreen: View {
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
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
        }
        .navigationBarHidden(true)
        .onAppear {
            // Auto-navigate to login after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                navigateToLogin = true
            }
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginScreen()
        }
    }
}

#Preview {
    WelcomeScreen()
}