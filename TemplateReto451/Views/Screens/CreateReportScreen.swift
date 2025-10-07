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
    @State private var selectedCategory: Int? = nil
    @State private var categories: [CategoryDTO] = []
    @State private var isLoadingCategories: Bool = false

    private let httpClient = HTTPClient()
    
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

                    if isLoadingCategories {
                        ProgressView("Cargando categorías...")
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories) { category in
                                    FilterTab(
                                        title: category.name,
                                        isSelected: selectedCategory == category.id,
                                        action: {
                                            selectedCategory = selectedCategory == category.id ? nil : category.id
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 4)
                        }
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
                        .background(Color.brandAccent.opacity(0.95))
                        .cornerRadius(20)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            Task {
                await loadCategories()
            }
        }
    }

    private func loadCategories() async {
        isLoadingCategories = true
        do {
            categories = try await httpClient.getCategories()
            isLoadingCategories = false
        } catch {
            print("Error loading categories: \(error)")
            isLoadingCategories = false
        }
    }
}


#Preview {
    CreateReportScreen()
}

