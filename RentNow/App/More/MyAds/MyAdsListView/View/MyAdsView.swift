//
//  MyAdsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdsView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: MyAdsViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Filter tabs - fixed at top
                MyAdsFilterTabsView(
                    selectedFilter: viewModel.selectedFilter,
                    onFilterSelected: { filter in
                        viewModel.selectFilter(filter)
                    }
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Scrollable content via BaseView
                BaseView(
                    viewModel: viewModel,
                    showMainBackground: false,
                    disableScroll: true,
                    emptyStateMessage: viewModel.isEmpty ? "No ads available".localized : nil
                ) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.ads) { ad in
                            Button {
                                coordinator.showMyAdDetails(adId: ad.id ?? 0, filterType: viewModel.selectedFilter)
                            } label: {
                                MyAdsCardView(
                                    ad: ad,
                                    statusText: viewModel.selectedFilter.title
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .refreshable {
                    await viewModel.fetchAds(showLoading: false)
                }
            }
        }
        .navigationTitle("My Ads".localized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchAds()
        }
        .onReceive(NotificationCenter.default.publisher(for: .myAdsNeedRefresh)) { _ in
            Task { await viewModel.fetchAds() }
        }
    }
}

#Preview {
    NavigationStack {
        MyAdsView(coordinator: MoreCoordinator(), viewModel: MyAdsViewModel())
    }
}
