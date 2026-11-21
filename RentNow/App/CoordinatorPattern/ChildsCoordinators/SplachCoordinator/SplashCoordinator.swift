//
//  SplashCoordinator.swift
//  Holool
//
//  Created by Elshamy on 21/10/2025.
//

import SwiftUI

// MARK: - Splash Coordinator
// Note: Splash is now handled directly in AppCoordinator.buildRootView()
// This file is kept for reference but the splash flow is state-driven

enum SplashRoute: Hashable {
    case splash
}

@MainActor
final class SplashCoordinator: BaseCoordinator<SplashRoute> {

    override init() {
        super.init()
    }

    @ViewBuilder
    func buildSplashView(onComplete: @escaping () -> Void) -> some View {
        SplashView()
    }
}



