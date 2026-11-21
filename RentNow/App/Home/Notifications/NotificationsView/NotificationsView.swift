//
//  NotificationsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct NotificationsView: View {

    // MARK: - Properties
    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: NotificationsViewModel

    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 0) {
                if viewModel.notifications.isEmpty {
                    emptyStateView
                } else {
                    notificationsListView
                }
            }
            .navigationTitle("notifications_title".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.notifications.isEmpty {
                        Button {
                            viewModel.promptDeleteAll()
                        } label: {
                            Text("notifications_delete_all".localized)
                                .expoSystemFont(size: FontSize.small, weight: .medium)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchNotifications()
            }
            .deleteConfirmationAlert(
                isPresented: $viewModel.showDeleteAllConfirmation,
                title: "notifications_delete_all_confirm_title".localized,
                message: "notifications_delete_all_confirm_message".localized,
                confirmButtonTitle: "notifications_delete_all_confirm_action".localized,
                onConfirm: {
                    viewModel.confirmDeleteAll()
                },
                onCancel: {
                    viewModel.cancelDelete()
                }
            )
            .deleteConfirmationAlert(
                isPresented: $viewModel.showDeleteSingleConfirmation,
                title: "notifications_delete_single_confirm_title".localized,
                message: "notifications_delete_single_confirm_message".localized,
                confirmButtonTitle: "delete".localized,
                onConfirm: {
                    viewModel.confirmDeleteSingle()
                },
                onCancel: {
                    viewModel.cancelDelete()
                }
            )
        }
    }

    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "bell.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("notifications_empty_title".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.white)

            Text("notifications_empty_message".localized)
                .expoSystemFont(size: FontSize.small, weight: .regular)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }

    // MARK: - Notifications List View
    private var notificationsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.notifications) { notification in
                    NotificationCardView(
                        notification: notification,
                        onTap: {
                            handleTap(notification)
                        },
                        onDelete: {
                            viewModel.promptDeleteSingle(notification)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .refreshable {
            await viewModel.fetchNotifications()
        }
    }

    // MARK: - Tap Routing
    private func handleTap(_ notification: NotificationItem) {
        guard
            let typeValue = notification.type,
            let notificationType = NotificationType(rawValue: typeValue),
            let itemId = notification.itemId
        else { return }

        if notificationType.isCustomerOrderType {
            coordinator.openOrderDetailsFromNotification(orderId: itemId)
        } else if notificationType.isProviderOrderType {
            coordinator.openCustomerOrderDetailsFromNotification(orderId: itemId)
        } else if notificationType.isAdvertisementType {
            coordinator.openMyAdDetailsFromNotification(adId: itemId, filterType: notificationType.adFilterType ?? .approved)
        }
        // Types 1, 2, 6 (complaint), 30–32 (account): no navigation from the list
    }
}

