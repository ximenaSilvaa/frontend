//
//  ComponentNavbar.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 19/09/25.
//

import SwiftUI

struct ComponentNavbar: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen()
            }
            .tabItem {
                Label("Inicio", systemImage: "house")
            }

            NavigationStack {
                NotificationsScreen()
            }
            .tabItem {
                Label("Notificaciones", systemImage: "bell")
            }
            NavigationStack {
                CreateReportScreen()
            }
            .tabItem {
                Label("Agregar", systemImage: "plus.app.fill")
            }

            NavigationStack {
                Text("Estadísticas")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .tabItem {
                Label("Estadísticas", systemImage: "chart.bar")
            }

            NavigationStack {
                ProfileScreen()
            }
            .tabItem {
                Label("Perfil", systemImage: "person")
            }
        }
        .onAppear {
            // Configure tab bar appearance to dark blue
            let appearance = UITabBarAppearance()
        
            // Use configureWithOpaqueBackground for solid appearance
            appearance.configureWithOpaqueBackground()
                        
            // Set clean white/light gray background
            appearance.backgroundColor = UIColor.systemBackground
            
            // Selected item color (blue accent)
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            
            // Unselected item color (gray)
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
            
            // Apply the appearance
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
                       
            
            
        }
    }
}

#Preview {
    ComponentNavbar()
}

