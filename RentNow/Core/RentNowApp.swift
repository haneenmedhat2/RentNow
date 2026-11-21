//
//  RentNowApp.swift
//  RentNow
//
//  Created by Elshamy on 21/01/2026.
//

import SwiftUI
import GoogleMaps

@main
struct RentNowApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    @UIApplicationDelegateAdaptor(AppDelegateBridge.self) var appDelegate
    @StateObject private var notifManager = NotificationManager.shared
    init() {
        TabbyConfiguration.setup()
        // Initialize Google Maps SDK
        GMSServices.provideAPIKey("AIzaSyAGb87ZWa8Ueip5TlfwcvGBp9hFmoptygc")
        UIRefreshControl.appearance().tintColor = UIColor(named: "Main")
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.buildRootView()
                .preferredColorScheme(.light)
        }
    }
}
