//
//  CreateReportScreen.swift
//  Reto
//
//  Created by Ana Martinez on 19/09/25.
//
import SwiftUI
import PhotosUI

struct CreateReportScreen: View {
    @StateObject private var viewModel = CreateReportViewModel()

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
                    TextField("Ej. Estafa de compra", text: $viewModel.title)
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
                                    Task { @MainActor in
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                            viewModel.imageData = data
                                        }
                                    }
                                }
                            ),
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if let uiImage = MainActor.assumeIsolated({
                                viewModel.imageData.flatMap { UIImage(data: $0) }
                            }) {
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
                    
                    if viewModel.isLoading {
                        ProgressView("Cargando categorías...")
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.categories) { category in
                                    FilterTab(
                                        title: category.name,
                                        isSelected: viewModel.selectedCategoryId == category.id,
                                        action: {
                                            viewModel.selectedCategoryId =
                                                viewModel.selectedCategoryId == category.id ? nil : category.id
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Información. Descripción")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Divider()
                    
                    TextEditor(text: $viewModel.description)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5)))
                }

  
                VStack(alignment: .leading, spacing: 8) {
                    Text("URL (opcional)")
                        .font(.title2)
                        .foregroundColor(Color(red: 4/255, green: 9/255, blue: 69/255))
                    Divider()
                    TextField("Ej. https://pagina_estafa.com", text: $viewModel.reportURL)
                        .font(.body)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button(action: { viewModel.isAnonymousPreferred.toggle() }) {
                            Image(systemName: viewModel.isAnonymousPreferred ? "checkmark.square.fill" : "square")
                                .foregroundColor(viewModel.isAnonymousPreferred ? Color.brandAccent : Color.gray)
                                .font(.title2)
                        }
                        Text("Enviar reporte como anónimo")
                            .font(.title2)
                            .foregroundColor(Color.brandPrimary)
                            .onTapGesture {
                                viewModel.isAnonymousPreferred.toggle()
                            }
                        Spacer()
                    }
                }

        
                Button(action: {
                    Task {
                        await viewModel.createReport()
                    }
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
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Creando reporte...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .alert(viewModel.alertMessage ?? "", isPresented: $viewModel.showAlert) {
            Button("OK") { viewModel.showAlert = false }
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}


#Preview {
    CreateReportScreen()
}
