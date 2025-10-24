//
//  CategoryDropdown.swift
//  TemplateReto451
//
//  Created by Claude on 24/10/25.
//

import SwiftUI

struct CategoryDropdown: View {
    let categories: [CategoryDTO]
    @Binding var selectedCategoryIds: Set<Int>
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Categorías")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.brandPrimary)

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.brandSecondary.opacity(0.6))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 16)

            Divider()
                .background(Color.brandSecondary.opacity(0.2))

            // Clear Selection Option
            if !selectedCategoryIds.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedCategoryIds.removeAll()
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.brandAccent)

                        Text("Limpiar selección")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.brandPrimary)

                        Spacer()

                        Text("\(selectedCategoryIds.count)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.brandAccent)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(Color.brandAccent.opacity(0.08))
                }
                .buttonStyle(PlainButtonStyle())

                Divider()
                    .background(Color.brandSecondary.opacity(0.2))
            }

            // Category List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(categories) { category in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if selectedCategoryIds.contains(category.id) {
                                    selectedCategoryIds.remove(category.id)
                                } else {
                                    selectedCategoryIds.insert(category.id)
                                }
                            }
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: selectedCategoryIds.contains(category.id) ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(selectedCategoryIds.contains(category.id) ? .brandAccent : .brandSecondary.opacity(0.3))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(category.name)
                                        .font(.system(size: 17, weight: selectedCategoryIds.contains(category.id) ? .semibold : .medium))
                                        .foregroundColor(.brandPrimary)

                                    if !category.description.isEmpty {
                                        Text(category.description)
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(.brandSecondary.opacity(0.7))
                                    }
                                }

                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                selectedCategoryIds.contains(category.id)
                                    ? Color.brandAccent.opacity(0.08)
                                    : Color.clear
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        if category.id != categories.last?.id {
                            Divider()
                                .background(Color.brandSecondary.opacity(0.1))
                                .padding(.leading, 64)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            // Apply Button
            Divider()
                .background(Color.brandSecondary.opacity(0.2))

            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }) {
                HStack(spacing: 10) {
                    Text(selectedCategoryIds.isEmpty ? "Ver todos los reportes" : "Aplicar filtros")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    if !selectedCategoryIds.isEmpty {
                        Text("(\(selectedCategoryIds.count))")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color.brandAccent, Color.brandPrimary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.brandAccent.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedIds: Set<Int> = [1]
        @State private var isPresented: Bool = true

        var body: some View {
            CategoryDropdown(
                categories: [
                    CategoryDTO(id: 1, name: "Estafa", description: "Reportes de estafa"),
                    CategoryDTO(id: 2, name: "Phishing", description: "Reportes de phishing"),
                    CategoryDTO(id: 3, name: "Malware", description: "Reportes de malware"),
                    CategoryDTO(id: 4, name: "Fraude", description: "Reportes de fraude")
                ],
                selectedCategoryIds: $selectedIds,
                isPresented: $isPresented
            )
        }
    }

    return PreviewWrapper()
}
