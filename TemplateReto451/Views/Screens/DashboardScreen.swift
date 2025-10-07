//
//  DashboardScreen.swift
//  TemplateReto451
//
//  Created by Ana Martinez on 25/09/25.
//

import SwiftUI
import Charts
struct DashboardScreen: View {
    
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
        
    func colorLevel(index: Int, total: Int) -> Double {
        let minVal = 0.7
        let maxVal = 1.0
        let normalized = Double(index) / Double(max(1, total - 1))
        // Curva con un poco de easing para que los cambios se sientan naturales
        return minVal + (maxVal - minVal) * (1 - pow(normalized, 0.5))
    }

    
        var body: some View {
            
    
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        Text("Estadísticas")
                               .font(.largeTitle)
                               .bold()
                               .foregroundColor(Color.brandPrimary)
                               .frame(maxWidth: .infinity, alignment: .center)
                               .padding(.top)
                        
                        Spacer()
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            ProgressStatCard(title: "Total de reportes", value: String(totalReports), hasBackground: true)
                            ProgressStatCard(title: "Personas Protegidas", value: String(protectedPeople), hasBackground: true)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
    
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

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Logros Comunitarios")
                                .font(.title2)
                                .bold().foregroundColor(.brandAccent)
                                
                            AchievementRow(icon: "star.fill", title: "Reporteros Activos", subtitle: "\(approvedReports) reportes procesados")
                            AchievementRow(icon: "shield.lefthalf.fill", title: "Protección", subtitle: "\(protectedPeople) personas protegidas")
                            AchievementRow(icon: "flame.fill", title: "Comunidad en Crecimiento", subtitle: "\(users) usuarios activos")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.06))
                        .cornerRadius(12)
                    
                        Spacer()
                        Text("Estado de reportes")
                            .font(.title2)
                            .bold().foregroundColor(.brandAccent)

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


                        Spacer()
                        Text("Reportes por categoría")
                            .font(.title2)
                            .bold().foregroundColor(.brandAccent)
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(topCategoriesReports.enumerated()), id: \.1.0) { index, item in
                                    HStack {
                                        Circle()
                                            .fill(Color.brandSecondary.opacity(colorLevel(index: index, total: topCategoriesReports.count)))
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
                                    .foregroundStyle(Color.brandSecondary.opacity(colorLevel(index: index, total: topCategoriesReports.count)))
                                }
                            }
                            .frame(width: 200, height: 200)
                        }

                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Alertas recientes")
                                .font(.title2)
                                .bold().foregroundColor(.brandAccent)
                            
                            ForEach(Array(recentAlerts.enumerated()), id: \.element) { index, alert in
                                VStack(alignment: .leading) {
                                    
                                    NavigationLink(destination: Report(
                                        user: "User",
                                        user_image: Image("userprofile"),
                                        title: "titulo",
                                        description: "description",
                                        report_image: Image("reporsample"),
                                        url: "https://tevoyaestafar.com/coches"
                                    )) {
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

                                    if index < recentAlerts.count - 1 {
                                        Divider()
                                            .background(Color.brandAccent)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.06))
                        .cornerRadius(12)
                        Spacer()
                        

                    Text("Reportes por Mes")
                            .font(.title2)
                            .bold().foregroundColor(.brandAccent)
                                    
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
                                    .padding()
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Usuarios más activos")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.brandAccent)

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
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.06))
                        .cornerRadius(12)

                        
                        Spacer()
                        
                        VStack(spacing: 20) {
                            // Official Logo Image
                            Image("app-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                        }

                        Link("Ir a Red por la Ciberseguridad", destination: URL(string: "https://redporlaciberseguridad.org/")!)
                                    .foregroundColor(.brandSecondary)
                                    .underline()
                        
                    }.navigationTitle("Dashboard")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                }
            
            }
        }
    }

///


struct BarView: View {
    let titleReport: String
    let count: Int
    let maxCount: Int
    let text: String

    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            // Obtenido con el id
            NavigationLink(destination: Report(
                user: "User",
                user_image: Image("userprofile"),
                title: "titulo",
                description: "description",
                report_image: Image("reporsample"),
                url: "https://tevoyaestafar.com/coches"
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


#Preview {
    DashboardScreen()
}
