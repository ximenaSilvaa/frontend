//
//  DashboardScreen.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 25/09/25.
//

import SwiftUI
import Charts

struct DashboardScreen: View {
    
    // MARK: - Datos
    let totalReports = 128
    let approvedReports = 95
    let rejectedReports = 12
    let pendingReports = 21
    let protectedPeople = 860
    let users = 900
    
    let topCategoriesReports = [
        ("Eléctrodomesticos", 45),
        ("Ropa", 35),
        ("Carros", 28),
        ("Prestamos", 15),
        ("Otros", 5)
    ]
    
    let reportsPerMonth = [
        ("Jan", 10),
        ("Feb", 15),
        ("Mar", 12),
        ("Apr", 20),
        ("May", 18),
        ("Jun", 22),
        ("Jul", 5),
        ("Aug", 10),
        ("Sep", 17),
        ("Oct", 9),
        ("Nov", 8),
        ("Dec", 23),
    ]

    let topUsers = [
        ("Ana", 50),
        ("Xime", 42),
        ("Arti", 38),
        ("Ro", 32),
    ]
    
    let recentAlerts = [
        "Phishing en tienda online",
        "Fraude financiero en prestamos.mx",
        "Compra inefectiva tienda trend clothes",
        "Alerta: aumento en fraudes financieros en invierte.mx",
    ]

    let topReportsMonth = [
        ("Phishing en tienda online", 32),
        ("Fraude financiero en prestamos.mx", 23),
        ("Compra inefectiva tienda trend clothes", 20),
        ("Alerta: aumento en fraudes financieros en invierte.mx",11),
    ]
    
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
        let topReportsMonth: [(String, Int)]

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Top reportes del mes")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brandAccent)
                    .padding(.bottom, 8)

                let maxValue = topReportsMonth.map { $0.1 }.max() ?? 1
                let maxCountWithMargin = Int(Double(maxValue) * 1.1)

                ForEach(topReportsMonth, id: \.0) { titleReport, count in
                    BarView(
                        titleReport: titleReport,
                        count: count,
                        maxCount: maxCountWithMargin,
                        text: "\(count) likes"
                    )
                }
            }
            .padding()
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
        let alert: String
        let isLast: Bool
        
        var body: some View {
            VStack(alignment: .leading) {
                NavigationLink(destination: Report(report: ReportDTO(
                    id: 1,
                    title: "titulo",
                    image: "reporsample",
                    description: "description",
                    user_name: "User",
                    created_by: 1,
                    user_image: "userprofile",
                    report_url: "/report-pictures/57c0a3a48e923d8bb9e94b3a8ff743a58e9c4e71d4ccf0e6e2e3d513a7f49fdd.jpg",
                    categories: [1, 2] ))) {
                    HStack(alignment: .top, spacing: 8) {
                        Text(alert)
                            .foregroundColor(.brandPrimary)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                    }
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.vertical, 8)
                }
                
                if !isLast {
                    Divider()
                        .background(Color.brandAccent)
                }
            }
        }
    }

    struct RecentAlertsView: View {
        let recentAlerts: [String]

        var body: some View {
            VStack(alignment: .leading) {
                Text("Alertas recientes")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brandAccent)

                ForEach(Array(recentAlerts.enumerated()), id: \.element) { index, alert in
                    AlertRow(alert: alert, isLast: index == recentAlerts.count - 1)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.06))
            .cornerRadius(12)
            .padding(.horizontal)
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
                Image("app-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)

                Link("Ir a Red por la Ciberseguridad", destination: URL(string: "https://redporlaciberseguridad.org/")!)
                    .foregroundColor(.brandSecondary)
                    .underline()
            }
            .padding(.vertical)
        }
    }

struct BarView: View {
    let titleReport: String
    let count: Int
    let maxCount: Int
    let text: String

    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            // Obtenido con el id
            NavigationLink(destination: Report(report:
                ReportDTO(
                    id: 1,
                    title: "Título de reporte de prueba",
                    image: "report-pictures/ejemplo.jpg",
                    description: "Esta es una descripción de ejemplo para ver cómo se muestra el reporte.",
                    user_name: "Usuario de ejemplo",
                    created_by: 1, // id del creador
                    user_image: "user-pictures/avatar.jpg", // path relativo o nombre de archivo
                    report_url: "https://ejemplo.com/reporte",
                    categories: [1, 2]
                )
            )) {
                HStack {
                    Text(titleReport)
                        .font(.subheadline)
                        .foregroundColor(.brandPrimary.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }


            HStack {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.brandSecondary)
                            .frame(
                                width: CGFloat(count) / CGFloat(max(maxCount, 1)) * geo.size.width,
                                height: 14
                            )
                    }
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
    }
}


struct AchievementRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.brandPrimary)
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

    
    
    // MARK: - Body principal
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView()
                    
                    ProgressCardsView(totalReports: totalReports, protectedPeople: protectedPeople)
                    
                    TopReportsView(topReportsMonth: topReportsMonth)
                    
                    AchievementsView(approvedReports: approvedReports, protectedPeople: protectedPeople, users: users)
                    
                    ReportStatusChartView(approvedReports: approvedReports, rejectedReports: rejectedReports, pendingReports: pendingReports)
                    
                    ReportsByCategoryView(topCategoriesReports: topCategoriesReports, colorLevel: colorLevel)
                    
                    RecentAlertsView(recentAlerts: recentAlerts)
                    
                    ReportsPerMonthView(reportsPerMonth: reportsPerMonth)
                    
                    TopUsersView(topUsers: topUsers)
                    
                    FooterView()
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DashboardScreen()
}
