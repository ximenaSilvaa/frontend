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

    enum TimePeriod: String, CaseIterable {
        case month = "Month"
        case year = "Year"
        case all = "All"
    }

    let achievements = [
        Achievement(id: 1, reportCount: 3, imageName: "award1", title: "First Reports", description: "3 reportes", isUnlocked: true),
        Achievement(id: 2, reportCount: 5, imageName: "award1", title: "Getting Started", description: "5 reportes", isUnlocked: true),
        Achievement(id: 3, reportCount: 10, imageName: "award2", title: "Active Reporter", description: "10 reportes", isUnlocked: false),
        Achievement(id: 4, reportCount: 15, imageName: "award2", title: "Dedicated Helper", description: "15 reportes", isUnlocked: false),
        Achievement(id: 5, reportCount: 28, imageName: "award3", title: "Expert Protector", description: "28 reportes", isUnlocked: false),
        Achievement(id: 6, reportCount: 20, imageName: "award3", title: "Community Guardian", description: "20 reportes", isUnlocked: false)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            .background(Color.gray.opacity(0.1))

            // Horizontal ScrollView for sliding between sections
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    // Progress Section (White Background) - Shows first
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            HStack {
                                Text("Progress")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.black)

                                Spacer()

                                Text("2025")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal)
                            .padding(.top, 30)

                            // Time Period Filter
                            HStack(spacing: 0) {
                                ForEach(TimePeriod.allCases, id: \.self) { period in
                                    Button(action: {
                                        selectedPeriod = period
                                    }) {
                                        Text(period.rawValue)
                                            .font(.headline)
                                            .foregroundColor(selectedPeriod == period ? .black : .gray)
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
                                ProgressStatCard(title: "Distance (km)", value: getDistanceValue(), hasBackground: true)
                                ProgressStatCard(title: "Elevation Gain (m)", value: getElevationValue(), hasBackground: false)
                                ProgressStatCard(title: "Completed", value: getCompletedValue(), hasBackground: false)
                                ProgressStatCard(title: "Moving Time", value: getMovingTimeValue(), hasBackground: false)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 50)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.white)

                    // Achievements Section (Grey Background) - Shows when sliding right
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            Text("Achievements")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.top, 30)

                            // Achievement Grid
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(achievements, id: \.id) { achievement in
                                    AchievementView(achievement: achievement)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 50)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.gray.opacity(0.1))
                }
            }
            .scrollTargetBehavior(.paging)
        }
        .navigationBarHidden(true)
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
}

struct Achievement {
    let id: Int
    let reportCount: Int
    let imageName: String
    let title: String
    let description: String
    let isUnlocked: Bool
}

struct AchievementView: View {
    let achievement: Achievement

    private var shieldColor: Color {
        switch achievement.imageName {
        case "award1": return Color.gray // Silver shields
        case "award2": return Color.yellow // Gold shields
        case "award3": return Color.black // Black shields
        default: return Color.gray
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            // Shield Icon
            Image(systemName: "shield.fill")
                .font(.system(size: 60))
                .foregroundColor(shieldColor)
                .opacity(achievement.isUnlocked ? 1.0 : 0.3)

            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if achievement.isUnlocked {
                Button("Share") {
                    // Share functionality
                }
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
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

#Preview {
    NavigationView {
        LogrosScreen()
    }
}