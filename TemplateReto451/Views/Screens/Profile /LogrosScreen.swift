//
//  LogrosScreen.swift
//  TemplateReto451
//
//  Created by User on 18/09/25.
//

import SwiftUI

struct LogrosScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPeriod: TimePeriod = .year
    @State private var currentSection: ScreenSection = .splitView
    @State private var userReportCount: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var userPostInfo: UserPostInfoDTO?
    @State private var userReports: [ReportDTO] = []
    @State private var isLoading = false

    private let httpClient = HTTPClient()

    enum ScreenSection {
        case splitView, fullProgress
    }

    enum TimePeriod: String, CaseIterable {
        case month = "Mes"
        case year = "Año"
        case all = "Todo"
    }

    let achievements = [
        Achievement(id: 1, reportCount: 3, level: .bronze, title: "Primer Guardián", description: "Hiciste tus primeros 3 reportes", symbol: "shield.lefthalf.filled"),
        Achievement(id: 2, reportCount: 10, level: .silver, title: "Protector Vigilante", description: "Enviaste 10 reportes de fraude", symbol: "shield.fill"),
        Achievement(id: 3, reportCount: 15, level: .gold, title: "Escudo Comunitario", description: "Alcanzaste 15 reportes de seguridad", symbol: "shield.checkered"),
        Achievement(id: 4, reportCount: 20, level: .platinum, title: "Cazador de Fraudes", description: "Detectaste 20 actividades fraudulentas", symbol: "shield.slash.fill"),
        Achievement(id: 5, reportCount: 25, level: .diamond, title: "Maestro de Seguridad", description: "Estado élite con 25+ reportes", symbol: "crown.fill")
    ]

    var body: some View {
        ZStack {
            // Split View (Default) or Full Progress
            if currentSection == .splitView {
                splitView
                    .transition(.asymmetric(
                        insertion: .move(edge: .top),
                        removal: .move(edge: .bottom)
                    ))
            } else {
                fullProgressView
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .top)
                    ))
            }

            // El chevron.left siempre presente
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color.brandPrimary)
                    }
                    .padding(.leading)

                    Spacer()
                }
                .padding(.top, 10)

                Spacer()
            }
            .zIndex(10)
        }
        .navigationBarHidden(true)
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if value.translation.height < -100 && currentSection == .splitView {
                            currentSection = .fullProgress
                        } else if value.translation.height > 100 && currentSection == .fullProgress {
                            currentSection = .splitView
                        }
                    }
                }
        )
        .onAppear {
            Task {
                await fetchUserPostInfo()
            }
        }
        .refreshable {
            await fetchUserPostInfo()
        }
    }

    private var splitView: some View {
        VStack(spacing: 0) {
            // Top Half - Logros Section
            VStack(spacing: 20) {
                HStack {
                    Text("Logros")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color.brandPrimary)
                    Text("2025")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color.brandAccent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 50)

                // Achievement Stats - Cards Style
                HStack(spacing: 12) {
                    StatCard(
                        value: "\(achievements.filter { $0.isUnlocked(userReportCount: userReportCount) }.count)",
                        label: "Desbloqueados",
                        icon: "trophy.fill"
                    )

                    StatCard(
                        value: "\(userReportCount)",
                        label: "Reportes",
                        icon: "flag.fill"
                    )

                    StatCard(
                        value: getUserRank(),
                        label: "Rango",
                        icon: "star.fill"
                    )
                }
                .padding(.horizontal, 20)

                // Horizontal Scrolling Awards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(achievements, id: \.id) { achievement in
                            AwardShield(achievement: achievement, userReportCount: userReportCount)
                                .scaleEffect(0.85)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 200)
            }
            .frame(maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.white,Color.gray.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            // Bottom Half - Progress Preview
            VStack(spacing: 15) {
                HStack {
                    Text("Progreso")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color.brandPrimary)
                    Text("2025")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color.brandAccent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 15)

                // Compact Chart Preview
                VStack(spacing: 12) {
                    ProgressChart(chartData: getChartData())
                        .padding(.horizontal, 24)

                    Text("Desliza hacia arriba para ver más")
                        .font(.caption)
                        .foregroundColor(Color.brandSecondary)
                        .padding(.top, 4)
                }

                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background(Color.white)
        }
    }

    private var fullProgressView: some View {
        ScrollViewWithOffset(
            offset: $scrollOffset,
            content: {
                VStack(spacing: 24) {
                    HStack {
                        Text("Progreso")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.brandPrimary)

                        Text("2025")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.brandAccent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 60)

                // Time Period Filter - Redesigned
                HStack(spacing: 8) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedPeriod = period
                            }
                        }) {
                            Text(period.rawValue)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(selectedPeriod == period ? .white : Color.brandPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedPeriod == period ?
                                    LinearGradient(
                                        colors: [Color.brandAccent, Color.brandPrimary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) : LinearGradient(
                                        colors: [Color.white, Color.white],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(10)
                                .shadow(
                                    color: selectedPeriod == period ? Color.brandAccent.opacity(0.3) : Color.clear,
                                    radius: 6,
                                    x: 0,
                                    y: 3
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Chart with enhanced design
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reportes realizados")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.brandSecondary)
                        .padding(.horizontal, 20)

                    ProgressChart(chartData: getChartData())
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                }

                Spacer()
                .padding(.bottom, 50)
                }
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.gray.opacity(0.03), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onChange(of: scrollOffset) { _, newValue in
            if newValue > 50 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentSection = .splitView
                    scrollOffset = 0
                }
            }
        }
    }

    private func getUserRank() -> String {
        let unlockedCount = achievements.filter { $0.isUnlocked(userReportCount: userReportCount) }.count
        switch unlockedCount {
        case 0: return "Principiante"
        case 1: return "Guardián"
        case 2: return "Protector"
        case 3: return "Escudo"
        case 4: return "Cazador"
        case 5: return "Maestro"
        default: return "Élite"
        }
    }

    private func fetchUserPostInfo() async {
        isLoading = true

        do {
            async let postInfoTask = httpClient.getUserPostInfo()
            async let reportsTask = httpClient.getUserReports()

            let (postInfo, reports) = try await (postInfoTask, reportsTask)

            userPostInfo = postInfo
            userReports = reports
            // Usar reportes APROBADOS (status_id = 2) para los logros
            userReportCount = postInfo.approved

            print("Fetched \(reports.count) total reports")
            print("Approved reports: \(postInfo.approved)")

            // Debug: mostrar las fechas de los reportes
            for (index, report) in reports.prefix(5).enumerated() {
                print("Report \(index + 1): \(report.title) - created_at: \(report.created_at)")
                if let date = report.createdDate {
                    print("   Parsed date: \(date)")
                } else {
                    print("Failed to parse date")
                }
            }

        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            // En caso de error, mantener el valor por defecto
            userReportCount = 0
            userReports = []
        }

        isLoading = false
    }

    // MARK: - Chart Data Processing

    private func getChartData() -> [ChartDataPoint] {
        print("getChartData called with \(userReports.count) reports, period: \(selectedPeriod.rawValue)")

        // Usar todos los reportes (ya vienen del endpoint getUserReports que trae solo los del usuario)
        let data: [ChartDataPoint]

        switch selectedPeriod {
        case .month:
            data = getMonthlyData(from: userReports)
        case .year:
            data = getYearlyData(from: userReports)
        case .all:
            data = getAllTimeData(from: userReports)
        }

        print("Generated \(data.count) data points:")
        for point in data {
            print("   \(point.month): \(point.value)")
        }

        return data
    }

    private func getMonthlyData(from reports: [ReportDTO]) -> [ChartDataPoint] {
        let calendar = Calendar.current
        let now = Date()

        // Obtener el inicio del mes actual
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return []
        }

        // Crear 4 semanas
        var weekData: [String: Int] = [
            "S1": 0,
            "S2": 0,
            "S3": 0,
            "S4": 0
        ]

        for report in reports {
            guard let reportDate = report.createdDate else { continue }

            // Solo contar reportes del mes actual
            guard calendar.isDate(reportDate, equalTo: now, toGranularity: .month) else { continue }

            let dayOfMonth = calendar.component(.day, from: reportDate)
            let weekNumber: String
            if dayOfMonth <= 7 {
                weekNumber = "S1"
            } else if dayOfMonth <= 14 {
                weekNumber = "S2"
            } else if dayOfMonth <= 21 {
                weekNumber = "S3"
            } else {
                weekNumber = "S4"
            }

            weekData[weekNumber, default: 0] += 1
        }

        return [
            ChartDataPoint(month: "S1", value: weekData["S1"] ?? 0),
            ChartDataPoint(month: "S2", value: weekData["S2"] ?? 0),
            ChartDataPoint(month: "S3", value: weekData["S3"] ?? 0),
            ChartDataPoint(month: "S4", value: weekData["S4"] ?? 0)
        ]
    }

    private func getYearlyData(from reports: [ReportDTO]) -> [ChartDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)

        var monthData: [Int: Int] = [:]

        for report in reports {
            guard let reportDate = report.createdDate else { continue }

            let reportYear = calendar.component(.year, from: reportDate)
            guard reportYear == currentYear else { continue }

            let month = calendar.component(.month, from: reportDate)
            monthData[month, default: 0] += 1
        }

        let monthAbbreviations = ["E", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]

        return (1...12).map { month in
            ChartDataPoint(month: monthAbbreviations[month - 1], value: monthData[month] ?? 0)
        }
    }

    private func getAllTimeData(from reports: [ReportDTO]) -> [ChartDataPoint] {
        let calendar = Calendar.current
        var monthData: [String: Int] = [:]

        for report in reports {
            guard let reportDate = report.createdDate else { continue }

            let components = calendar.dateComponents([.year, .month], from: reportDate)
            guard let year = components.year, let month = components.month else { continue }

            let monthAbbreviations = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
            let key = "\(monthAbbreviations[month - 1]) \(String(year).suffix(2))"

            monthData[key, default: 0] += 1
        }

        // Ordenar por fecha
        let sortedKeys = monthData.keys.sorted { key1, key2 in
            // Extraer año y mes de las keys para ordenar correctamente
            return key1 < key2
        }

        return sortedKeys.map { key in
            ChartDataPoint(month: key, value: monthData[key] ?? 0)
        }
    }
}

struct ProgressChart: View {
    let chartData: [ChartDataPoint]

    var maxValue: Int {
        chartData.map { $0.value }.max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if chartData.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color.brandSecondary.opacity(0.4))

                    Text("No hay datos para mostrar")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.brandSecondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            } else {
                VStack(spacing: 12) {
                    // Max value indicator
                    HStack {
                        Spacer()
                        Text("Máx: \(maxValue)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.brandSecondary.opacity(0.7))
                    }

                    HStack(alignment: .bottom, spacing: chartData.count > 10 ? 6 : 12) {
                        ForEach(chartData, id: \.month) { dataPoint in
                            VStack(spacing: 6) {
                                // Value label on top
                                if dataPoint.value > 0 {
                                    Text("\(dataPoint.value)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color.brandPrimary)
                                } else {
                                    Text(" ")
                                        .font(.system(size: 10))
                                }

                                // Bar
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.brandAccent,
                                                    Color.brandPrimary
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: chartData.count > 10 ? 18 : 28)
                                        .frame(height: max(CGFloat(dataPoint.value) / CGFloat(max(maxValue, 1)) * 140, 4))
                                        .shadow(color: Color.brandAccent.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                                .frame(height: 150)

                                // Label
                                Text(dataPoint.month)
                                    .font(.system(size: chartData.count > 10 ? 9 : 11, weight: .medium))
                                    .foregroundColor(Color.brandSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.vertical, 12)
            }
        }
    }
}

struct ChartDataPoint {
    let month: String
    let value: Int
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.brandAccent)

            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.brandPrimary)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color.brandSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}


struct ScrollViewWithOffset<Content: View>: View {
    @Binding var offset: CGFloat
    let content: () -> Content

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
            }
            .frame(height: 0)

            content()
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    NavigationView {
        LogrosScreen()
    }
}
