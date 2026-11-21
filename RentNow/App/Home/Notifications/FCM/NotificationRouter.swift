//
//  NotificationRouter.swift
//  RentNow
//
//  Created on 18/03/2026.
//

import Foundation

// MARK: - Notification Type (from backend)
enum NotificationType: Int {
    case addingServiceProvider = 1
    case notifyFromDashboard = 2
    case advertisementApproved = 3
    case advertisementRejected = 4
    case advertisementApprovedWithEdits = 5
    case complaintResponse = 6
    // Order Cycle
    case orderCreated = 10
    case orderAccepted = 11
    case orderRejected = 12
    case orderEditedAndAccepted = 13
    case orderPaid = 14
    case orderHandoverConfirmed = 15
    case orderReturnConfirmed = 16
    case orderCompleted = 17
    case orderCompletedAfterIncident = 18
    case orderCancelled = 19
    case orderIncidentReported = 20
    case orderRated = 21
    case orderExceededKilometersPaid = 22
    case orderOverlappingRejected = 23
    // Account
    case accountActivated = 30
    case accountDeactivated = 31
    case accountDeleted = 32

    var isOrderType: Bool {
        rawValue >= 10 && rawValue <= 23
    }

    var isCustomerOrderType: Bool {
        switch self {
        case .orderAccepted,
             .orderRejected,
             .orderEditedAndAccepted,
             .orderHandoverConfirmed,
             .orderReturnConfirmed,
             .orderCompleted,
             .orderCompletedAfterIncident,
             .orderCancelled,
             .orderOverlappingRejected:
            return true
        default:
            return false
        }
    }

    var isProviderOrderType: Bool {
        switch self {
        case .orderCreated,
             .orderPaid,
             .orderIncidentReported,
             .orderRated,
             .orderExceededKilometersPaid:
            return true
        default:
            return false
        }
    }

    var isAdvertisementType: Bool {
        rawValue >= 3 && rawValue <= 5
    }

    var isComplaintType: Bool {
        self == .complaintResponse
    }

    var isAccountType: Bool {
        rawValue >= 30 && rawValue <= 32
    }

    var adFilterType: MyAdFilterType? {
        switch self {
        case .advertisementApproved, .advertisementApprovedWithEdits:
            return .approved
        case .advertisementRejected:
            return .rejectedWithNotes
        default:
            return nil
        }
    }
}

enum FCMValueKeys: String {
    case type
    case itemId
}

enum NotificationPresentationContext {
    case foreground
    case background
    case tap
}

@MainActor
final class NotificationRouter {
    static let shared = NotificationRouter()
    private init() {}

    func handle(userInfo: [AnyHashable: Any], presentationContext: NotificationPresentationContext) {
        // Parse type
        let typeValue: Int? = {
            if let intVal = userInfo[AnyHashable(FCMValueKeys.type.rawValue)] as? Int {
                return intVal
            }
            if let strVal = userInfo[AnyHashable(FCMValueKeys.type.rawValue)] as? String {
                return Int(strVal)
            }
            return nil
        }()

        let notificationType = typeValue.flatMap(NotificationType.init(rawValue:))

        // Parse single `itemId` key used for all entity types
        let itemId: Int? = {
            if let strVal = userInfo[AnyHashable(FCMValueKeys.itemId.rawValue)] as? String {
                return Int(strVal)
            }
            if let intVal = userInfo[AnyHashable(FCMValueKeys.itemId.rawValue)] as? Int {
                return intVal
            }
            return nil
        }()

        // Foreground/background: post refresh notifications so any open
        // details screen can silently reload if its id matches.
        if presentationContext == .foreground || presentationContext == .background {
            if let notificationType, let itemId {
                if notificationType.isOrderType {
                    NotificationCenter.default.post(
                        name: .orderStatusChanged,
                        object: nil,
                        userInfo: ["order_id": itemId]
                    )
                } else if notificationType.isAdvertisementType {
                    NotificationCenter.default.post(
                        name: .advertisementStatusChanged,
                        object: nil,
                        userInfo: ["advertisement_id": itemId]
                    )
                }
            }
            return
        }

        // Tap: navigate via coordinators
        guard let tabBar = AppCoordinator.shared?.tabBarCoordinator else { return }

        guard let notificationType else {
            navigateToNotifications(tabBar: tabBar)
            return
        }

        if notificationType.isAccountType {
            // Account events (30–32): no navigation
            return
        }

        if notificationType.isCustomerOrderType, let itemId {
            tabBar.ordersCoordinator.popToRoot()
            tabBar.selectedTab = .orders
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tabBar.ordersCoordinator.showOrderDetails(orderId: itemId)
            }
        } else if notificationType.isProviderOrderType, let itemId {
            tabBar.moreCoordinator.popToRoot()
            tabBar.selectedTab = .more
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Push the list first, then details, so tapping Back from
                // the details screen lands on CustomerOrdersView.
                tabBar.moreCoordinator.path = [
                    .customerOrders,
                    .customerOrderDetails(orderId: itemId)
                ]
            }
        } else if notificationType.isAdvertisementType, let itemId, let filterType = notificationType.adFilterType {
            tabBar.moreCoordinator.popToRoot()
            tabBar.selectedTab = .more
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tabBar.moreCoordinator.showMyAdDetails(adId: itemId, filterType: filterType)
            }
        } else if notificationType.isComplaintType, let itemId {
            tabBar.moreCoordinator.popToRoot()
            tabBar.selectedTab = .more
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tabBar.moreCoordinator.showComplaintDetails(complaintId: itemId)
            }
        } else {
            // addingServiceProvider (1), notifyFromDashboard (2) → notifications list
            navigateToNotifications(tabBar: tabBar)
        }
    }

    private func navigateToNotifications(tabBar: TabBarCoordinator) {
        tabBar.homeCoordinator.popToRoot()
        tabBar.selectedTab = .home
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tabBar.homeCoordinator.showNotifications()
        }
    }
}
