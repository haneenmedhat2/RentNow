//
//  NotificationManager.swift
//  One Click
//
//  Created by Mohamed Elmemy on 18/08/2025.
//

import SwiftUI
import UserNotifications
import Combine

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published var fcmToken: String?

    private init() {}

    func refreshSettings() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    func updateTokenFromDelegate(_ token: String?) {
        guard let token else { return }
        fcmToken = token
    }
}
