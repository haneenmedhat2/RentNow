//
//  ReportDetailInfoCardView.swift
//  RentNow
//

import SwiftUI

struct ReportDetailInfoCardView: View {

    let detail: ReportDetailData

    var body: some View {
        VStack(spacing: 12) {
            // Header: icon + title
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(Color.reportIconBgColor)
                        .frame(width: 32, height: 32)

                    Image("reportIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                }

                Text("Report".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.darkTextColor)

                Spacer()
            }

            // Report Date row
            infoRow(
                label: "Report Date".localized,
                value: detail.incidentDateFormatted ?? ""
            )
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.24))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }

    // MARK: - Helpers
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .expoSystemFont(size: FontSize.small, weight: .regular)
                .foregroundColor(.subtitleTextColor)

            Spacer()

            Text(value)
                .expoSystemFont(size: FontSize.small, weight: .medium)
                .foregroundColor(.darkTextColor)
        }
    }
}
