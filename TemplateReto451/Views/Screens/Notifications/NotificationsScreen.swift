//
//  NotificationsScreen.swift
//  TemplateReto451
//
//  Created by Claude on 17/09/25.
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
                    Text("Notificaciones")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.brandPrimary)
                        .padding(.top, 20)

                    if vm.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else if vm.notifications.isEmpty {
                        
                        Spacer()

                        VStack(spacing: 12) {
                            Image(systemName: "bell.slash")
                                .font(.system(size: 70))
                                .foregroundColor(.gray.opacity(0.5))

                            Text("No tienes notificaciones aún")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }

                        Spacer()
                    } else {ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.notifications, id: \.id) { notification in
                                    NotificationRowComponent(notification: notification) {
                                        selectedNotification = notification
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.top, 10)
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
