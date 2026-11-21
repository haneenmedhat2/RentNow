//
//  WalletView.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import SwiftUI

struct WalletView: View {

    let coordinator: WalletCoordinatorProtocol
    @ObservedObject var viewModel: WalletViewModel

    var body: some View {
        Group {
            if UserDefaults.isVisitor {
                LoginRequiredView {
                    coordinator.showLogin()
                }
            } else {
                walletContent
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Wallet".localized)
    }

    // MARK: - Wallet Content
    private var walletContent: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            if viewModel.hasActiveSubscription {
                activeSubscriptionContent
            } else if viewModel.hasFetchedSubscription {
                WalletNoSubscriptionView {
                    coordinator.showPackagesList()
                }
            }
        }
        .onAppear {
            viewModel.fetchSubscription()
        }
    }

    // MARK: - Active Subscription Content
    private var activeSubscriptionContent: some View {
        VStack(spacing: 16) {
            if let sub = viewModel.subscription {
                WalletSubscriptionCardView(
                    packageName: sub.packageName ?? "",
                    durationText: viewModel.durationText,
                    price: sub.price ?? 0,
                    description: viewModel.descriptionText,
                    deliveryTimesCount: sub.remainingWaivedDeliveryFeesOrders ?? 0,
                    discountPercentage: sub.discountPercentage ?? 0
                )
            }

            // Buttons
            HStack(spacing: 8) {
                GrayPillButton(title: "Renew subscription".localized) {
                    coordinator.showPackagesList()
                }

                RedOutlinePillButton(title: "Cancel subscription".localized) {
                    coordinator.showCancelConfirmation {
                        viewModel.cancelSubscription()
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}
