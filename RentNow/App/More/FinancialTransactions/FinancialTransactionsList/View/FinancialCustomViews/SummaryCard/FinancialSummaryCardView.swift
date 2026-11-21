//
//  FinancialSummaryCardView.swift
//  RentNow
//

import SwiftUI

struct FinancialSummaryCardView: View {
    let summary: WaitingSettlementSummary

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Outstanding".localized)
                    .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundColor(.black)
                Spacer()
            }

            Divider()

            VStack(spacing: 10) {
                summaryRow(title: "Total Orders".localized, value: summary.totalFormatted)
                summaryRow(title: "Total Commission".localized, value: summary.totalTaxFormatted)
//                summaryRow(title: "Total VAT".localized, value: summary.totalVatFormatted)
                summaryRow(title: "Total commission discount".localized, value: summary.totalCommissionDiscountFormatted)

                HStack {
                    Text("Total".localized)
                        .expoSystemFont(size: FontSize.large, weight: .medium)
                        .foregroundColor(.text)
                    Spacer()
                    Text("\(summary.totalAmountDueFormatted) " + "SAR".localized)
                        .expoSystemFont(size: FontSize.large, weight: .semiBold)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(16)
        .glassyBackground(cornerRadius: 12)
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.text)
            Spacer()
            Text("\(value) " + "SAR".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)
        }
    }
}


