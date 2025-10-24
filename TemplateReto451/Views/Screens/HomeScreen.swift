//
//  HomeScreen.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 09/09/25.
//
import SwiftUI

struct HomeScreen: View {
    @State private var searchText: String = ""
    @State private var selectedCategories: Set<Int> = []
    @State private var reports: [ReportDTO] = []
    @State private var allReports: [ReportDTO] = []
    @State private var categories: [CategoryDTO] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showCategoryModal: Bool = false

    private let httpClient = HTTPClient()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.05)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer().frame(height: 20)

            // Search Bar with Category Button
            HStack(spacing: 12) {
                // Search Bar
                HStack(spacing: 14) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.brandAccent)
                        .font(.system(size: 18, weight: .semibold))

                    TextField("Buscar reportes...", text: $searchText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.brandPrimary)

                    if !searchText.isEmpty {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                searchText = ""
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.brandSecondary.opacity(0.6))
                                .font(.system(size: 18, weight: .medium))
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color.white, Color.white.opacity(0.98)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(18)
                .shadow(color: Color.brandAccent.opacity(0.08), radius: 12, x: 0, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            LinearGradient(
                                colors: [Color.brandAccent.opacity(0.3), Color.brandPrimary.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )

                // Category Filter Button
                Button(action: {
                    showCategoryModal = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.brandAccent)
                            .padding(12)
                            .background(
                                LinearGradient(
                                    colors: [Color.white, Color.white.opacity(0.98)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(18)
                            .shadow(color: Color.brandAccent.opacity(0.08), radius: 12, x: 0, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.brandAccent.opacity(0.3), Color.brandPrimary.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )

                        // Badge showing selected count
                        if !selectedCategories.isEmpty {
                            Text("\(selectedCategories.count)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(5)
                                .background(
                                    Circle()
                                        .fill(Color.brandAccent)
                                        .shadow(color: Color.brandAccent.opacity(0.4), radius: 4, x: 0, y: 2)
                                )
                                .offset(x: 4, y: -4)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 20)

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    

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

                        VStack(spacing: 20) {
                            Image(systemName: !selectedCategories.isEmpty ? "tray.fill" : "doc.text.magnifyingglass")
                                .font(.system(size: 75))
                                .foregroundColor(Color.brandAccent.opacity(0.7))
                                .shadow(color: Color.brandAccent.opacity(0.2), radius: 8, x: 0, y: 4)

                            Text(!selectedCategories.isEmpty ? "No hay reportes en estas categorías" : "No hay reportes disponibles")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.brandPrimary)

                            Text(!selectedCategories.isEmpty ? "Intenta seleccionar otras categorías" : "Sé el primero en reportar")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.brandSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 40)
                        .transition(.scale.combined(with: .opacity))

                        Spacer()
                    } else {
                        LazyVStack(spacing: 24) {
                            ForEach(reports) { report in
                                ComponentReport(
                                    report: report,
                                    size: .normal
                                )
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.9).combined(with: .opacity),
                                    removal: .scale(scale: 0.9).combined(with: .opacity)
                                ))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
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
        .onChange(of: selectedCategories) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                filterReports()
            }
        }
        .sheet(isPresented: $showCategoryModal) {
            CategoryDropdown(
                categories: categories,
                selectedCategoryIds: $selectedCategories,
                isPresented: $showCategoryModal
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
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

        // Filter by categories (multiple selection)
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { report in
                // Check if report contains ANY of the selected categories
                !selectedCategories.isDisjoint(with: Set(report.categories))
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
