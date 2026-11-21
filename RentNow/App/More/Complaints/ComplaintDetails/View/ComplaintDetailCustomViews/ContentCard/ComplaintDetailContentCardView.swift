//
//  ComplaintDetailContentCardView.swift
//  RentNow
//

import SwiftUI

struct ComplaintDetailContentCardView: View {

    let detail: ComplaintDetailData
    var onImageTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = detail.title, !title.isEmpty {
                fieldSection(label: "Complaint Title".localized, value: title)
            }

            if let message = detail.message, !message.isEmpty {
                fieldSection(label: "Complaint Text".localized, value: message)
            }

            if let attachment = detail.attachment, !attachment.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Complaint Image".localized)
                        .expoSystemFont(size: FontSize.small, weight: .regular)
                        .foregroundColor(.gray)

                    Button {
                        onImageTap?()
                    } label: {
                        RemoteImageView(url: NetworkConstants.domain + attachment)
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                }
            }

            if let adminResponse = detail.adminResponse, !adminResponse.isEmpty {
                fieldSection(label: "Admin Response".localized, value: adminResponse)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    private func fieldSection(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .expoSystemFont(size: FontSize.small, weight: .regular)
                .foregroundColor(.gray)

            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.text)
        }
    }
}
