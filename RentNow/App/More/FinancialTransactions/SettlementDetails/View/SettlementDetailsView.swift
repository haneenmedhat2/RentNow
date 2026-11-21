//
//  SettlementDetailsView.swift
//  RentNow
//

import SwiftUI

struct SettlementDetailsView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: SettlementDetailsViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            if let details = viewModel.details {
                VStack(spacing: 16) {
                    // Status Banner
                    SettlementStatusBannerView(
                        statusName: details.statusName ?? "",
                        statusType: viewModel.statusColor
                    )

                    // Summary Card
                    VStack(spacing: 8) {
                        summaryRow(
                            label: "Total Orders".localized,
                            value: details.totalOrdersFormatted
                        )
                        summaryRow(
                            label: "Total Commission".localized,
                            value: details.totalTaxFormatted
                        )
                        summaryRow(
                            label: "Total commission discount".localized,
                            value: details.totalCommissionDiscountFormatted
                        )

                        Divider()

                        // Total
                        HStack(spacing: 2) {
                            Text("Total".localized)
                                .expoSystemFont(size: FontSize.small, weight: .medium)
                                .foregroundColor(.subtitleTextColor)

                            Spacer()

                            Text(details.totalAmountDueFormatted)
                                .expoSystemFont(size: FontSize.large, weight: .medium)
                                .foregroundColor(.mainColor)

                            Image("riyal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.lightBlueBorderColor, lineWidth: 1)
                    )
                    .cornerRadius(4)

                    // Transfer Image (Approved)
                    if viewModel.showTransferImage, let imageUrl = details.transferImage {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bank Transfer".localized)
                                .expoSystemFont(size: FontSize.small, weight: .medium)
                                .foregroundColor(.darkTextColor)

                            RemoteImageView(url: imageUrl)
                                .frame(height: 200)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                        .cornerRadius(4)
                    }

                    // Rejection Reason
                    if viewModel.showRejectionReason, let reason = details.rejectionReason {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Rejection Reason".localized)
                                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                                    .foregroundColor(.red)
                                Spacer()
                            }

                            Text(reason)
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(.subtitleTextColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(4)
                    }

                    // Orders
                    if let orders = details.orders, !orders.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Orders".localized)
                                .expoSystemFont(size: FontSize.normal, weight: .medium)
                                .foregroundColor(.subtitleTextColor)

                            ForEach(orders) { order in
                                FinancialOrderCardView(order: order)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Settlement Details".localized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchDetails()
        }
        .refreshable {
            await viewModel.fetchDetails()
        }
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack(spacing: 2) {
            Text(label)
                .expoSystemFont(size: FontSize.small, weight: .regular)
                .foregroundColor(.subtitleTextColor)

            Spacer()

            Text(value)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(.darkTextColor)

            Image("riyal")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
    }
}
