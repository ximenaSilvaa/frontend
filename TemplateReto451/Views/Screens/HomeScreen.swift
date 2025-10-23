//
//  HomeScreen.swift
//  TemplateReto451
//
//  Created by José Molina on 09/09/25.
//
import SwiftUI

struct HomeScreen: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: Int? = nil
    @State private var reports: [ReportDTO] = []
    @State private var allReports: [ReportDTO] = []
    @State private var categories: [CategoryDTO] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    private let httpClient = HTTPClient()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.05)
                .ignoresSafeArea()

            VStack {

                Spacer().frame(height: 15)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.brandSecondary)
                    .font(.system(size: 16, weight: .medium))
                TextField("Buscar reportes...", text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.brandPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
            )
            .padding(.horizontal, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories) { category in
                                FilterTab(
                                    title: category.name,
                                    isSelected: selectedCategory == category.id,
                                    action: {
                                        selectedCategory = selectedCategory == category.id ? nil : category.id
                                        filterReports()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 60)
                    

                    if isLoading {
                        ProgressView("Cargando reportes...")
                            .foregroundColor(.brandPrimary)
                            .padding()
                    } else if let error = errorMessage {
                        Spacer()

                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.brandAccent)
                            Text("Error al cargar reportes")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.brandPrimary)
                            Text(error)
                                .font(.system(size: 14))
                                .foregroundColor(.brandSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)

                            Button("Reintentar") {
                                Task {
                                    await loadData()
                                }
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [Color.brandAccent, Color.brandPrimary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.brandAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)

                        Spacer()
                    } else if reports.isEmpty {
                        // Empty state when filtering by category
                        Spacer()

                        VStack(spacing: 16) {
                            Image(systemName: selectedCategory != nil ? "tray.fill" : "doc.text.magnifyingglass")
                                .font(.system(size: 70))
                                .foregroundColor(Color.brandSecondary.opacity(0.6))

                            Text(selectedCategory != nil ? "No hay reportes en esta categoría" : "No hay reportes disponibles")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.brandPrimary)

                            Text(selectedCategory != nil ? "Intenta seleccionar otra categoría" : "Sé el primero en reportar")
                                .font(.system(size: 14))
                                .foregroundColor(.brandSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)

                        Spacer()
                    } else {
                        VStack(spacing: 20) {
                            ForEach(reports) { report in
                                ComponentReport(
                                    report: report,
                                    size: .normal
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            }
        }
        .onAppear {
            Task {
                await loadData()
            }
        }
        .onChange(of: searchText) { _ in
            filterReports()
        }
    }

    private func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let reportsTask = httpClient.getReports(status: "2")
            async let categoriesTask = httpClient.getCategories()

            let (fetchedReports, fetchedCategories) = try await (reportsTask, categoriesTask)

            allReports = fetchedReports
            categories = fetchedCategories
            reports = fetchedReports
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("Error loading data: \(error)")
        }
    }

    private func filterReports() {
        var filtered = allReports

        // Filter by category
        if let categoryId = selectedCategory {
            filtered = filtered.filter { report in
                report.categories.contains(categoryId)
            }
        }

        // Filter by search text
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            filtered = filtered.filter { report in
                // Search in user_name
                if report.user_name.lowercased().contains(searchLower) {
                    return true
                }
                // Search in title
                if report.title.lowercased().contains(searchLower) {
                    return true
                }
                // Search in description
                if report.description.lowercased().contains(searchLower) {
                    return true
                }
                // Search in report_url
                if report.report_url.lowercased().contains(searchLower) {
                    return true
                }
                // Search in category names
                let categoryNames = categories
                    .filter { report.categories.contains($0.id) }
                    .map { $0.name.lowercased() }

                if categoryNames.contains(where: { $0.contains(searchLower) }) {
                    return true
                }

                return false
            }
        }

        reports = filtered
    }
}
