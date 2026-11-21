//
//  AppDelegateBridge.swift
//  One Click
//
//  Created by Mohamed Elmemy on 18/08/2025.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

final class AppDelegateBridge: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Configure Firebase
        if FirebaseApp.app() == nil { FirebaseApp.configure() }
        
        // Set delegates
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        // Request notification authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, err in
            print("🔔 Permission granted:", granted, "error:", String(describing: err))
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                print("📬 Called registerForRemoteNotifications()")
            }
        }
        
        // Reset badge number on launch
        UIApplication.shared.applicationIconBadgeNumber = 0

        return true
    }

    // MARK: - APNs token
    @objc func application(_ application: UIApplication,
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let hex = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("✅ APNs HEX token:", hex, "len:", deviceToken.count)
#if DEBUG
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
#else
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
#endif
    }
    
    @objc func application(_ application: UIApplication,
                           didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ APNs register failed:", error.localizedDescription)
        UNUserNotificationCenter.current().getNotificationSettings { s in
            print("🔎 Auth status:", s.authorizationStatus.rawValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("🔎 isRegisteredForRemoteNotifications:", UIApplication.shared.isRegisteredForRemoteNotifications)
        }
    }
    
    // MARK: - FCM token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken, !token.isEmpty else {
            print("🔥 FCM token delegate called but empty")
            return
        }
        print("🔥 FCM token (delegate): \(token)")
        UserDefaults.pushNotificationToken = token
        NotificationManager.shared.updateTokenFromDelegate(token)
    }
    
    // MARK: - Silent/background data push
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] { print("Message ID:", messageID) }
        print("Remote userInfo (bg):", userInfo)
        NotificationRouter.shared.handle(userInfo: userInfo, presentationContext: .background)
        
        // Update badge: increase by 1 if not provided
        if let badge = userInfo["badge"] as? Int {
            UIApplication.shared.applicationIconBadgeNumber = badge
        } else {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
        
        completionHandler(.newData)
    }
    
    // MARK: - Foreground presentation
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] { print("Message ID:", messageID) }
        print("Remote userInfo (fg):", userInfo)
        NotificationRouter.shared.handle(userInfo: userInfo, presentationContext: .foreground)
        
        // Update badge
        if let badgeNumber = notification.request.content.badge as? Int {
            UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        } else {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
        
        completionHandler([.banner, .sound])
    }
    
    // MARK: - User tapped notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] { print("Message ID:", messageID) }
        print("Remote userInfo (tap):", userInfo)
        NotificationRouter.shared.handle(userInfo: userInfo, presentationContext: .tap)
        
        completionHandler()
    }
    
    // MARK: - Utility: reset badge
    func resetBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

 
