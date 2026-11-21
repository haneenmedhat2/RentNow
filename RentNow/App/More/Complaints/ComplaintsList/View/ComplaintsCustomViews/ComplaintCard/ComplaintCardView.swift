//
//  ComplaintCardView.swift
//  RentNow
//

import SwiftUI

struct ComplaintCardView: View {

    let item: ComplaintItem
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: info icon + number + status badge
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.mainColor)
                        .font(.system(size: 18))

                    Text("#\(item.number ?? 0)")
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.text)
                }

                Spacer()

                // Status badge
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

            // Complaint Date row
            infoRow(label: "Complaint Date".localized, value: formatDate(item.creationDate))

//            // Order Number row
//            infoRow(label: "Order Number".localized, value: "#\(item.orderNumber ?? 0)")
//
//            // Order Date row
//            infoRow(label: "Order Date".localized, value: formatDate(item.orderDate))
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
        .buttonStyle(.plain)
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
        (item.isAdminResponded ?? false) ? "Responded".localized : "Under Review".localized
    }

    private var statusColor: Color {
        (item.isAdminResponded ?? false) ? .green : .orange
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
