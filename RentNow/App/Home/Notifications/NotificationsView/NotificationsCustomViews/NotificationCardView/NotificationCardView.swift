//
//  NotificationCardView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct NotificationCardView: View {

    // MARK: - Properties
    let notification: NotificationItem
    var onTap: () -> Void
    var onDelete: () -> Void

    // MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Message content
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.message)
                    .expoSystemFont(size: 14, weight: .medium)
                    .foregroundColor(Color(hex: "#080808"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(notification.date)
                    .expoSystemFont(size: 12, weight: .regular)
                    .foregroundColor(Color(hex: "#454545"))
            }

            Spacer()

            // Delete button
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color(hex: "#d1f3ff"), lineWidth: 1)
                )
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

