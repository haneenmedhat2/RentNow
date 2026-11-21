//
//  FinancialTransactionsView.swift
//  RentNow
//

import SwiftUI

struct FinancialTransactionsView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: FinancialTransactionsViewModel

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                FinancialFilterTabsView(
                    selectedTab: viewModel.selectedTab,
                    onTabSelected: { tab in
                        viewModel.selectTab(tab)
                    }
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Summary Card + Settlement Button (Outstanding only)
                if viewModel.selectedTab == .outstanding, let summary = viewModel.waitingSummary {
                    FinancialSummaryCardView(summary: summary)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                    MainButton(title: "Settlement".localized) {
                        coordinator.showBankAccountForm()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }

                BaseView(
                    viewModel: viewModel,
                    showMainBackground: false,
                    disableScroll: true,
                    emptyStateMessage: viewModel.isEmpty ? "No orders available".localized : nil
                ) {
                    LazyVStack(spacing: 12) {
                        switch viewModel.selectedTab {
                        case .outstanding:
                            ForEach(viewModel.waitingSettlements) { order in
                                FinancialOrderCardView(order: order)
                            }

                        case .newSettlement:
                            ForEach(viewModel.newSettlements) { settlement in
                                FinancialSettlementCardView(settlement: settlement) {
                                    coordinator.showSettlementDetails(settlementId: settlement.id ?? 0)
                                }
                            }

                        case .endedSettlement:
                            ForEach(viewModel.endedSettlements) { settlement in
                                FinancialSettlementCardView(settlement: settlement) {
                                    coordinator.showSettlementDetails(settlementId: settlement.id ?? 0)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .refreshable {
                    await viewModel.loadCurrentTabData()
                }
            }
        }
        .navigationTitle("Financial Transactions".localized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadCurrentTabData()
        }
    }
}
