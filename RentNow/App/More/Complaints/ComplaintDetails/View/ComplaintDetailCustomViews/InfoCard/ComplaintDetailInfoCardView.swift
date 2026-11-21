//
//  ComplaintDetailInfoCardView.swift
//  RentNow
//

import SwiftUI

struct ComplaintDetailInfoCardView: View {

    let detail: ComplaintDetailData

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: info icon + number + status badge
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.mainColor)
                        .font(.system(size: 18))

                    Text("#\(detail.id ?? 0)")
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.text)
                }

                Spacer()

                Text(statusText)
                    .expoSystemFont(size: FontSize.small, weight: .medium)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(statusColor.opacity(0.15))
                    )
            }

            if let date = detail.creationDate, !date.isEmpty {
                infoRow(label: "Complaint Date".localized, value: formatDate(date))
            }

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.21))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.6), lineWidth: 0.7)
        )
    }

    // MARK: - Helpers
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .expoSystemFont(size: FontSize.normal, weight: .regular)

            Spacer()

            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.text)
        }
    }

    private var statusText: String {
        (detail.isAdminResponded ?? false) ? "Responded".localized : "Under Review".localized
    }

    private var statusColor: Color {
        (detail.isAdminResponded ?? false) ? .green : .orange
    }

    private func formatDate(_ dateStr: String?) -> String {
        guard let dateStr = dateStr, !dateStr.isEmpty else { return "" }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = inputFormatter.date(from: dateStr) else { return dateStr }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM,yyyy"
        outputFormatter.locale = Locale(identifier: "ar")
        return outputFormatter.string(from: date)
    }
}
