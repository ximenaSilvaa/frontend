//
//  ProfileScreen.swift
//  TemplateReto451
//
//  Created by User on 18/09/25.
//

import SwiftUI

struct ProfileScreen: View {
    @State private var userProfile = UserProfileDTO.sample

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
                    userProfile.profileImage
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .foregroundColor(Color.brandPrimary)

                    Text(userProfile.username)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.brandPrimary)

                    Text(userProfile.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(userProfile.location)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(userProfile.email)
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
                            number: userProfile.stats.reports,
                            label: "Reportes",
                            color: Color.brandAccent
                        )

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 60)

                        StatisticItem(
                            number: userProfile.stats.protectedPeople,
                            label: "Personas protegidas",
                            color: Color.brandAccent
                        )

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 60)

                        StatisticItem(
                            number: userProfile.stats.inProcess,
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

                // Sample Report
                ComponentReport(
                    report: ReportDTO.sample,
                    size: .small
                )
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationBarHidden(true)
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
