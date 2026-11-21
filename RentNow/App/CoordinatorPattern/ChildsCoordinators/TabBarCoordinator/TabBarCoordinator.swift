//
//  TabBarCoordinator.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI
import Combine

// MARK: - TabBar Coordinator
@MainActor
final class TabBarCoordinator: ObservableObject {

    // MARK: - Published State
    @Published var selectedTab: TabItem = .home

    // MARK: - Child Coordinators
    @Published var homeCoordinator: HomeCoordinator
    @Published var ordersCoordinator: OrdersCoordinator
    @Published var addAdCoordinator: AddAdCoordinator
    @Published var walletCoordinator: WalletCoordinator
    @Published var moreCoordinator: MoreCoordinator

    // MARK: - Callbacks
    var onFinish: (() -> Void)?

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private var previousTab: TabItem = .home

    // MARK: - Init
    init() {
        self.homeCoordinator = HomeCoordinator()
        self.ordersCoordinator = OrdersCoordinator()
        self.addAdCoordinator = AddAdCoordinator()
        self.walletCoordinator = WalletCoordinator()
        self.moreCoordinator = MoreCoordinator()

        setupChildCallbacks()
    }

    // MARK: - Setup
    private func setupChildCallbacks() {
        // More coordinator logout callback
        moreCoordinator.onLogout = { [weak self] in
            self?.logout()
        }

        // Wallet coordinator login callback
        walletCoordinator.onLogout = { [weak self] in
            self?.logout()
        }

        // Orders coordinator login callback
        ordersCoordinator.onLogout = { [weak self] in
            self?.logout()
        }

        // AddAd coordinator login callback
        addAdCoordinator.onLogout = { [weak self] in
            self?.logout()
        }

        // Home coordinator login callback
        homeCoordinator.onLogout = { [weak self] in
            self?.logout()
        }

        // AddAd coordinator close callback
        addAdCoordinator.onClose = { [weak self] in
            self?.selectedTab = .home
        }

        // AddAd coordinator ad created callback
        addAdCoordinator.onAdCreated = { [weak self] adId in
            self?.selectedTab = .more
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.moreCoordinator.showMyAds()
                self?.moreCoordinator.showMyAdDetails(adId: adId, filterType: .underReview)
            }
        }

        // Home coordinator order created callback
        homeCoordinator.onOrderCreated = { [weak self] orderId in
            self?.selectedTab = .orders
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.ordersCoordinator.showOrderDetails(orderId: orderId)
            }
        }
    }

    // MARK: - Tab Selection
    func selectTab(_ tab: TabItem) {
        // Pop to root if same tab tapped
        if tab == selectedTab {
            popToRootForCurrentTab()
        } else {
            previousTab = selectedTab
            selectedTab = tab
        }
    }

    // MARK: - Pop to Root
    private func popToRootForCurrentTab() {
        switch selectedTab {
        case .home:
            homeCoordinator.popToRoot()
        case .orders:
            ordersCoordinator.popToRoot()
        case .addAd:
            addAdCoordinator.popToRoot()
        case .wallet:
            walletCoordinator.popToRoot()
        case .more:
            moreCoordinator.popToRoot()
        }
    }

    // MARK: - Logout
    func logout() {
        UserDefaults.isLogin = false
        UserDefaults.isVisitor = false
        UserDefaults.accessToken = ""
        UserDefaults.user = nil
        onFinish?()
    }

    // MARK: - View Builder
    @ViewBuilder
    func buildTabBarView() -> some View {
        TabBarView(coordinator: self)
    }
}
