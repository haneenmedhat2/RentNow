//
//  FinancialSettlementCardView.swift
//  RentNow
//

import SwiftUI

struct FinancialSettlementCardView: View {
    let settlement: SettlementListItem
    var onTap: () -> Void

    private var statusColor: Color {
        switch settlement.statusId {
        case 1: return .blue
        case 2: return .green
        case 3: return .red
        default: return .gray
        }
    }

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("#\(settlement.settlementNum ?? "\(settlement.id ?? 0)")")
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.black)

                    Text(settlement.dateFormatted ?? "")
                        .expoSystemFont(size: FontSize.small, weight: .regular)
                        .foregroundColor(.text)

                    Text("\(settlement.totalAmountDue ?? "0") " + "SAR".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.black)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text(settlement.statusName ?? "")
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(statusColor)

                    Image(systemName: "chevron.right")
                        .foregroundColor(.text)
                        .flipsForRightToLeftLayoutDirection(true)
                }
            }
            .padding(16)
            .glassyBackground(cornerRadius: 12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        MainGradientView()
        FinancialSettlementCardView(
            settlement: SettlementListItem(
                id: 1,
                dateFormatted: "2026-03-01",
                totalAmountDue: "1500",
                statusName: "في انتظار الموافقة",
                statusId: 1,
                settlementNum: "SET-001"
            ),
            onTap: {}
        )
        .padding()
    }
}
