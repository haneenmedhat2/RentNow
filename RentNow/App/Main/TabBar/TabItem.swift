//
//  TabItem.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI

// MARK: - Tab Item
enum TabItem: Int, CaseIterable, Hashable {
    case home = 0
    case orders = 1
    case addAd = 2
    case wallet = 3
    case more = 4

    var title: String {
        switch self {
        case .home:
            return "tab_home".localized
        case .orders:
            return "tab_orders".localized
        case .addAd:
            return "tab_add_ad".localized
        case .wallet:
            return "tab_wallet".localized
        case .more:
            return "tab_more".localized
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "homeTab"
        case .orders:
            return "ordersTab"
        case .addAd:
            return "addTab"
        case .wallet:
            return "walletTab"
        case .more:
            return "moreTab"
        }
    }
}
