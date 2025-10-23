//
//  DashboardScreen.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 25/09/25.
//

import SwiftUI
import Charts

struct DashboardScreen: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    // MARK: - Funciones
    func colorLevel(index: Int, total: Int) -> Double {
        let minVal = 0.7
        let maxVal = 1.0
        let normalized = Double(index) / Double(max(1, total - 1))
        return minVal + (maxVal - minVal) * (1 - pow(normalized, 0.5))
    }
    
    // MARK: - Subcomponentes
    struct HeaderView: View {
        var body: some View {
            Text("Estadísticas")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.brandPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
        }
    }

    struct ProgressCardsView: View {
        let totalReports: Int
        let protectedPeople: Int

        var body: some View {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ProgressStatCard(title: "Total de reportes", value: String(totalReports), hasBackground: true)
                ProgressStatCard(title: "Personas Protegidas", value: String(protectedPeople), hasBackground: true)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }

    struct TopReportsView: View {
        let topReportsMonth: [(Int, String, Int)]

        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Top reportes del mes")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.brandAccent)
                        .padding(.bottom, 8)

                    let maxValue = topReportsMonth.map { $0.2 }.max() ?? 1
                    let maxCountWithMargin = Int(Double(maxValue) * 1.1)

                    ForEach(topReportsMonth, id: \.0) { reportId, title, count in
                        BarView(
                            reportId: reportId,
                            titleReport: title,
                            count: count,
                            maxCount: maxCountWithMargin,
                            text: "\(count) likes"
                        )
                    }
                }
                .padding()
            }
        }
    }

    

    struct AchievementsView: View {
        let approvedReports: Int
        let protectedPeople: Int
        let users: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Logros Comunitarios")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brandAccent)
                
                AchievementRow(icon: "star.fill", title: "Reporteros Activos", subtitle: "\(approvedReports) reportes procesados")
                AchievementRow(icon: "shield.lefthalf.fill", title: "Protección", subtitle: "\(protectedPeople) personas protegidas")
                AchievementRow(icon: "flame.fill", title: "Comunidad en Crecimiento", subtitle: "\(users) usuarios activos")
            }
            .padding()
            .background(Color.gray.opacity(0.06))
            .cornerRadius(12)
        }
    }

    struct ReportStatusChartView: View {
        let approvedReports: Int
        let rejectedReports: Int
        let pendingReports: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Estado de reportes")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brandAccent)
                
                HStack {
                    Chart {
                        let estadoReports = [
                            ("Aprobados", approvedReports, Color.brandAccepted),
                            ("Rechazados", rejectedReports, Color.brandAccent),
                            ("Pendientes", pendingReports, Color.brandSecondary)
                        ]

                        ForEach(estadoReports, id: \.0) { item in
                            SectorMark(
                                angle: .value("Cantidad", item.1),
                                innerRadius: .ratio(0.0),
                                angularInset: 1.5
                            )
                            .foregroundStyle(item.2)
                        }
                    }
                    .frame(width: 200, height: 200)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Circle()
                                .fill(Color.brandAccepted)
                                .frame(width: 12, height: 12)
                            Text("Aprobados")
                                .font(.caption)
                        }

                        HStack {
                            Circle()
                                .fill(Color.brandAccent)
                                .frame(width: 12, height: 12)
                            Text("Rechazados")
                                .font(.caption)
                        }

                        HStack {
                            Circle()
                                .fill(Color.brandSecondary)
                                .frame(width: 12, height: 12)
                            Text("Pendientes")
                                .font(.caption)
                        }
                    }
                    .padding(.leading, 12)
                }
            }
            .padding(.horizontal)
        }
    }

    struct ReportsByCategoryView: View {
        let topCategoriesReports: [(String, Int)]
        let colorLevel: (Int, Int) -> Double

        var body: some View {
            VStack(alignment: .leading) {
                Text("Reportes por categoría")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brandAccent)

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(topCategoriesReports.enumerated()), id: \.1.0) { index, item in
                            HStack {
                                Circle()
                                    .fill(Color.brandSecondary.opacity(colorLevel(index, topCategoriesReports.count)))
                                    .frame(width: 12, height: 12)
                                Text(item.0)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.trailing, 12)

                    Chart {
                        ForEach(Array(topCategoriesReports.enumerated()), id: \.1.0) { index, item in
                            SectorMark(
                                angle: .value("Cantidad", item.1),
                                innerRadius: .ratio(0.5),
                                angularInset: 1.5
                            )
                            .foregroundStyle(Color.brandSecondary.opacity(colorLevel(index, topCategoriesReports.count)))
                        }
                    }
                    .frame(width: 200, height: 200)
                }
            }
            .padding(.horizontal)
        }
    }

    struct AlertRow: View {
        let alert: (Int, String)
        let isLast: Bool

        @State private var reportDTO: ReportDTO? = nil
        @State private var isLoading = false
        private let httpClient = HTTPClient()

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Button {
                    Task { await loadReport() }
                } label: {
                    HStack {
                        Text(alert.1)
                            .foregroundColor(.brandPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
                .disabled(isLoading)

                if !isLast {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                }
            }
            .navigationDestination(item: $reportDTO) { report in
                Report(report: report)
            }
        }

        private func loadReport() async {
            guard !isLoading else { return }
            isLoading = true

            do {
                let reports = try await httpClient.getIdReport(id: alert.0)
                if let first = reports.first {
                    await MainActor.run { reportDTO = first }
                }
            } catch {
                print("Error cargando reporte con id \(alert.0): \(error)")
            }

            isLoading = false
        }
    }


    struct RecentAlertsView: View {
        let recentAlerts: [(Int, String)]

        var body: some View {
            NavigationStack {
                VStack(alignment: .leading) {
                    Text("Alertas recientes")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.brandAccent)

                    ForEach(Array(recentAlerts.enumerated()), id: \.element.0) { index, alert in
                        AlertRow(alert: alert, isLast: index == recentAlerts.count - 1)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.06))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
    }


    struct ReportsPerMonthView: View {
        let reportsPerMonth: [(String, Int)]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Reportes por Mes")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brandAccent)
                    .padding(.horizontal)

                Chart {
                    ForEach(reportsPerMonth, id: \.0) { month, value in
                        LineMark(
                            x: .value("Mes", month),
                            y: .value("Cantidad", value)
                        )
                        .foregroundStyle(.gray)
                        .symbol(Circle())
                        .symbolSize(40)
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
            }
        }
    }

    struct TopUsersView: View {
        let topUsers: [(String, Int)]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Usuarios más activos")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brandAccent)
                    .padding(.horizontal)

                ForEach(Array(topUsers.enumerated()), id: \.element.0) { index, element in
                    let (user, reports) = element

                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(user)
                                .foregroundColor(.brandPrimary)
                            Spacer()
                            Text("\(reports) reportes")
                                .foregroundColor(.brandSecondary)
                        }
                        .padding(.vertical, 4)

                        if index < topUsers.count - 1 {
                            Divider()
                                .background(Color.brandAccent)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .background(Color.gray.opacity(0.06))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    struct FooterView: View {
        var body: some View {
            VStack(spacing: 20) {
                // Red por la Ciberseguridad Logo
                Image("app-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)

                Link("Ir a Red por la Ciberseguridad", destination: URL(string: "https://redporlaciberseguridad.org/")!)
                    .foregroundColor(.brandSecondary)
                    .underline()
            }
            .padding(.vertical)
        }
    }


    struct BarView: View {
        let reportId: Int
        let titleReport: String
        let count: Int
        let maxCount: Int
        let text: String

        @State private var reportDTO: ReportDTO? = nil
        @State private var isLoading = false
        private let httpClient = HTTPClient()

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Button {
                    Task { await loadReport() }
                } label: {
                    HStack {
                        Text(titleReport)
                            .font(.subheadline)
                            .foregroundColor(.brandPrimary.opacity(0.8))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .disabled(isLoading)

                HStack {
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [Color.brandAccent, Color.brandPrimary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: CGFloat(count) / CGFloat(max(maxCount, 1)) * geo.size.width,
                                height: 14
                            )
                    }
                    .frame(height: 14)

                    Text(text)
                        .font(.caption)
                        .foregroundColor(.brandPrimary.opacity(0.6))
                        .frame(width: 60, alignment: .trailing)
                }
                .frame(height: 14)
            }
            .padding(.vertical, 4)
            .navigationDestination(item: $reportDTO) { report in
                Report(report: report)
            }
        }

        private func loadReport() async {
            guard !isLoading else { return }
            isLoading = true

            do {
                let reports = try await httpClient.getIdReport(id: reportId)
                if let first = reports.first {
                    await MainActor.run { reportDTO = first }
                }
            } catch {
                print("Error cargando reporte \(reportId): \(error)")
            }

            isLoading = false
        }
    }



struct AchievementRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.brandAccent)
                .font(.system(size: 28))
                .frame(width: 36, height: 36)


            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.brandPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color.brandSecondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let hasBackground: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color.brandSecondary)

            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(Color.brandPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            hasBackground ?
            LinearGradient(
                colors: [Color.gray.opacity(0.08), Color.gray.opacity(0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ) : LinearGradient(
                colors: [Color.clear, Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .overlay(
            hasBackground ? nil :
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

    
    
    // MARK: - Body
    
    var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        HeaderView()

                        if viewModel.isLoading {
                            ProgressView("Cargando dashboard...")
                                .padding(.top, 40)
                        } else if let dashboard = viewModel.dashboard {
                            
                            ProgressCardsView(
                                totalReports: dashboard.stats.totalReports,
                                    protectedPeople: dashboard.stats.protectedPeople
                            )
                            
                            TopReportsView(
                                topReportsMonth: viewModel.topReportsMonth.map {
                                    ($0.id,$0.title, $0.upvotes)
                                }
                            )
                            Spacer()
                            AchievementsView(
                                approvedReports: dashboard.stats.approvedReports,
                                protectedPeople: dashboard.stats.protectedPeople,
                                users: dashboard.stats.totalUsers
                            )
                            Spacer()

                            ReportStatusChartView(
                                approvedReports: dashboard.stats.approvedReports,
                                rejectedReports: dashboard.stats.rejectedReports,
                                pendingReports: dashboard.stats.pendingReports
                            )
                            Spacer()

                            ReportsByCategoryView(
                                topCategoriesReports: dashboard.topCategoriesReports.map {
                                    ($0.name, $0.totalReports)
                                },
                                colorLevel: colorLevel
                            )

                            Spacer()
                            RecentAlertsView(
                                recentAlerts: viewModel.recentAlerts.map { ($0.id, $0.title) }
                            )
                            Spacer()
                            
                            ReportsPerMonthView(
                                reportsPerMonth: dashboard.reportsPerMonth.map {
                                    ($0.month.monthAbbreviation(), $0.totalReports)
                                }
                            )

                            Spacer()


                            TopUsersView(
                                topUsers: dashboard.topUsers.map {
                                    ($0.name, $0.totalReports)
                                }
                            )

                            
                            FooterView()
                            
                        } else if let error = viewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .padding(.vertical)
                }
                .task {
                    await viewModel.fetchDashboard()
                }
            }
        }
}

#Preview {
    DashboardScreen()
}
