//
//  ComponentReportSmall.swift
//  TemplateReto451
//
//  Created by User on 18/09/25.
//

import SwiftUI

struct ComponentReportSmall: View {
    let user: String
    let user_image: Image
    let title: String
    let description: String

    func abbreviatedDescription(_ text: String, limit: Int = 100) -> String {
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

            NavigationLink(destination: Report(
                user: user,
                user_image: user_image,
                title: title,
                description: description,
                report_image: Image("reporsample"),
                url: "https://tevoyaestafar.com/coches"
            )) {
                Text("Mostrar más")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .frame(width: 350)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct ComponentReportSmall_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComponentReportSmall(
                user: "AnaTellez300",
                user_image: Image("userprofile"),
                title: "Estafa venta Coches.com",
                description: "El sitio detectado simula ser una página de compraventa de automóviles seminuevos, utilizando fotografías tomadas de portales legítimos para aparentar confiabilidad. La modalidad del fraude consiste en que los supuestos vendedores solicitan de manera insistente el pago anticipado del 50% del valor del automóvil, alegando que dicho anticipo es indispensable para \"asegurar la reserva\" o \"cubrir los gastos de envío a domicilio\".",
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
