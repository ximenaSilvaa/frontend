//
//  ComponentReport.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//

import SwiftUI
import UIKit

struct ComponentReport: View {
    let user: String
    let user_image: Image
    let title: String
    let description: String
    let report_image: Image

    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    @State private var showingShareSheet = false

    private var reportId: String {
        return "\(title)_\(user)".replacingOccurrences(of: " ", with: "_")
    }
    
    
    func abbreviatedDescription(_ text: String, limit: Int = 250) -> String {
        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            return String(text[..<index]) + "..."
        } else {
            return text
        }
    }

    private func loadLikeData() {
        isLiked = UserDefaults.standard.bool(forKey: "liked_\(reportId)")
        likeCount = UserDefaults.standard.integer(forKey: "likeCount_\(reportId)")
    }

    private func saveLikeData() {
        UserDefaults.standard.set(isLiked, forKey: "liked_\(reportId)")
        UserDefaults.standard.set(likeCount, forKey: "likeCount_\(reportId)")
    }

    private func toggleLike() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1
        if likeCount < 0 { likeCount = 0 }
        saveLikeData()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                user_image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(user)
                    .font(.headline)
                    .foregroundColor(Color.brandPrimary)
                
                Spacer()

                VStack(spacing: 4) {
                    Button(action: toggleLike) {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .imageScale(.large)
                            .foregroundStyle(isLiked ? Color.brandPrimary : Color.brandAccent)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text("\(likeCount)")
                        .font(.caption)
                        .foregroundColor(isLiked ? Color.brandPrimary : Color.brandAccent)
                }

                Button(action: { showingShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .foregroundStyle(Color.brandPrimary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(Color.brandPrimary)
            
            Text(abbreviatedDescription(description))
                .font(.body)
                .foregroundColor(.black)
            
            // Calling with the id
            NavigationLink(destination: Report(
                user: user,
                user_image: user_image,
                title: title,
                description: description,
                report_image: report_image,
                url: "https://tevoyaestafar.com/coches"
            )) {
                Text("Mostrar más")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            report_image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 280)
                .cornerRadius(10)
                .padding(.top, 8)
                .frame(maxWidth: .infinity)

        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .frame(width: 350)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            loadLikeData()
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["\(title)\n\n\(description)"])
        }
    }
}

// This view will be called using an ID
struct Report: View {
    let user: String
    let user_image: Image
    let title: String
    let description: String
    let report_image: Image
    let url: String

    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    @State private var showingShareSheet = false

    private var reportId: String {
        return "\(title)_\(user)".replacingOccurrences(of: " ", with: "_")
    }

    private func loadLikeData() {
        isLiked = UserDefaults.standard.bool(forKey: "liked_\(reportId)")
        likeCount = UserDefaults.standard.integer(forKey: "likeCount_\(reportId)")
    }

    private func saveLikeData() {
        UserDefaults.standard.set(isLiked, forKey: "liked_\(reportId)")
        UserDefaults.standard.set(likeCount, forKey: "likeCount_\(reportId)")
    }

    private func toggleLike() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1
        if likeCount < 0 { likeCount = 0 }
        saveLikeData()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    user_image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(user)
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
                            .foregroundColor(isLiked ? Color.brandAccent : Color.brandAccent)
                    }

                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .foregroundStyle(Color.brandAccent)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.brandPrimary)
                
                Text(description)
                Text("Liga fraudulenta:").bold().foregroundColor(Color.brandPrimary)
                Text(url)
                report_image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280)
                    .cornerRadius(10)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity)

            }
            .padding()
            .frame(width: 350)
        }
        .onAppear {
            loadLikeData()
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["\(title)\n\n\(description)"])
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
                user: "AnaTellez300",
                user_image: Image("userprofile"),
                title: "Estafa Venta de Coches",
                description: "El sitio detectado simula ser una página de compraventa de automóviles seminuevos, utilizando fotografías tomadas de portales legítimos para aparentar confiabilidad. La modalidad del fraude consiste en que los supuestos vendedores solicitan de manera insistente el pago anticipado del 50% del valor del automóvil, alegando que dicho anticipo es indispensable para \"asegurar la reserva\" o \"cubrir los gastos de envío a domicilio\".",
                report_image: Image("reporsample")
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
