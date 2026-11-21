//
//  CreateOrderTermsSectionView.swift
//  RentNow
//

import SwiftUI

struct CreateOrderTermsSectionView: View {
    let agreedToTerms: Bool
    let cancellationAndDelayTerms: String?
    let termsError: String?
    var onToggleTerms: () -> Void
    var onTermsTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Button(action: onToggleTerms) {
                    Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreedToTerms ? .mainColor : .gray)
                        .font(.system(size: 22))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Agree to cancellation and delay terms".localized)
                .accessibilityAddTraits(agreedToTerms ? .isSelected : [])

                Button(action: onTermsTap) {
                    Text("Agree to cancellation and delay terms".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.mainColor)
                        .multilineTextAlignment(.leading)
                        .underline()
                }
                .buttonStyle(.plain)
                Spacer(minLength: 0)
            }

            if let terms = cancellationAndDelayTerms, !terms.isEmpty {
                Text(terms)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.gray)
                    .padding(.leading, 34)
            }

            if let error = termsError {
                Text(error)
                    .expoSystemFont(size: FontSize.small, weight: .medium)
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.horizontal, 16)
    }
}
