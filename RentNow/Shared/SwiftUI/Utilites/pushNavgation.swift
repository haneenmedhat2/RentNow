//
//  pushNavgation.swift
//  Awfa
//
//  Created by Elshamy on 15/12/2024.
//

import Foundation
import UIKit
import SwiftUI
import SwiftUI

extension UINavigationController {
    /// Replace the root view with a SwiftUI view
    func setRootSwiftUIView<Content: View>(_ view: Content, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        if animated {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.setViewControllers([hostingController], animated: false)
            })
        } else {
            self.setViewControllers([hostingController], animated: false)
        }
    }

    /// Push a SwiftUI view onto the navigation stack
    func pushSwiftUIView<Content: View>(_ view: Content, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        self.pushViewController(hostingController, animated: animated)
    }

    /// Custom pop method for SwiftUI views
    func popSwiftUIView(animated: Bool = true) {
        self.popViewController(animated: animated)
    }
}
