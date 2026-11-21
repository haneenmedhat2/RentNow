//
//  CustomerOrdersView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct CustomerOrdersView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: CustomerOrdersViewModel

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Filter tabs - fixed at top
                CustomerOrdersFilterTabsView(
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
                            CustomerOrderCardView(order: order, onTap: {
                                coordinator.showCustomerOrderDetails(orderId: order.orderId ?? 0)
                            })
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
        .navigationTitle("Customer Orders".localized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchOrders()
        }
    }
}

#Preview {
    NavigationStack {
        CustomerOrdersView(coordinator: MoreCoordinator(), viewModel: CustomerOrdersViewModel())
    }
}
