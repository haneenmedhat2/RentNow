//
//  PackagesListView.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import SwiftUI

struct PackagesListView: View {

    let coordinator: WalletCoordinatorProtocol
    @ObservedObject var viewModel: PackagesListViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true, disableScroll: true) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Please choose from available packages".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .padding(.horizontal, 16)

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.packages) { package in
                            PackagesListCardView(
                                package: package,
                                durationText: viewModel.durationText(for: package),
                                onSubscribeTap: {
                                    guard !viewModel.isStartingPayment, let id = package.id else { return }
                                    coordinator.showPackagePaymentSheet(package: package) { method, moyasarMethod in
                                        viewModel.subscribe(packageId: id, paymentMethod: method, moyasarMethod: moyasarMethod)
                                    }
                                }
                            )
                            .disabled(viewModel.isStartingPayment)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Packages".localized)
        .onAppear {
            viewModel.fetchPackages()
        }
        .onChange(of: viewModel.paymentSession) { _, session in
            guard let session else { return }
            coordinator.showPayment(session: session) { result in
                viewModel.handlePaymentResult(result)
            }
            viewModel.paymentSession = nil
        }
        .onChange(of: viewModel.isSubscribed) { _, subscribed in
            if subscribed {
                coordinator.showSubscriptionSuccess()
                viewModel.isSubscribed = false
            }
        }
    }
}
