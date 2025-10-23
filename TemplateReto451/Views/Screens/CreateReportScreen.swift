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
        ZStack {
            Color.gray.opacity(0.05)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Crear reporte")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.brandPrimary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Título del reporte")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.brandPrimary)

                    TextField("Ej. Estafa de compra", text: $viewModel.title)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Adjuntar imagen")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.brandPrimary)

                    HStack {
                        Spacer()
                        PhotosPicker(
                            selection: Binding(
                                    get: { nil },
                                    set: { newItem in
                                        guard let item = newItem else { return }
                                        Task {
                                            if let data = try? await item.loadTransferable(type: Data.self) {
                                                viewModel.processImageData(data)
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
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.brandAccent.opacity(0.2), lineWidth: 1.5)
                                    )
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color.brandSecondary)
                                    Text("Toca para seleccionar imagen")
                                        .font(.caption)
                                        .foregroundColor(Color.brandSecondary)
                                }
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
                                )
                            }
                        }
                        Spacer()
                    }
                }


                VStack(alignment: .leading, spacing: 8) {
                    Text("Categoría(s)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.brandPrimary)

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
                    Text("Descripción")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.brandPrimary)

                    ZStack(alignment: .topLeading) {
                        if viewModel.description.isEmpty {
                            Text("Describe el reporte detalladamente...")
                                .foregroundColor(Color.gray.opacity(0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 18)
                        }
                        TextEditor(text: $viewModel.description)
                            .frame(height: 120)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .scrollContentBackground(.hidden)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
                            )
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("URL (opcional)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.brandPrimary)

                    TextField("Ej. https://pagina_estafa.com", text: $viewModel.reportURL)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
                        )
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }

                HStack(spacing: 12) {
                    Button(action: { viewModel.isAnonymousPreferred.toggle() }) {
                        Image(systemName: viewModel.isAnonymousPreferred ? "checkmark.square.fill" : "square")
                            .foregroundColor(viewModel.isAnonymousPreferred ? Color.brandAccent : Color.gray.opacity(0.5))
                            .font(.system(size: 22))
                    }
                    Text("Enviar reporte como anónimo")
                        .font(.system(size: 14))
                        .foregroundColor(Color.brandSecondary)
                        .onTapGesture {
                            viewModel.isAnonymousPreferred.toggle()
                        }
                    Spacer()
                }


                Button(action: {
                    Task {
                        await viewModel.createReport()
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("Crear reporte")
                            .font(.system(size: 16, weight: .bold))
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [Color.brandAccent, Color.brandPrimary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.brandAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.7 : 1.0)
                .padding(.top)
            }
            .padding(.horizontal, 32)
            .padding(.bottom)
            }
        }

        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                LoadingView()
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
