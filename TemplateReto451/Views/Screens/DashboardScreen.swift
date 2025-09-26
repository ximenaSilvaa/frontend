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
        
    func grayLevel(index: Int, total: Int) -> Double {
            let minGray: Double = 0.3
            let maxGray: Double = 0.9
            let step = (maxGray - minGray) / Double(max(1, total - 1))
            return maxGray - (Double(index) * step)
        }
    
        var body: some View {
            
    
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        Text("Estadísticas")
                               .font(.largeTitle)
                               .bold()
                               .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                               .frame(maxWidth: .infinity, alignment: .center)
                               .padding(.top)
                        
                        //
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            ProgressStatCard(title: "Total de reportes", value: String(totalReports), hasBackground: true)
                            ProgressStatCard(title: "Personas Protegidas", value: String(protectedPeople), hasBackground: true)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 1)
                        
                        //
                        VStack(alignment: .leading, spacing: 16) {
                            // Título de sección
                            Text("Top reportes del mes")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.bottom, 8)

                    
                            let maxValue = topReportsMonth.map { $0.1 }.max() ?? 1
                            let maxCountWithMargin = Int(Double(maxValue) * 1.1)

     
                            ForEach(topReportsMonth, id: \.0) { category, count in
                                BarView(
                                    category: category,
                                    count: count,
                                    maxCount: maxCountWithMargin,
                                    text: "\(count) likes"
                                )
                            }
                        }
                        .padding()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Logros Comunitarios")
                                .font(.headline)
                            AchievementRow(icon: "star.fill", title: "Reporteros Activos", subtitle: "\(approvedReports) reportes procesados")
                            AchievementRow(icon: "shield.lefthalf.fill", title: "Protección", subtitle: "\(protectedPeople) personas protegidas")
                            AchievementRow(icon: "flame.fill", title: "Comunidad en Crecimiento", subtitle: "\(users) usuarios activos")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.06))
                        .cornerRadius(12)
                        
                    ////
                        ///
                        Text("Estado de reportes")
                            .font(.headline)

                        HStack {
                
                            Chart {
                                let estadoReports = [
                                    ("Aprobados", approvedReports, Color.green),
                                    ("Rechazados", rejectedReports, Color.red),
                                    ("Pendientes", pendingReports, Color.yellow)
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
                                        .fill(Color.green)
                                        .frame(width: 12, height: 12)
                                    Text("Aprobados")
                                        .font(.caption)
                                }

                                HStack {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 12, height: 12)
                                    Text("Rechazados")
                                        .font(.caption)
                                }

                                HStack {
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 12, height: 12)
                                    Text("Pendientes")
                                        .font(.caption)
                                }
                            }
                            .padding(.leading, 12)
                        }


                        ///
                       
                        Text("Reportes por categoría")
                        HStack {
                            // Leyenda a la izquierda
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(topCategoriesReports.enumerated()), id: \.1.0) { index, item in
                                    HStack {
                                        Circle()
                                            .fill(Color(white: grayLevel(index: index, total: topCategoriesReports.count)))
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
                                    .foregroundStyle(Color(white: grayLevel(index: index, total: topCategoriesReports.count)))
                                }
                            }
                            .frame(width: 200, height: 200)
                        }

                        ///
                        
                        ///
                        VStack(alignment: .leading) {
                            Text("Alertas recientes")
                                .font(.headline)
                            
                            ForEach(Array(recentAlerts.enumerated()), id: \.element) { index, alert in
                                VStack(alignment: .leading) {
                                    Text("\(alert)")
                                        .padding(.vertical, 2)
                                    
                                    if index < recentAlerts.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.06))
                        .cornerRadius(12)
                        
                        

                    ////
                    Text("Reportes por Mes")
                        .font(.headline)
                                    
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
                        
                        
                        // Ranking usuarios más activos
                        VStack(alignment: .leading) {
                            Text("Usuarios más activos")
                                .font(.headline)
                            ForEach(topUsers, id: \.0) { user, reports in
                                HStack {
                                    Text(user)
                                    Spacer()
                                    Text("\(reports) reportes")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.06))
                        .cornerRadius(12)
                        
                        
                        
                        
                    
            
                        
                    }.navigationTitle("Dashboard")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                }
            
            }
        }
    }

///

struct BarView: View {
    let category: String
    let count: Int
    let maxCount: Int
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(category)
                .font(.subheadline)
                .foregroundColor(Color.gray.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)


            HStack {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                    
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.6))
                            .frame(
                                width: CGFloat(count) / CGFloat(max(maxCount, 1)) * geo.size.width,
                                height: 14
                            )
                    }
                }
                .frame(height: 14)

                Text("\(text)")
                    .font(.caption)
                    .foregroundColor(Color.gray.opacity(0.6))
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
                .foregroundColor(Color.gray)
                .font(.system(size: 28))
                .frame(width: 36, height: 36)
             
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.gray)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}


#Preview {
    DashboardScreen()
}
