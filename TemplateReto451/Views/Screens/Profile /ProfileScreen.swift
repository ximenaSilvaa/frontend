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
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    }

                    NavigationLink(destination: ScreenUserSettings()) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
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
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))

                    Text(userProfile.username)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))

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
                            .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))

                        Spacer()

                        NavigationLink(destination: LogrosScreen()) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                        }
                    }

                    HStack(spacing: 20) {
                        StatisticItem(
                            number: userProfile.stats.reports,
                            label: "Reportes",
                            color: Color(red: 4/255, green: 9/255, blue: 69/255)
                        )

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 60)

                        StatisticItem(
                            number: userProfile.stats.protectedPeople,
                            label: "Personas protegidas",
                            color: Color(red: 4/255, green: 9/255, blue: 69/255)
                        )

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 60)

                        StatisticItem(
                            number: userProfile.stats.inProcess,
                            label: "En proceso",
                            color: Color(red: 4/255, green: 9/255, blue: 69/255)
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
                ComponentReportSmall(
                    user: userProfile.username,
                    user_image: userProfile.profileImage,
                    title: "Estafa venta Coches.com",
                    description: "El sitio detectado simula ser una página de compraventa de automóviles seminuevos, utilizando fotografías tomadas de portales legítimos para aparentar confiabilidad. La modalidad del fraude consiste en que los supuestos vendedores solicitan de manera insistente el pago anticipado del 50% del valor del automóvil, alegando que dicho anticipo es indispensable para \"asegurar la reserva\" o \"cubrir los gastos de envío a domicilio\".",                )
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

            Text(label)
                .font(.caption)
                .foregroundColor(color)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView {
        ProfileScreen()
    }
}
