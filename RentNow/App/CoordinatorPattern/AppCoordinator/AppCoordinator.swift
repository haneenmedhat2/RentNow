// AppCoordinator.swift
// Holool
// Created by Elshamy on 21/10/2025.

import SwiftUI
import Combine

// MARK: - App Flow State
enum AppFlowState: Equatable {
    case splash
    case intro
    case auth
    case locationPicker
    case main
}

// MARK: - App Coordinator
@MainActor
final class AppCoordinator: ObservableObject {

    // MARK: - Published State
    @Published var currentFlow: AppFlowState = .splash

    // MARK: - Child Coordinators
    @Published var authCoordinator: AuthCoordinator?
    @Published var tabBarCoordinator: TabBarCoordinator?

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Singleton for cross-tab navigation
    static var shared: AppCoordinator?

    init() {
        AppCoordinator.shared = self
        setupSessionManager()
    }

    private func setupSessionManager() {
        SessionManager.shared.sessionExpired
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.logout()
            }
            .store(in: &cancellables)
    }

    // MARK: - Flow Management

    func splashCompleted() {
        print("🚀 splashCompleted called - isFirstTime: \(UserDefaults.isFirstTime)")
        checkLanguageChange()
        if UserDefaults.isFirstTime {
            print("🚀 Going to IntroView")
            showIntro()
        } else {
            print("🚀 Going to handleNextFlow")
            handleNextFlow()
        }
    }

    private func checkLanguageChange() {
        let currentLang = String(Language.currentLanguage().prefix(2)).lowercased()
        let savedLang = UserDefaults.savedLanguage

        if !savedLang.isEmpty, savedLang != currentLang,
           UserDefaults.isLogin, let token = UserDefaults.accessToken, !token.isEmpty {
            let apiLang = currentLang == "ar" ? "Ar" : "En"
            Task {
                let endpoint = MoreEndpoint.changeLanguage(language: apiLang)
                let handler = DefaultResponseHandler()
                let _ = try? await handler.get(endpoint)
            }
        }
        UserDefaults.savedLanguage = currentLang
    }

    func showIntro() {
        currentFlow = .intro
    }

    func introCompleted() {
        showAuth()
    }

    func handleNextFlow() {
        if UserDefaults.isLogin {
           
                showMain()
            
        } else if UserDefaults.isVisitor {
            showMain()
        } else {
            showAuth()
        }
    }

    func showAuth() {
        tabBarCoordinator = nil
        authCoordinator = AuthCoordinator()
        authCoordinator?.onFinish = { [weak self] in
            self?.handleNextFlow()
        }
        currentFlow = .auth
    }

    func showMain() {
        authCoordinator = nil
        tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator?.onFinish = { [weak self] in
            self?.showAuth()
        }
        currentFlow = .main
    }

 

    func logout() {
        tabBarCoordinator = nil
        authCoordinator = nil
        showAuth()
    }

    // MARK: - Root View Builder
    @ViewBuilder
    func buildRootView() -> some View {
        switch currentFlow {
        case .splash:
            SplashView(onFinish: {
                self.splashCompleted()
            })

        case .intro:
            IntroView(onFinish: {
                self.introCompleted()
            })

        case .auth:
            if let authCoordinator = authCoordinator {
                AuthFlowView(coordinator: authCoordinator)
            }

        case .locationPicker:
            if let authCoordinator = authCoordinator {
                authCoordinator.buildLocationPickerFlow()
            }

        case .main:
            if let tabBarCoordinator = tabBarCoordinator {
                TabBarFlowView(coordinator: tabBarCoordinator)
            }
        }
    }
}

// MARK: - Auth Flow Wrapper View
/// This wrapper ensures SwiftUI observes AuthCoordinator's @Published properties
struct AuthFlowView: View {
    @ObservedObject var coordinator: AuthCoordinator

    var body: some View {
        coordinator.buildAuthFlow()
            .logViewAppearance(viewName: "AuthFlowView")
    }
}

// MARK: - TabBar Flow Wrapper View
/// This wrapper ensures SwiftUI observes TabBarCoordinator's @Published properties
struct TabBarFlowView: View {
    @ObservedObject var coordinator: TabBarCoordinator

    var body: some View {
        coordinator.buildTabBarView()
            .logViewAppearance(viewName: "TabBarFlowView")
    }
}
