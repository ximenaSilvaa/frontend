//
//  HomeScreen.swift
//  TemplateReto451
//
//  Created by José Molina on 09/09/25.
//
import SwiftUI

struct HomeScreen: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String? = nil
    
    //bd
    let categories = ["Electródomesticos", "Muebles", "Ropa", "Electrónica", "Libros", "Juguetes", "Deportes"]
    
    let reports = [
        (
            user: "AnaTellez",
            user_image: Image("userprofile"),
            title: "Estafa Venta de Coches",
            description: "El sitio detectado simula ser una página de compraventa de automóviles seminuevos, utilizando fotografías tomadas de portales legítimos para aparentar confiabilidad. La modalidad del fraude consiste en que los supuestos vendedores solicitan de manera insistente el pago anticipado del 50% del valor del automóvil, alegando que dicho anticipo es indispensable para \"asegurar la reserva\" o \"cubrir los gastos de envío a domicilio\".",
            report_image: Image("reporsample"),
            category: "Electrodomésticos"
        ),
        (
            user: "JuanPérez",
            user_image: Image("userprofile2"),
            title: "Alerta de Fraude",
            description: "Página fraudulenta que busca engañar a los usuarios haciéndose pasar por un sitio legítimo. Solicita datos personales, información bancaria y hasta pagos por adelantado con la promesa de servicios o productos que nunca se entregan. El sitio utiliza mensajes de urgencia y promociones falsas para presionar a las personas y lograr que compartan su información sensible. Se recomienda no proporcionar ningún dato ni realizar transferencias, ya que todo es parte de un esquema de estafa.",
            report_image: Image("reporsample2"),
            category: "Muebles"
        )
    ]
    
    var body: some View {
        VStack {
            
            Spacer().frame(height: 15)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Buscar", text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(8)
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                FilterTab(
                                    title: category,
                                    isSelected: selectedCategory == category,
                                    action: {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 60)
                    
                    
                    VStack(spacing: 20) {
                        ForEach(reports, id: \.title) { report in
                            ComponentReport(
                                user: report.user,
                                user_image: report.user_image,
                                title: report.title,
                                description: report.description,
                                report_image: report.report_image
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
    }
    
}
