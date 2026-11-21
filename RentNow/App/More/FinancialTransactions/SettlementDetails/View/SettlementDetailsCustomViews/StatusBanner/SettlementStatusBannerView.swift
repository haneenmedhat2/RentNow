//
//  SettlementStatusBannerView.swift
//  RentNow
//

import SwiftUI

struct SettlementStatusBannerView: View {
    let statusName: String
    let statusType: StatusColorType

    private var borderColor: Color {
        switch statusType {
        case .pending:  return .blue
        case .approved: return .green
        case .rejected: return .red
        }
    }

    private var iconBgColor: Color {
        switch statusType {
        case .pending:  return .blue.opacity(0.15)
        case .approved: return .green.opacity(0.15)
        case .rejected: return .red.opacity(0.15)
        }
    }

    private var iconName: String {
        switch statusType {
        case .pending:  return "alert-circle"
        case .approved: return "star-award-02"
        case .rejected: return "alert-circle"
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            
            ZStack {
                Circle()
                    .fill(iconBgColor)
                    .frame(width: 28, height: 28)

                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
            
            Text(statusName)
                .expoSystemFont(size: FontSize.small, weight: .medium)
                .foregroundColor(.darkTextColor)
                .multilineTextAlignment(.trailing)

            Spacer()

          
        }
        .padding(8)
        .background(Color.white.opacity(0.24))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(4)
    }
}
