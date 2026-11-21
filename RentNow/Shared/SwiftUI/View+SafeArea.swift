//
//  View+SafeArea.swift
//  Holool
//
//  Created by Elshamy on 14/12/2025.
//

import SwiftUI

extension View {
    /// Gets the top safe area inset for the current window
    func getSafeAreaTop() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.top
    }
}
