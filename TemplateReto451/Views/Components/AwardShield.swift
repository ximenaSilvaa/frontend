//
//  AwardShield.swift
//  TemplateReto451
//
//  Created by Claude on 26/09/25.
//

import SwiftUI

struct AwardShield: View {
    let achievement: Achievement
    let userReportCount: Int
    @State private var showingShareSheet = false

    private var isUnlocked: Bool {
        achievement.isUnlocked(userReportCount: userReportCount)
    }

    private var progress: Double {
        if isUnlocked { return 1.0 }
        return min(Double(userReportCount) / Double(achievement.reportCount), 1.0)
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background shield shape based on level
                ShieldShape(level: achievement.level)
                    .fill(
                        LinearGradient(
                            colors: isUnlocked ? achievement.level.colors : [Color.gray.opacity(0.3), Color.gray.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 110)
                    .shadow(
                        color: isUnlocked ? achievement.level.shadowColor.opacity(0.4) : Color.clear,
                        radius: 10,
                        x: 0,
                        y: 6
                    )

                // Icon inside shield
                Image(systemName: achievement.symbol)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(isUnlocked ? .white : .gray.opacity(0.6))
                    .shadow(
                        color: isUnlocked ? Color.black.opacity(0.3) : Color.clear,
                        radius: 2,
                        x: 0,
                        y: 1
                    )

                // Progress ring for locked achievements
                if !isUnlocked {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [Color.brandAccent.opacity(0.8), Color.brandSecondary.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 115, height: 115)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.8), value: progress)
                }

                // Unlock sparkle effect
                if isUnlocked {
                    ForEach(0..<8, id: \.self) { index in
                        Image(systemName: "sparkle")
                            .font(.system(size: 10))
                            .foregroundColor(achievement.level.colors.first ?? .yellow)
                            .offset(
                                x: cos(Double(index) * .pi / 4) * 60,
                                y: sin(Double(index) * .pi / 4) * 60
                            )
                            .opacity(0.7)
                            .animation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.1),
                                value: isUnlocked
                            )
                    }
                }
            }

            VStack(spacing: 8) {
                Text(achievement.title)
                    .font(.system(.callout, design: .rounded, weight: .bold))
                    .foregroundColor(isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(achievement.description)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)

                // Progress text for locked achievements
                if !isUnlocked {
                    Text("\(userReportCount)/\(achievement.reportCount)")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundColor(Color.brandAccent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.brandAccent.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            if isUnlocked {
                Button("Compartir") {
                    showingShareSheet = true
                }
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    LinearGradient(
                        colors: achievement.level.colors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: achievement.level.shadowColor.opacity(0.3), radius: 4, x: 0, y: 2)
            }
        }
        .frame(width: 140)
        .padding(.vertical, 20)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["🏆 ¡Acabo de obtener el logro \(achievement.title)! \(achievement.description)"])
        }
    }
}

struct ShieldShape: Shape {
    let level: AwardLevel

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        switch level {
        case .bronze:
            // Classic shield shape
            path.move(to: CGPoint(x: width * 0.5, y: 0))
            path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.25))
            path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.7))
            path.addQuadCurve(
                to: CGPoint(x: width * 0.5, y: height),
                control: CGPoint(x: width * 0.9, y: height * 0.9)
            )
            path.addQuadCurve(
                to: CGPoint(x: width * 0.1, y: height * 0.7),
                control: CGPoint(x: width * 0.1, y: height * 0.9)
            )
            path.addLine(to: CGPoint(x: width * 0.1, y: height * 0.25))
            path.addLine(to: CGPoint(x: width * 0.5, y: 0))

        case .silver:
            // Diamond shield
            path.move(to: CGPoint(x: width * 0.5, y: 0))
            path.addLine(to: CGPoint(x: width * 0.85, y: height * 0.3))
            path.addLine(to: CGPoint(x: width * 0.85, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.5, y: height))
            path.addLine(to: CGPoint(x: width * 0.15, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.15, y: height * 0.3))
            path.addLine(to: CGPoint(x: width * 0.5, y: 0))

        case .gold:
            // Hexagonal shield
            path.move(to: CGPoint(x: width * 0.5, y: 0))
            path.addLine(to: CGPoint(x: width * 0.87, y: height * 0.25))
            path.addLine(to: CGPoint(x: width * 0.87, y: height * 0.75))
            path.addLine(to: CGPoint(x: width * 0.5, y: height))
            path.addLine(to: CGPoint(x: width * 0.13, y: height * 0.75))
            path.addLine(to: CGPoint(x: width * 0.13, y: height * 0.25))
            path.addLine(to: CGPoint(x: width * 0.5, y: 0))

        case .platinum:
            // Star shield
            let center = CGPoint(x: width * 0.5, y: height * 0.5)
            let outerRadius = width * 0.45
            let innerRadius = width * 0.25
            let points = 8

            for i in 0..<points * 2 {
                let angle = Double(i) * .pi / Double(points)
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let x = center.x + cos(angle - .pi/2) * radius
                let y = center.y + sin(angle - .pi/2) * radius

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case .diamond:
            // Crown shield
            path.move(to: CGPoint(x: width * 0.2, y: height * 0.3))
            path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.1))
            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.15))
            path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.1))
            path.addLine(to: CGPoint(x: width * 0.8, y: height * 0.3))
            path.addLine(to: CGPoint(x: width * 0.85, y: height * 0.7))
            path.addQuadCurve(
                to: CGPoint(x: width * 0.5, y: height * 0.95),
                control: CGPoint(x: width * 0.75, y: height * 0.9)
            )
            path.addQuadCurve(
                to: CGPoint(x: width * 0.15, y: height * 0.7),
                control: CGPoint(x: width * 0.25, y: height * 0.9)
            )
            path.addLine(to: CGPoint(x: width * 0.2, y: height * 0.3))
        }

        return path
    }
}

struct Achievement {
    let id: Int
    let reportCount: Int
    let level: AwardLevel
    let title: String
    let description: String
    let symbol: String

    func isUnlocked(userReportCount: Int) -> Bool {
        return userReportCount >= reportCount
    }
}

enum AwardLevel {
    case bronze, silver, gold, platinum, diamond

    var colors: [Color] {
        switch self {
        case .bronze:
            return [Color.brandSecondary.opacity(0.8), Color.brandPrimary]
        case .silver:
            return [Color.brandSecondary, Color.brandPrimary.opacity(0.8)]
        case .gold:
            return [Color.brandAccent, Color.brandAccent.opacity(0.7)]
        case .platinum:
            return [Color.brandPrimary, Color.brandSecondary]
        case .diamond:
            return [Color.brandAccent, Color.brandPrimary]
        }
    }

    var shadowColor: Color {
        switch self {
        case .bronze: return Color.brandPrimary
        case .silver: return Color.brandSecondary
        case .gold: return Color.brandAccent
        case .platinum: return Color.brandPrimary
        case .diamond: return Color.brandAccent
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        AwardShield(
            achievement: Achievement(
                id: 1,
                reportCount: 3,
                level: .bronze,
                title: "First Guardian",
                description: "Made your first 3 reports",
                symbol: "shield.lefthalf.filled"
            ),
            userReportCount: 5
        )

        AwardShield(
            achievement: Achievement(
                id: 2,
                reportCount: 10,
                level: .gold,
                title: "Community Shield",
                description: "Reached 15 security reports",
                symbol: "shield.checkered"
            ),
            userReportCount: 5
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}