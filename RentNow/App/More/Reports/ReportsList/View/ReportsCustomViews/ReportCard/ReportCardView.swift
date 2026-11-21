//
//  ReportCardView.swift
//  RentNow
//

import SwiftUI

struct ReportCardView: View {

    let item: ReportItem
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 12) {
                // Header: icon + title
                HStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#FEF3F2"))
                            .frame(width: 32, height: 32)

                        Image("reportIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                    }

                    Text("Report".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(Color(hex: "#080808"))

                    Spacer()
                }

                // Info rows
                VStack(spacing: 8) {
                    infoRow(
                        label: "Report Date".localized,
                        value: item.incidentDateFormatted ?? ""
                    )

                    infoRow(
                        label: "Incident Location".localized,
                        value: item.geoAddress ?? ""
                    )
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(.sRGB, red: 250/255, green: 250/255, blue: 250/255, opacity: 0.24))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color(hex: "#EDEDED"), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(Color(hex: "#212121"))

            Spacer()

            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(Color(hex: "#080808"))
        }
    }

    private func formatDate(_ dateStr: String?) -> String {
        guard let dateStr = dateStr, !dateStr.isEmpty else { return "" }
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = inputFormatter.date(from: dateStr) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM, yyyy"
            outputFormatter.locale = Locale(identifier: "ar")
            return outputFormatter.string(from: date)
        }
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        if let date = inputFormatter.date(from: dateStr) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM, yyyy"
            outputFormatter.locale = Locale(identifier: "ar")
            return outputFormatter.string(from: date)
        }
        return dateStr
    }
}
