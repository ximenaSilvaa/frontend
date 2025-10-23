//
//  ProfileScreen.swift
//  TemplateReto451
//
//  Created by User on 18/09/25.
//

import SwiftUI

struct ProfileScreen: View {
    private let httpClient = HTTPClient()

    @State private var userProfile = UserProfileDTO.sample
    @State private var userData: UserResponse?
    @State private var userReports: [ReportDTO] = []
    @State private var userPostInfo: UserPostInfoDTO?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with navigation icons
                HStack {
                    Spacer()
                    NavigationLink(destination: EditProfileScreen(userProfile: $userProfile)) {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(Color.brandAccent)
                    }

                    NavigationLink(destination: ScreenUserSettings()) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(Color.brandAccent)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                // Profile Info Section
                VStack(spacing: 8) {
                    // Profile Image with placeholder
                    if let userData = userData, !userData.image_path.isEmpty {
                        AsyncImage(url: URL(string: URLEndpoints.server + "/" + userData.image_path)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color.brandPrimary)
                            @unknown default:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color.brandPrimary)
                            }
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.brandPrimary)
                    }

                    Text(userData?.username ?? userProfile.username)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.brandPrimary)

                    Text(userData?.name ?? userProfile.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(userData?.email ?? userProfile.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                // Statistics Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Estadísticas 2025")
                            .font(.headline)
                            .foregroundColor(Color.brandPrimary)

                        Spacer()

                        NavigationLink(destination: LogrosScreen()) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color.brandPrimary)
                        }
                    }

                    HStack(spacing: 20) {
                        StatisticItem(
                            number: userPostInfo?.approved ?? userProfile.stats.reports,
                            label: "Reportes aceptados",
                            color: Color.brandAccent
                        )

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 60)

                        StatisticItem(
                            number: userPostInfo?.protectedPeople ?? userProfile.stats.protectedPeople,
                            label: "Personas protegidas",
                            color: Color.brandAccent
                        )

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 60)

                        StatisticItem(
                            number: userPostInfo?.inProcess ?? userProfile.stats.inProcess,
                            label: "En proceso",
                            color: Color.brandAccent
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

                Divider()
                    .padding(.horizontal)

                // User Reports Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Mis Reportes")
                            .font(.headline)
                            .foregroundColor(Color.brandPrimary)

                        Spacer()

                        if userReports.count > 5 {
                            NavigationLink(destination: UserAllReportsScreen(reports: userReports)) {
                                Text("Ver todos")
                                    .font(.subheadline)
                                    .foregroundColor(Color.brandAccent)
                            }
                        }
                    }
                    .padding(.horizontal)

                    if userReports.isEmpty {
                        // Empty State
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))

                            Text("No tienes reportes aún")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        // Display up to 5 reports
                        ForEach(Array(userReports.prefix(5)), id: \.id) { report in
                            ComponentReport(
                                report: report,
                                size: .small,
                                showStatusBadge: true
                            )
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .refreshable {
            await fetchUserProfile()
        }
        .onAppear {
            Task {
                await fetchUserProfile()
            }
        }
    }

    private func fetchUserProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            // Fetch profile, reports, and post info in parallel
            async let profile = httpClient.getUserProfile()
            async let reports = httpClient.getUserReports()
            async let postInfo = httpClient.getUserPostInfo()

            userData = try await profile
            userReports = try await reports
            userPostInfo = try await postInfo

            isLoading = false
        } catch {
            errorMessage = "Error loading profile"
            isLoading = false
            print("Error fetching user profile: \(error.localizedDescription)")
        }
    }
}

struct StatisticItem: View {
    let number: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(number)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(label)
                .font(.caption)
                .foregroundColor(color)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    NavigationView {
        ProfileScreen()
    }
}
