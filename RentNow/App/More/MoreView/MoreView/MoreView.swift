//
//  MoreView.swift
//  RentNow
//
//  Created by Elshamy on 11/02/2026.
//

import SwiftUI

struct MoreView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: MoreViewModel

    private var isVisitor: Bool {
        UserDefaults.isVisitor
    }

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 12) {
                // Top Header
                MoreTopHeaderView(
                    userName: viewModel.userName,
                    userImage: viewModel.userImage,
                    isVisitor: isVisitor,
                    onSettingsTap: {
                        coordinator.showSettings()
                    }
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)

                if isVisitor {
                    // Visitor Menu Items
                    VStack(spacing: 12) {
                        MoreMenuItemView(icon: "avatarMore", title: "About Rent Now".localized) {
                            coordinator.showAboutUs()
                        }

                        MoreMenuItemView(icon: "contact-02", title: "Contact Us".localized) {
                            coordinator.showContactUs()
                        }

                        MoreMenuItemView(icon: "catalogue", title: "How the App Works".localized) {
                            coordinator.showHowItWorks()
                        }

                        MoreMenuItemView(icon: "file-empty-01", title: "Terms and Conditions".localized) {
                            coordinator.showTermsAndConditions()
                        }

                        MoreMenuItemView(icon: "login-01", title: "Login".localized, showChevron: false) {
                            coordinator.showLogin()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

                    Spacer()
                } else {
                    // Subscription Banner
                    if !viewModel.packageName.isEmpty {
                        MoreSubscriptionBannerView(
                            packageName: viewModel.packageName,
                            onTap: {
                                coordinator.showPackages()
                            }
                        )
                        .padding(.horizontal, 16)
                    }

                    // Logged-in Menu Items
                    VStack(spacing: 12) {
                        MoreMenuItemView(icon: "user", title: "Personal Profile".localized) {
                            coordinator.showProfile()
                        }

                        MoreMenuItemView(icon: "car-03", title: "My Ads".localized) {
                            coordinator.showMyAds()
                        }

                        MoreMenuItemView(icon: "invoice-04", title: "Customer Orders".localized) {
                            coordinator.showCustomerOrders()
                        }

                        MoreMenuItemView(icon: "star 1", title: "My Ratings".localized) {
                            coordinator.showMyRatings()
                        }

                        MoreMenuItemView(icon: "riyal", title: "Financial Transactions".localized) {
                            coordinator.showFinancialTransactions()
                        }

                        MoreMenuItemView(icon: "walletTab", title: "My Wallet".localized) {
                            coordinator.showMyWallet()
                        }

                        MoreMenuItemView(icon: "avatarMore", title: "About Rent Now".localized) {
                            coordinator.showAboutUs()
                        }

                        MoreMenuItemView(icon: "contact-02", title: "Contact Us".localized) {
                            coordinator.showContactUs()
                        }

                        MoreMenuItemView(icon: "catalogue", title: "How the App Works".localized) {
                            coordinator.showHowItWorks()
                        }

                        MoreMenuItemView(icon: "file-empty-01", title: "Terms and Conditions".localized) {
                            coordinator.showTermsAndConditions()
                        }

                        MoreMenuItemView(icon: "file-01", title: "Cancellation and Delay Terms".localized) {
                            coordinator.showCancellationTerms()
                        }

                        MoreMenuItemView(icon: "alert-circle", title: "Complaints and Suggestions".localized) {
                            coordinator.showComplaintsAndSuggestions()
                        }

                        MoreMenuItemView(icon: "flag-03", title: "Reports".localized) {
                            coordinator.showReports()
                        }

                        MoreMenuItemView(icon: "logout-01", title: "Logout".localized) {
                            coordinator.showLogoutConfirmation()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadUserData()
        }
    }
}
