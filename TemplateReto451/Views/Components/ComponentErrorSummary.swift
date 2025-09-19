//
//  ComponentErrorSummary.swift
//  TemplateReto451
//
//  Created by José Molina on 26/08/25.
//

import SwiftUI

struct ComponentErrorSummary: View {
    
    let errors:[String]
    var body: some View {
        Text("Errores encontrados")
            .font(.headline)
            .foregroundColor(.red)
        List(errors, id: \.self) { error in
            Text("❌ \(error)")
                .foregroundStyle(.red)

        }
    }
}

#Preview {
    ComponentErrorSummary(errors: ["Error 1", "Error 2"])
}
