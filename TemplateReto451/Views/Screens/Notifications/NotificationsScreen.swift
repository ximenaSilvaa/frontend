//
//  NotificationsScreen.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 17/09/25.
//

import SwiftUI


struct NotificationsScreen: View {
    @StateObject private var vm = NotificationsViewModel()
    @State private var selectedNotification: NotificationDTO? = nil
    

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Notificaciones")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.brandPrimary)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                    if vm.isLoading {
                        Spacer()
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Cargando notificaciones...")
                                .font(.system(size: 16))
                                .foregroundColor(.brandSecondary)
                        }
                        Spacer()
                    } else if vm.notifications.isEmpty {
                        Spacer()

                        VStack(spacing: 16) {
                            Image(systemName: "bell.slash.fill")
                                .font(.system(size: 70))
                                .foregroundColor(Color.brandSecondary.opacity(0.6))

                            Text("No tienes notificaciones")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.brandPrimary)

                            Text("Cuando recibas actualizaciones importantes, aparecerán aquí")
                                .font(.system(size: 14))
                                .foregroundColor(.brandSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }

                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.notifications, id: \.id) { notification in
                                    NotificationRowComponent(notification: notification) {
                                        selectedNotification = notification
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 40)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .task {
                await vm.fetchNotifications()
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedNotification) { notification in
            NotificationDetailScreen(notification: notification)
        }
    }
}



#Preview {
    NotificationsScreen()
}
