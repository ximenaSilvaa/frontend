//
//  FilterTab.swift
//  TemplateReto451
//
//  Created by Claude on 26/09/25.
//

import SwiftUI

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : .brandPrimary)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: [Color.brandAccent, Color.brandAccent.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color.white
                        }
                    }
                )
                .cornerRadius(25)
                .shadow(
                    color: isSelected ? Color.brandAccent.opacity(0.3) : Color.black.opacity(0.1),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: isSelected ? 4 : 2
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? Color.clear : Color.brandSecondary.opacity(0.3), lineWidth: 1.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    HStack(spacing: 16) {
        FilterTab(title: "Todos", isSelected: true, action: {})
        FilterTab(title: "Electrónica", isSelected: false, action: {})
        FilterTab(title: "Ropa", isSelected: false, action: {})
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}