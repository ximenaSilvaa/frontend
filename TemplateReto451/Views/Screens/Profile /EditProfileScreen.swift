//
//  EditProfileScreen.swift
//  TemplateReto451
//
//  Created by User on 18/09/25.
//

import SwiftUI

struct EditProfileScreen: View {
    @Binding var userProfile: UserProfileDTO
    @Environment(\.presentationMode) var presentationMode

    @State private var editedName: String = ""
    @State private var editedUsername: String = ""
    @State private var editedEmail: String = ""
    @State private var showingSavedAlert = false

    var body: some View {
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
                        .font(.title2)
                        .bold()
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
                    userProfile.profileImage
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .foregroundColor(Color.brandPrimary)

                    Text("Editar foto")
                        .font(.subheadline)
                        .foregroundColor(Color.brandAccent)
                }
                .padding(.bottom, 20)

                // Form Fields
                VStack(spacing: 20) {
                    // Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        TextField("", text: $editedName)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.brandSecondary.opacity(0.3), lineWidth: 1.5)
                            )
                            .font(.body)
                    }

                    Divider()

                    // Username Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Usuario")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        TextField("", text: $editedUsername)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.brandSecondary.opacity(0.3), lineWidth: 1.5)
                            )
                            .font(.body)
                    }

                    Divider()

                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        TextField("", text: $editedEmail)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.brandSecondary.opacity(0.3), lineWidth: 1.5)
                            )
                            .font(.body)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 40)

                // Save Button
                Button(action: {
                    // Update the user profile with edited values
                    userProfile = UserProfileDTO(
                        username: editedUsername.isEmpty ? userProfile.username : editedUsername,
                        name: editedName.isEmpty ? userProfile.name : editedName,
                        location: userProfile.location,
                        email: editedEmail.isEmpty ? userProfile.email : editedEmail,
                        profileImage: userProfile.profileImage,
                        stats: userProfile.stats
                    )

                    showingSavedAlert = true

                    // Dismiss after a brief delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Guardar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.brandAccent)
                        .cornerRadius(25)
                        .shadow(color: Color.brandAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Initialize editing fields with current values
            editedName = userProfile.name
            editedUsername = userProfile.username
            editedEmail = userProfile.email
        }
        .alert("Perfil guardado", isPresented: $showingSavedAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    @State var sampleProfile = UserProfileDTO.sample
    return NavigationView {
        EditProfileScreen(userProfile: $sampleProfile)
    }
}
