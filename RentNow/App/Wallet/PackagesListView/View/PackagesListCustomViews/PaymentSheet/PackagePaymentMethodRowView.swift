import SwiftUI

struct PackagePaymentMethodRowView: View {
    enum Badge {
        case applePay
        case card
        case installments(Int?)
    }

    let title: String
    let subtitle: String
    let badge: Badge
    let isSelected: Bool
    let isEnabled: Bool
    var onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(isSelected ? PackagePaymentStyle.navy : .white)
                    Circle()
                        .strokeBorder(isSelected ? PackagePaymentStyle.navy : Color.gray.opacity(0.65), lineWidth: 2)
                    if isSelected {
                        Circle().fill(.white).frame(width: 8, height: 8)
                    }
                }
                .frame(width: 22, height: 22)
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                        .foregroundStyle(.black)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .expoSystemFont(size: FontSize.small)
                            .foregroundStyle(PackagePaymentStyle.secondaryText)
                    }
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

                badgeView
                    .frame(width: 44, height: 34)
                    .background(PackagePaymentStyle.badgeBackground, in: RoundedRectangle(cornerRadius: 8))
                    .accessibilityHidden(true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 66)
            .background(isSelected ? PackagePaymentStyle.selectedBackground : .white, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(isSelected ? PackagePaymentStyle.navy : PackagePaymentStyle.border, lineWidth: isSelected ? 1.5 : 1)
            }
            .opacity(isEnabled ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var badgeView: some View {
        switch badge {
        case .applePay:
            Text(verbatim: "Pay")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(PackagePaymentStyle.navy)
        case .card:
            Image(systemName: "creditcard.fill")
                .font(.system(size: 16))
                .foregroundStyle(PackagePaymentStyle.gold)
        case .installments(let count):
            if let count, count > 1 {
                Text(verbatim: "×\(count)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(PackagePaymentStyle.navy)
                    .environment(\.layoutDirection, .leftToRight)
            } else {
                Image(systemName: "calendar")
                    .foregroundStyle(PackagePaymentStyle.navy)
            }
        }
    }
}
