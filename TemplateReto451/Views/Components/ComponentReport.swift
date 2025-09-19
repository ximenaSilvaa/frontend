//
//  ComponentReport.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//

import SwiftUI

//
//  ComponentReporte.swift
//  TemplateReto
//
//  Created by Ana Martinez on 16/09/25.
//
import SwiftUI
struct ComponentReport: View {
    let user: String
    let user_image: Image
    let title: String
    let description: String
    let report_image: Image
    
    
    func abbreviatedDescription(_ text: String, limit: Int = 250) -> String {
        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            return String(text[..<index]) + "..."
        } else {
            return text
        }
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
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                
                Spacer()
                
                Image(systemName: "hand.thumbsup")
                    .imageScale(.large)
                    .foregroundStyle(.blue)
                
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.large)
                    .foregroundStyle(.blue)
            }
            
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
            
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
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    
                    Spacer()
                    
                    Image(systemName: "hand.thumbsup")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                    
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                }
                
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                
                Text(description)
                Text("Liga fraudulenta:").bold().foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
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
        
    }
}

struct ComponentReport_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComponentReport(
                user: "AnaTrailera300",
                user_image: Image(systemName: "person.circle"),
                title: "Estafa Venta de Coches",
                description: "El sitio detectado simula ser una página de compraventa de automóviles seminuevos, utilizando fotografías tomadas de portales legítimos para aparentar confiabilidad. La modalidad del fraude consiste en que los supuestos vendedores solicitan de manera insistente el pago anticipado del 50% del valor del automóvil, alegando que dicho anticipo es indispensable para “asegurar la reserva” o “cubrir los gastos de envío a domicilio”.",
                report_image: Image(systemName: "photo")
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
