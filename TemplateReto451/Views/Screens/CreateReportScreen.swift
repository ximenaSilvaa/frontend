//
//  CreateReportScreen.swift
//  Reto
//
//  Created by Ana Martinez on 19/09/25.
//

import SwiftUI
import PhotosUI

struct CreateReportScreen: View {
    @State private var reportTitle: String = ""
    @State private var reportDescription: String = ""
    @State private var reportURL: String = ""

    @State private var reportImage: Data? = nil
    @State private var selectedCategory: String? = nil

    let categories = ["Electródomesticos", "Muebles", "Ropa", "Electrónica", "Libros", "Juguetes", "Deportes"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("Crear reporte")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Título del reporte")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Divider()
                    TextField("Ej. Estafa de compra", text: $reportTitle)
                        .font(.body)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Adjuntar imagen")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Divider()
                    
                    HStack {
                        Spacer()
                        
                        PhotosPicker(
                            selection: Binding(
                                get: { nil },
                                set: { newItem in
                                    guard let item = newItem else { return }
                                    Task {
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                            reportImage = data
                                        }
                                    }
                                }
                            ),
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if let data = reportImage, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Categoría(s)")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Divider()
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
                        .padding(.vertical, 4)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Información")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Divider()
                    
                    TextField("Descripción", text: $reportDescription)
                        .font(.body)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("URL")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Divider()
                    TextField("Ej. https://pagina_estafa.com", text: $reportURL)
                        .font(.body)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {
                    // put bd
                }) {
                    Text("Crear reporte")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}


#Preview {
    CreateReportScreen()
}

