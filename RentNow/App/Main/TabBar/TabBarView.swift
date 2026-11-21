//
//  TabBarView.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var coordinator: TabBarCoordinator

    var body: some View {
        TabView(selection: tabSelection) {
            // Home Tab
            HomeFlowView(coordinator: coordinator.homeCoordinator)
                .tabItem {
                    Label(TabItem.home.title, image:  TabItem.home.icon)
                }
                .tag(TabItem.home)

            // Orders Tab
            OrdersFlowView(coordinator: coordinator.ordersCoordinator)
                .tabItem {
                    Label(TabItem.orders.title, image: TabItem.orders.icon)
                }
                .tag(TabItem.orders)

            // Add Ad Tab
            AddAdFlowView(coordinator: coordinator.addAdCoordinator)
                .tabItem {
                    Label(TabItem.addAd.title, image: TabItem.addAd.icon)
                }
                .tag(TabItem.addAd)

            // Wallet Tab
            WalletFlowView(coordinator: coordinator.walletCoordinator)
                .tabItem {
                    Label(TabItem.wallet.title, image: TabItem.wallet.icon)
                }
                .tag(TabItem.wallet)

            // More Tab
            MoreFlowView(coordinator: coordinator.moreCoordinator)
                .tabItem {
                    Label(TabItem.more.title, image: TabItem.more.icon)
                }
                .tag(TabItem.more)
        }
        .tint(.mainColor)
        .onAppear {
            configureTabBarAppearance()
        }
        .logViewAppearance()
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()

        if #available(iOS 18.0, *) {
            // iOS 18+: Use native glassy appearance
            appearance.configureWithDefaultBackground()
        } else {
            // iOS < 18: Use white background
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white.withAlphaComponent(0.1)

            // Add subtle shadow for depth
            appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
        }

        UITabBar.appearance().standardAppearance = appearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    private var tabSelection: Binding<TabItem> {
        Binding(
            get: { coordinator.selectedTab },
            set: { coordinator.selectTab($0) }
        )
    }
}

// MARK: - Flow Views

struct HomeFlowView: View {
    @ObservedObject var coordinator: HomeCoordinator

    var body: some View {
        coordinator.buildHomeFlow()
            .logViewAppearance(viewName: "HomeFlowView")
    }
}

struct OrdersFlowView: View {
    @ObservedObject var coordinator: OrdersCoordinator

    var body: some View {
        coordinator.buildOrdersFlow()
            .logViewAppearance(viewName: "OrdersFlowView")
    }
}

struct AddAdFlowView: View {
    @ObservedObject var coordinator: AddAdCoordinator

    var body: some View {
        coordinator.buildAddAdFlow()
            .logViewAppearance(viewName: "AddAdFlowView")
    }
}

struct WalletFlowView: View {
    @ObservedObject var coordinator: WalletCoordinator

    var body: some View {
        coordinator.buildWalletFlow()
            .logViewAppearance(viewName: "WalletFlowView")
    }
}

struct MoreFlowView: View {
    @ObservedObject var coordinator: MoreCoordinator

    var body: some View {
        coordinator.buildMoreFlow()
            .logViewAppearance(viewName: "MoreFlowView")
    }
}
