//
//  LogoutConfirmationView.swift
//  RentNow
//
//  Created by Apple on 28/02/2026.
//


import SwiftUI

// MARK: - Logout Confirmation View
struct LogoutConfirmationView: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("Logout".localized)
                .font(.title3)
                .fontWeight(.semibold)

            Text("Are you sure you want to logout?".localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button {
                    onCancel()
                } label: {
                    Text("Close".localized)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }

                Button {
                    onConfirm()
                } label: {
                    Text("Confirm".localized)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal, 32)
        .logViewAppearance()
    }
}
