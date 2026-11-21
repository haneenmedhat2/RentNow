//
//  NoInternetAlertManager.swift
//  Holool
//
//  Created by Claude on 18/01/2026.
//

import UIKit
import SwiftUI

class NoInternetAlertManager {

    // MARK: - Properties
    static let shared = NoInternetAlertManager()
    private var alertWindow: UIWindow?
    private var isShowing = false

    // MARK: - Initializer
    private init() {}

    // MARK: - Show Alert
    func showNoInternetAlert(onRetry: (() -> Void)? = nil) {
        guard !isShowing else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })
            else { return }

            self.isShowing = true

            let alertWindow = UIWindow(windowScene: windowScene)
            alertWindow.windowLevel = .alert + 1
            alertWindow.backgroundColor = .clear

            let alertView = NoInternetAlertView(
                onRetry: onRetry,
                onDismiss: { [weak self] in
                    self?.dismissAlert()
                }
            )

            let hostingController = UIHostingController(rootView: alertView)
            hostingController.view.backgroundColor = .clear

            alertWindow.rootViewController = hostingController
            alertWindow.makeKeyAndVisible()

            self.alertWindow = alertWindow
        }
    }

    // MARK: - Dismiss Alert
    func dismissAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.alertWindow?.isHidden = true
            self.alertWindow?.rootViewController = nil
            self.alertWindow = nil
            self.isShowing = false
        }
    }
}
