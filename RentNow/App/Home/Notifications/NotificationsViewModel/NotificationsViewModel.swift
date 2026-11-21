//
//  NotificationsViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Combine

@MainActor
final class NotificationsViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var notifications: [NotificationItem] = []
    @Published var showDeleteAllConfirmation: Bool = false
    @Published var showDeleteSingleConfirmation: Bool = false
    @Published var notificationToDelete: NotificationItem?

    // MARK: - Lifecycle
    init() {
        super.init()
    }

    // MARK: - API Methods

    /// Fetch notifications from API
    func fetchNotifications() async {
        guard !isLoading else { return }
        showIndicator()
        defer { hideIndicator() }
        let endpoint = HomeEndpoint.getNotifications()
        do {
            let response = try await request(endpoint)
            if let data = response {
                // Sort by date (newest first)
                notifications = data.sorted { first, second in
                    return first.date > second.date
                }
            } else {
                notifications = []
            }
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }
    }

    /// Delete all notifications
    func deleteAllNotifications() async {
        showIndicator()
        let endpoint = HomeEndpoint.deleteAllNotifications()
        do {
            let response = try await request(endpoint)
          
                notifications = []
                showToast(message: "notifications_delete_all_success".localized)
           
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    /// Delete single notification
    func deleteNotification(_ notification: NotificationItem) async {
        showIndicator()
        let endpoint = HomeEndpoint.deleteNotification(id: notification.id)
        do {
            let response = try await request(endpoint)
                // Remove from local list
                notifications.removeAll { $0.id == notification.id }
                showToast(message: "notifications_delete_single_success".localized)
            
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    // MARK: - Confirmation Methods

    /// Show delete all confirmation alert
    func promptDeleteAll() {
        showDeleteAllConfirmation = true
    }

    /// Show delete single confirmation alert
    func promptDeleteSingle(_ notification: NotificationItem) {
        notificationToDelete = notification
        showDeleteSingleConfirmation = true
    }

    /// Confirm and execute delete all
    func confirmDeleteAll() {
        showDeleteAllConfirmation = false
        Task {
            await deleteAllNotifications()
        }
    }

    /// Confirm and execute delete single
    func confirmDeleteSingle() {
        showDeleteSingleConfirmation = false
        if let notification = notificationToDelete {
            Task {
                await deleteNotification(notification)
            }
        }
        notificationToDelete = nil
    }

    /// Cancel delete operation
    func cancelDelete() {
        showDeleteAllConfirmation = false
        showDeleteSingleConfirmation = false
        notificationToDelete = nil
    }
}
