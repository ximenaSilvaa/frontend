//
//  ComponentReport.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//

import SwiftUI
import UIKit

enum ComponentSize {
    case normal
    case small
}

struct ComponentReport: View {
    let report: ReportDTO
    let size: ComponentSize
    var showStatusBadge: Bool = false

    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    @State private var showingShareSheet = false
    @State private var isUpdatingLike: Bool = false

    private let httpClient = HTTPClient()

    func abbreviatedDescription(_ text: String, limit: Int = 250) -> String {
        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            return String(text[..<index]) + "..."
        } else {
            return text
        }
    }

    private func loadLikeData() async {
        do {
            let count = try await httpClient.getTotalUpvotes(reportId: report.id)
            likeCount = max(0, count) // Ensure non-negative count

            // Check if user has liked (stored locally for now)
            isLiked = UserDefaults.standard.bool(forKey: "liked_\(report.id)")
        } catch {
            print("Error loading like data: \(error)")
            // Fallback to local data
            isLiked = UserDefaults.standard.bool(forKey: "liked_\(report.id)")
            likeCount = UserDefaults.standard.integer(forKey: "likeCount_\(report.id)")
        }
    }

    private func toggleLike() {
        guard !isUpdatingLike else {
            print("Already updating like, ignoring tap")
            return
        }

        Task {
            isUpdatingLike = true
            let previousLikeState = isLiked
            let previousCount = likeCount

            do {
                let newCount: Int
                if isLiked {
                    // Unlike
                    print("Sending DELETE request to remove like for report \(report.id)")
                    newCount = try await httpClient.deleteUpvote(reportId: report.id)
                    print("Successfully removed like. New count: \(newCount)")
                    isLiked = false
                    UserDefaults.standard.set(false, forKey: "liked_\(report.id)")
                } else {
                    // Like
                    print("Sending POST request to add like for report \(report.id)")
                    newCount = try await httpClient.createUpvote(reportId: report.id)
                    print("Successfully added like. New count: \(newCount)")
                    isLiked = true
                    UserDefaults.standard.set(true, forKey: "liked_\(report.id)")
                }
                likeCount = newCount
            } catch {
                print("Error toggling like: \(error)")
                print("Error details: \(error.localizedDescription)")
                // Revert to previous state on error
                isLiked = previousLikeState
                likeCount = previousCount
            }

            isUpdatingLike = false
        }
    }

    private func getStatusText() -> String {
        switch report.status_id {
        case 1: return "Pendiente"
        case 2: return "Aprobado"
        case 3: return "Rechazado"
        default: return "Desconocido"
        }
    }

    private func getStatusColor() -> Color {
        switch report.status_id {
        case 1: return Color.brandPrimary
        case 2: return Color.brandAccepted
        case 3: return Color.brandAccent
        default: return Color.gray
        }
    }

    private func getStatusIcon() -> String {
        switch report.status_id {
        case 1: return "clock.fill"
        case 2: return "checkmark.seal.fill"
        case 3: return "xmark.seal.fill"
        default: return "questionmark.circle.fill"
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: report.userImageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.brandAccent.opacity(0.3), Color.brandPrimary.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color.brandAccent.opacity(0.15), radius: 4, x: 0, y: 2)
                } placeholder: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.brandAccent.opacity(0.1), Color.brandPrimary.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.brandSecondary.opacity(0.5))
                    }
                    .frame(width: 48, height: 48)
                }

                Text(report.user_name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color.brandPrimary)

                Spacer()

                HStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Button(action: toggleLike) {
                            Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(isLiked ? Color.brandAccent : Color.brandSecondary.opacity(0.6))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(isLiked ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)

                        Text("\(likeCount)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(isLiked ? Color.brandAccent : Color.brandSecondary)
                    }

                    VStack(spacing: 6) {
                        Button(action: { showingShareSheet = true }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandSecondary.opacity(0.6))
                        }
                        .buttonStyle(PlainButtonStyle())

                        Text("")
                            .font(.system(size: 13))
                            .foregroundColor(.clear)
                    }
                }
            }

            Text(report.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.brandPrimary)
                .lineLimit(2)

            Text(abbreviatedDescription(report.description, limit: size == .small ? 100 : 250))
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.brandSecondary.opacity(0.9))
                .lineSpacing(4)

            // Calling with the id
            NavigationLink(destination: Report(report: report)) {
                HStack(spacing: 6) {
                    Text("Mostrar más")
                        .font(.system(size: 15, weight: .semibold))
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.brandAccent)
            }

            if size == .normal {
                AsyncImage(url: URL(string: report.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.brandSecondary.opacity(0.15), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                        .padding(.top, 4)
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.gray.opacity(0.1))
                        ProgressView()
                            .tint(.brandAccent)
                    }
                    .frame(height: 200)
                }
            }
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Color.white, Color.white.opacity(0.98)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        LinearGradient(
                            colors: [Color.brandAccent.opacity(0.15), Color.brandPrimary.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .frame(maxWidth: 360)
            .shadow(color: Color.brandAccent.opacity(0.08), radius: 12, x: 0, y: 6)
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)

            // Status Badge - Bottom Right Corner (only if showStatusBadge is true)
            if showStatusBadge {
                HStack(spacing: 7) {
                    Image(systemName: getStatusIcon())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)

                    Text(getStatusText())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    LinearGradient(
                        colors: [getStatusColor(), getStatusColor().opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(22)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: getStatusColor().opacity(0.4), radius: 8, x: 0, y: 4)
                .offset(x: -14, y: -14)
            }
        }
        .onAppear {
            Task {
                await loadLikeData()
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["\(report.title)\n\n\(report.description)"])
        }
    }
}

// This view will be called using an ID
struct Report: View {
    let report: ReportDTO

    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    @State private var showingShareSheet = false
    @State private var isUpdatingLike: Bool = false

    private let httpClient = HTTPClient()

    private func loadLikeData() async {
        do {
            let count = try await httpClient.getTotalUpvotes(reportId: report.id)
            likeCount = max(0, count) // Ensure non-negative count

            // Check if user has liked (stored locally for now)
            isLiked = UserDefaults.standard.bool(forKey: "liked_\(report.id)")
        } catch {
            print("Error loading like data: \(error)")
            // Fallback to local data
            isLiked = UserDefaults.standard.bool(forKey: "liked_\(report.id)")
            likeCount = UserDefaults.standard.integer(forKey: "likeCount_\(report.id)")
        }
    }

    private func toggleLike() {
        guard !isUpdatingLike else {
            print("Already updating like, ignoring tap")
            return
        }

        Task {
            isUpdatingLike = true
            let previousLikeState = isLiked
            let previousCount = likeCount

            do {
                let newCount: Int
                if isLiked {
                    // Unlike
                    print("Sending DELETE request to remove like for report \(report.id)")
                    newCount = try await httpClient.deleteUpvote(reportId: report.id)
                    print("Successfully removed like. New count: \(newCount)")
                    isLiked = false
                    UserDefaults.standard.set(false, forKey: "liked_\(report.id)")
                } else {
                    // Like
                    print("Sending POST request to add like for report \(report.id)")
                    newCount = try await httpClient.createUpvote(reportId: report.id)
                    print("Successfully added like. New count: \(newCount)")
                    isLiked = true
                    UserDefaults.standard.set(true, forKey: "liked_\(report.id)")
                }
                likeCount = newCount
            } catch {
                print("Error toggling like: \(error)")
                print("Error details: \(error.localizedDescription)")
                // Revert to previous state on error
                isLiked = previousLikeState
                likeCount = previousCount
            }

            isUpdatingLike = false
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.05)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: report.userImageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.brandAccent.opacity(0.3), Color.brandPrimary.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                )
                                .shadow(color: Color.brandAccent.opacity(0.15), radius: 4, x: 0, y: 2)
                        } placeholder: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.brandAccent.opacity(0.1), Color.brandPrimary.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(.brandSecondary.opacity(0.5))
                            }
                            .frame(width: 48, height: 48)
                        }

                        Text(report.user_name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.brandPrimary)

                        Spacer()

                        HStack(spacing: 16) {
                            VStack(spacing: 6) {
                                Button(action: toggleLike) {
                                    Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundStyle(isLiked ? Color.brandAccent : Color.brandSecondary.opacity(0.6))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .scaleEffect(isLiked ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)

                                Text("\(likeCount)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(isLiked ? Color.brandAccent : Color.brandSecondary)
                            }

                            VStack(spacing: 6) {
                                Button(action: { showingShareSheet = true }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundStyle(Color.brandSecondary.opacity(0.6))
                                }
                                .buttonStyle(PlainButtonStyle())

                                Text("")
                                    .font(.system(size: 14))
                                    .foregroundColor(.clear)
                            }
                        }
                    }

                    Divider()
                        .background(Color.brandSecondary.opacity(0.2))

                    Text(report.title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color.brandPrimary)

                    Text(report.description)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color.brandSecondary.opacity(0.9))
                        .lineSpacing(6)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Liga fraudulenta:")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.brandPrimary)

                        Text(report.report_url)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.brandAccent)
                            .underline()
                    }
                    .padding(.vertical, 8)

                    AsyncImage(url: URL(string: report.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.brandSecondary.opacity(0.15), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    } placeholder: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                            ProgressView()
                                .tint(.brandAccent)
                        }
                        .frame(height: 250)
                    }

                }
                .padding(24)
                .background(
                    LinearGradient(
                        colors: [Color.white, Color.white.opacity(0.98)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.brandAccent.opacity(0.15), Color.brandPrimary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.brandAccent.opacity(0.08), radius: 12, x: 0, y: 6)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            Task {
                await loadLikeData()
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["\(report.title)\n\n\(report.description)"])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ComponentReport_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComponentReport(
                report: ReportDTO.sample,
                size: .normal
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

