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
    @State private var userReportCount: Int = 8 // This should come from your data source
    @State private var scrollOffset: CGFloat = 0

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

            // Back Arrow (Always Visible)
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
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
    }

    private var splitView: some View {
        VStack(spacing: 0) {
            // Top Half - Logros Section
            VStack(spacing: 15) {
                HStack {
                    Text("Logros")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)

                // Achievement Stats
                HStack(spacing: 20) {
                    VStack {
                        Text("\(achievements.filter { $0.isUnlocked(userReportCount: userReportCount) }.count)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                        Text("Desbloqueados")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Rectangle()
                        .frame(width: 1, height: 40)
                        .foregroundColor(.gray.opacity(0.3))

                    VStack {
                        Text("\(userReportCount)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                        Text("Reportes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Rectangle()
                        .frame(width: 1, height: 40)
                        .foregroundColor(.gray.opacity(0.3))

                    VStack {
                        Text(getUserRank())
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                        Text("Rango")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)

                // Horizontal Scrolling Awards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        ForEach(achievements, id: \.id) { achievement in
                            AwardShield(achievement: achievement, userReportCount: userReportCount)
                                .scaleEffect(0.8) // Slightly smaller for split view
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 200)
            }
            .frame(maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))

            // Bottom Half - Progress Preview
            VStack(spacing: 15) {
                HStack {
                    Text("Progreso")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))

                    Spacer()

               
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)

                // Compact Chart Preview
                ProgressChart(selectedPeriod: selectedPeriod)
                    .scaleEffect(0.7)
                    .padding(.horizontal)

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
                VStack(spacing: 20) {
                    HStack {
                        Text("Progreso")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))

                        Spacer()

                        Text("2025")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    }
                    .padding(.horizontal)
                    .padding(.top, 60)

                // Time Period Filter
                HStack(spacing: 0) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Button(action: {
                            selectedPeriod = period
                        }) {
                            Text(period.rawValue)
                                .font(.headline)
                                .foregroundColor(selectedPeriod == period ? Color(red: 4/255, green: 9/255, blue: 69/255) : .gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    selectedPeriod == period ?
                                    Color.white :
                                    Color.gray.opacity(0.2)
                                )
                        }
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(25)
                .padding(.horizontal)

                // Chart
                ProgressChart(selectedPeriod: selectedPeriod)
                    .padding(.horizontal)

                // Stats Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ProgressStatCard(title: "Distancia (km)", value: getDistanceValue(), hasBackground: true)
                    ProgressStatCard(title: "Ganancia de Elevación (m)", value: getElevationValue(), hasBackground: false)
                    ProgressStatCard(title: "Completados", value: getCompletedValue(), hasBackground: false)
                    ProgressStatCard(title: "Tiempo en Movimiento", value: getMovingTimeValue(), hasBackground: false)
                }
                .padding(.horizontal)

                // Swipe Down Indicator
                VStack(spacing: 8) {
                    Text("Desliza hacia abajo para Logros")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity(0.7)
                }
                .padding(.bottom, 50)
                }
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onChange(of: scrollOffset) { _, newValue in
            // When user scrolls up significantly at the top of the content, go back to split view
            if newValue > 50 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentSection = .splitView
                    scrollOffset = 0 // Reset scroll offset
                }
            }
        }
    }

    private func getDistanceValue() -> String {
        switch selectedPeriod {
        case .month: return "25.0"
        case .year: return "73.0"
        case .all: return "120.5"
        }
    }

    private func getElevationValue() -> String {
        switch selectedPeriod {
        case .month: return "1,200"
        case .year: return "2,303"
        case .all: return "4,850"
        }
    }

    private func getCompletedValue() -> String {
        switch selectedPeriod {
        case .month: return "3"
        case .year: return "10"
        case .all: return "25"
        }
    }

    private func getMovingTimeValue() -> String {
        switch selectedPeriod {
        case .month: return "5h 2m"
        case .year: return "15h 8m"
        case .all: return "32h 15m"
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
}

struct ProgressChart: View {
    let selectedPeriod: LogrosScreen.TimePeriod

    var chartData: [ChartDataPoint] {
        switch selectedPeriod {
        case .month:
            return [
                ChartDataPoint(month: "W1", value: 5),
                ChartDataPoint(month: "W2", value: 12),
                ChartDataPoint(month: "W3", value: 8),
                ChartDataPoint(month: "W4", value: 15)
            ]
        case .year:
            return [
                ChartDataPoint(month: "J", value: 10),
                ChartDataPoint(month: "F", value: 15),
                ChartDataPoint(month: "M", value: 8),
                ChartDataPoint(month: "A", value: 22),
                ChartDataPoint(month: "M", value: 5),
                ChartDataPoint(month: "J", value: 0),
                ChartDataPoint(month: "J", value: 0),
                ChartDataPoint(month: "A", value: 0),
                ChartDataPoint(month: "S", value: 0),
                ChartDataPoint(month: "O", value: 0),
                ChartDataPoint(month: "N", value: 0),
                ChartDataPoint(month: "D", value: 0)
            ]
        case .all:
            return [
                ChartDataPoint(month: "2022", value: 25),
                ChartDataPoint(month: "2023", value: 35),
                ChartDataPoint(month: "2024", value: 45),
                ChartDataPoint(month: "2025", value: 22)
            ]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ForEach(chartData, id: \.month) { dataPoint in
                    VStack {
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: 20)
                                .frame(height: CGFloat(dataPoint.value) * 3)
                                .cornerRadius(10)
                        }
                        .frame(height: 120)

                        Text(dataPoint.month)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Chart labels
            HStack {
                Spacer()
                Text("37 km")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            HStack {
                Spacer()
                Text("18 km")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ChartDataPoint {
    let month: String
    let value: Int
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let hasBackground: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            hasBackground ?
            Color.gray.opacity(0.1) :
            Color.clear
        )
        .cornerRadius(12)
        .overlay(
            hasBackground ? nil :
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
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
