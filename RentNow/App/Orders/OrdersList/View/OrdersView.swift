//
//  OrdersView.swift
//  RentNow
//
//  Created by Claude on 2026-02-09.
//

import SwiftUI

struct OrdersView: View {
    let coordinator: OrdersCoordinatorProtocol
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        Group {
            if UserDefaults.isVisitor {
                LoginRequiredView {
                    coordinator.showLogin()
                }
            } else {
                ordersContent
            }
        }
        .navigationTitle("tab_orders".localized)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Orders Content
    private var ordersContent: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Filter tabs - fixed at top, outside BaseView
                OrdersFilterTabsView(
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
                    emptyStateMessage: viewModel.isEmpty ? "No orders available".localized : nil
                ) {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.orders) { order in
                            OrdersCardView(
                                 order: order,
                                onTap: {
                                    coordinator.showOrderDetails(orderId: order.orderId ?? 0)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .refreshable {
                    await viewModel.fetchOrders(showLoading: false)
                }
            }
        }
        .task {
            await viewModel.fetchOrders()
        }
    }
}
