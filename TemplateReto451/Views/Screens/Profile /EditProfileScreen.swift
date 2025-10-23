//
//  EditProfileScreen.swift
//  TemplateReto451
//
//  Created by User on 18/09/25.
//

import SwiftUI
import PhotosUI

struct EditProfileScreen: View {
    @Binding var userProfile: UserProfileDTO
    @Environment(\.presentationMode) var presentationMode

    private let httpClient = HTTPClient()

    @State private var editedName: String = ""
    @State private var editedUsername: String = ""
    @State private var editedEmail: String = ""
    @State private var showingSavedAlert = false
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showingErrorAlert = false
    @State private var isLoadingData = true
    @State private var fetchedUserData: UserResponse?

    // Image picker states
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        ZStack {
            Color.gray.opacity(0.05)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header with back arrow
                    HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color.brandPrimary)
                    }
                    .padding(.leading)

                    Spacer()

                    Text("Editar perfil")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.brandPrimary)

                    Spacer()

                    // Invisible spacer to center the title
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .opacity(0)
                        .padding(.trailing)
                }
                .padding(.top)

                // Profile Image Section
                VStack(spacing: 8) {
                    // Display profile image with priority: selectedImage > fetchedUserData > default
                    Group {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else if let userData = fetchedUserData, !userData.image_path.isEmpty {
                            AsyncImage(url: URL(string: URLEndpoints.server + "/" + userData.image_path)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(Color.brandPrimary)
                                @unknown default:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(Color.brandPrimary)
                                }
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color.brandPrimary)
                        }
                    }

                    Button(action: {
                        showActionSheet = true
                    }) {
                        Text("Editar foto")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.brandAccent)
                    }
                }
                .padding(.bottom, 20)

                // Form Fields
                VStack(spacing: 18) {
                    // Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.brandPrimary)

                        TextField("", text: $editedName)
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

                    // Username Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Usuario")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.brandPrimary)

                        TextField("", text: $editedUsername)
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

                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.brandPrimary)

                        TextField("", text: $editedEmail)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.brandSecondary.opacity(0.2), lineWidth: 1.5)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 40)

                // Save Button
                Button(action: {
                    Task {
                        await saveProfile()
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("Guardar cambios")
                            .font(.system(size: 16, weight: .bold))
                        if isSaving {
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
                .disabled(isSaving)
                .opacity(isSaving ? 0.7 : 1.0)
                .padding(.horizontal)
                .padding(.bottom, 30)
                }
            }
            .opacity(isLoadingData ? 0.5 : 1.0)
            .disabled(isLoadingData)

            // Loading overlay
            if isLoadingData {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.brandAccent))
                    Text("Cargando...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Fetch fresh data from backend
            Task {
                await fetchUserProfile()
            }
        }
        .alert("Perfil guardado", isPresented: $showingSavedAlert) {
            Button("OK", role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Ocurrió un error al guardar el perfil")
        }
        .confirmationDialog("Seleccionar foto", isPresented: $showActionSheet) {
            Button("Cámara") {
                imageSourceType = .camera
                showImagePicker = true
            }
            Button("Galería") {
                imageSourceType = .photoLibrary
                showImagePicker = true
            }
            Button("Cancelar", role: .cancel) { }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: imageSourceType)
        }
    }

    // MARK: - Private Methods

    private func fetchUserProfile() async {
        isLoadingData = true
        errorMessage = nil

        do {
            let userData = try await httpClient.getUserProfile()

            await MainActor.run {
                fetchedUserData = userData
                editedName = userData.name
                editedUsername = userData.username
                editedEmail = userData.email
                isLoadingData = false
            }

        } catch let error as NetworkError {
            await MainActor.run {
                errorMessage = error.errorDescription
                showingErrorAlert = true
                isLoadingData = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error al cargar datos: \(error.localizedDescription)"
                showingErrorAlert = true
                isLoadingData = false
            }
        }
    }

    private func saveProfile() async {
        isSaving = true
        errorMessage = nil

        do {
            // Compare against fetched data to detect changes
            guard let originalData = fetchedUserData else {
                await MainActor.run {
                    errorMessage = "No hay datos originales para comparar"
                    showingErrorAlert = true
                    isSaving = false
                }
                return
            }

            // Handle image upload if image was changed
            var uploadedImagePath: String? = nil
            if let selectedImage = selectedImage {
                // Compress image to ensure it's under 1MB
                guard let imageData = compressImage(selectedImage, maxSizeInBytes: 1_000_000) else {
                    await MainActor.run {
                        errorMessage = "No se pudo procesar la imagen"
                        showingErrorAlert = true
                        isSaving = false
                    }
                    return
                }

                // Upload image to server
                uploadedImagePath = try await httpClient.uploadProfileImage(imageData: imageData)
            }

            // Detect changes
            let nameChanged = editedName != originalData.name
            let usernameChanged = editedUsername != originalData.username
            let emailChanged = editedEmail != originalData.email
            let imageChanged = uploadedImagePath != nil

            // Check if there are any changes
            if !nameChanged && !usernameChanged && !emailChanged && !imageChanged {
                await MainActor.run {
                    isSaving = false
                    showingSavedAlert = true
                }
                return
            }

            // Only send fields that actually changed (backend filters undefined values)
            let nameToSend = nameChanged ? editedName : nil
            let usernameToSend = usernameChanged ? editedUsername : nil
            let emailToSend = emailChanged ? editedEmail : nil

            // Call the API - send only changed fields
            let updatedUser = try await httpClient.updateUserProfile(
                name: nameToSend,
                email: emailToSend,
                username: usernameToSend,
                imagePath: uploadedImagePath
            )

            // Update the local userProfile with the response from the server
            await MainActor.run {
                userProfile = UserProfileDTO(
                    username: updatedUser.username,
                    name: updatedUser.name,
                    location: userProfile.location,
                    email: updatedUser.email,
                    profileImage: userProfile.profileImage,
                    stats: userProfile.stats
                )

                isSaving = false
                showingSavedAlert = true
            }

        } catch let error as NetworkError {
            await MainActor.run {
                errorMessage = error.errorDescription
                showingErrorAlert = true
                isSaving = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error desconocido: \(error.localizedDescription)"
                showingErrorAlert = true
                isSaving = false
            }
        }
    }

    private func compressImage(_ image: UIImage, maxSizeInBytes: Int) -> Data? {
        var compression: CGFloat = 0.9
        let minCompression: CGFloat = 0.1
        let step: CGFloat = 0.1

        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return nil
        }

        // If already under max size, return it
        if imageData.count <= maxSizeInBytes {
            return imageData
        }

        // Try progressively lower quality
        while imageData.count > maxSizeInBytes && compression > minCompression {
            compression -= step
            guard let compressedData = image.jpegData(compressionQuality: compression) else {
                return nil
            }
            imageData = compressedData
        }

        // If still too large, resize the image
        if imageData.count > maxSizeInBytes {
            let ratio = sqrt(CGFloat(maxSizeInBytes) / CGFloat(imageData.count))
            let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)

            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            guard let finalImage = resizedImage,
                  let finalData = finalImage.jpegData(compressionQuality: 0.8) else {
                return nil
            }

            return finalData
        }

        return imageData
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    @Previewable @State var sampleProfile = UserProfileDTO.sample
    NavigationView {
        EditProfileScreen(userProfile: $sampleProfile)
    }
}
