//
//  UserAllReportsScreen.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 08/10/25.
//

import SwiftUI

struct UserAllReportsScreen: View {
    let reports: [ReportDTO]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with back button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color.brandPrimary)
                    }
                    .padding(.leading)

                    Spacer()

                    Text("Mis Reportes")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.brandPrimary)

                    Spacer()

                    // Invisible spacer for balance
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .opacity(0)
                        .padding(.trailing)
                }
                .padding(.top)

                // Reports count
                Text("\(reports.count) \(reports.count == 1 ? "Reporte" : "Reportes")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // All Reports List
                if reports.isEmpty {
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
                    ForEach(reports, id: \.id) { report in
                        ComponentReport(
                            report: report,
                            size: .small,
                            showStatusBadge: true
                        )
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationView {
        UserAllReportsScreen(reports: [ReportDTO.sample])
    }
}
