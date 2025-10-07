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
                            .padding()
                    } else if let error = errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
                            Text("Error al cargar reportes")
                                .font(.headline)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            Button("Reintentar") {
                                Task {
                                    await loadData()
                                }
                            }
                            .padding()
                            .background(Color.brandAccent)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding()
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
