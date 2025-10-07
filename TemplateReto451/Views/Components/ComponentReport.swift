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
            likeCount = count

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
            print("⚠️ Already updating like, ignoring tap")
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
                    print("🔄 Sending DELETE request to remove like for report \(report.id)")
                    newCount = try await httpClient.deleteUpvote(reportId: report.id)
                    print("✅ Successfully removed like. New count: \(newCount)")
                    isLiked = false
                    UserDefaults.standard.set(false, forKey: "liked_\(report.id)")
                } else {
                    // Like
                    print("🔄 Sending POST request to add like for report \(report.id)")
                    newCount = try await httpClient.createUpvote(reportId: report.id)
                    print("✅ Successfully added like. New count: \(newCount)")
                    isLiked = true
                    UserDefaults.standard.set(true, forKey: "liked_\(report.id)")
                }
                likeCount = newCount
            } catch {
                print("❌ Error toggling like: \(error)")
                print("❌ Error details: \(error.localizedDescription)")
                // Revert to previous state on error
                isLiked = previousLikeState
                likeCount = previousCount
            }

            isUpdatingLike = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                AsyncImage(url: URL(string: report.userImageURL)) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }

                Text(report.user_name)
                    .font(.headline)
                    .foregroundColor(Color.brandPrimary)

                Spacer()

                VStack(spacing: 4) {
                    Button(action: toggleLike) {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .imageScale(.large)
                            .foregroundStyle(isLiked ? Color.brandAccent : Color.brandAccent)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text("\(likeCount)")
                        .font(.caption)
                        .foregroundColor(isLiked ? Color.brandPrimary : Color.brandPrimary)
                }

                VStack(spacing: 4) {
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .foregroundStyle(Color.brandAccent)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text("")
                        .font(.caption)
                        .foregroundColor(.clear)
                }
            }

            Text(report.title)
                .font(.title2)
                .bold()
                .foregroundColor(Color.brandPrimary)

            Text(abbreviatedDescription(report.description, limit: size == .small ? 100 : 250))
                .font(.body)
                .foregroundColor(.black)

            // Calling with the id
            NavigationLink(destination: Report(report: report)) {
                Text("Mostrar más")
                    .font(.caption)
                    .foregroundColor(.brandAccent)
            }

            if size == .normal {
                AsyncImage(url: URL(string: report.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280)
                        .cornerRadius(10)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    ProgressView()
                        .frame(width: 280, height: 200)
                }
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .frame(width: 350)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
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
            likeCount = count

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
            print("⚠️ Already updating like, ignoring tap")
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
                    print("🔄 Sending DELETE request to remove like for report \(report.id)")
                    newCount = try await httpClient.deleteUpvote(reportId: report.id)
                    print("✅ Successfully removed like. New count: \(newCount)")
                    isLiked = false
                    UserDefaults.standard.set(false, forKey: "liked_\(report.id)")
                } else {
                    // Like
                    print("🔄 Sending POST request to add like for report \(report.id)")
                    newCount = try await httpClient.createUpvote(reportId: report.id)
                    print("✅ Successfully added like. New count: \(newCount)")
                    isLiked = true
                    UserDefaults.standard.set(true, forKey: "liked_\(report.id)")
                }
                likeCount = newCount
            } catch {
                print("❌ Error toggling like: \(error)")
                print("❌ Error details: \(error.localizedDescription)")
                // Revert to previous state on error
                isLiked = previousLikeState
                likeCount = previousCount
            }

            isUpdatingLike = false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: report.userImageURL)) { image in
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }

                    Text(report.user_name)
                        .font(.headline)
                        .foregroundColor(Color.brandPrimary)

                    Spacer()

                    VStack(spacing: 4) {
                        Button(action: toggleLike) {
                            Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .imageScale(.large)
                                .foregroundStyle(isLiked ? Color.brandAccent : Color.brandAccent)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Text("\(likeCount)")
                            .font(.caption)
                            .foregroundColor(isLiked ? Color.brandPrimary : Color.brandPrimary)
                    }

                    VStack(spacing: 4) {
                        Button(action: { showingShareSheet = true }) {
                            Image(systemName: "square.and.arrow.up")
                                .imageScale(.large)
                                .foregroundStyle(Color.brandAccent)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Text("")
                            .font(.caption)
                            .foregroundColor(.clear)
                    }
                }

                Text(report.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)

                Text(report.description)
                    .foregroundColor(.black)

                Text("Liga fraudulenta:")
                    .bold()
                    .foregroundColor(Color.brandPrimary)

                Text(report.report_url)
                    .foregroundColor(.blue)
                    .underline()

                AsyncImage(url: URL(string: report.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280)
                        .cornerRadius(10)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    ProgressView()
                        .frame(width: 280, height: 200)
                }

            }
            .padding()
            .frame(width: 350)
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
