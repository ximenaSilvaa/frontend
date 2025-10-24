//
//  TermsAndConditionsScreen.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 17/09/25.
//

import SwiftUI

struct TermsAndConditionsScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var text: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    private let service: HTTPClientProtocol = HTTPClient()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                if isLoading {
                    ProgressView("Cargando...")
                } else if let error = errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 30))
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Reintentar") {
                            Task { await fetchTerms() }
                        }
                        .padding(.top, 8)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Text(title.isEmpty ? "Red por la Ciberseguridad - Términos y Condiciones" : title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .opacity(0)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)

                            VStack(alignment: .leading, spacing: 16) {
                                Text(title)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                Text(text)
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 20)

                            Spacer(minLength: 40)
                        }
                    }
                }
            }
        }
        .task {
            await fetchTerms()
        }
        .navigationBarHidden(true)
    }

    private func fetchTerms() async {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: URLEndpoints.termsAndConditions) else {
            errorMessage = "URL inválid."
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let terms = try JSONDecoder().decode(TermsAndConditionsDTO.self, from: data)
            title = terms.title
            text = terms.text
        } catch {
            print("Error: \(error)")
            errorMessage = "Error loading terms and conditions."
        }
        isLoading = false
    }
}


#Preview {
    TermsAndConditionsScreen()
}
