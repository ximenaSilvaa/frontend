//
//  ComponentCategory.swift
//  Reto
//
//  Created by Ana Martinez on 16/09/25.
//

import SwiftUI

struct ComponentCategory: View {
    let name: String
    @State private var isSelected: Bool = false
    
    var body: some View {
        Text(name)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? Color.white : Color.black)
            .cornerRadius(20)
            .onTapGesture {
                isSelected.toggle()
            }
    }
}
    struct ComponentCategory_Previews: PreviewProvider {
        static var previews: some View {
            ComponentCategory(name: "Eléctródomesticos")
        }
    }

