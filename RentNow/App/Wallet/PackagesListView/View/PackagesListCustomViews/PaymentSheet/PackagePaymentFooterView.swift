import SwiftUI

struct PackagePaymentFooterView: View {
    let buttonTitle: String
    let isEnabled: Bool
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Button(action: onConfirm) {
                Text(buttonTitle)
                    .expoSystemFont(size: 18, weight: .bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(PackagePaymentStyle.navy, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.5)
            .padding(.horizontal, 20)

            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(PackagePaymentStyle.gold)
                    .accessibilityHidden(true)
                Text("Secure payment via Moyasar".localized)
            }
            .expoSystemFont(size: FontSize.small, weight: .regular)
            .foregroundStyle(PackagePaymentStyle.secondaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(PackagePaymentStyle.border.opacity(0.6))
                .frame(height: 1)
        }
    }
}

#Preview {
    PackagePaymentFooterView(buttonTitle: "ادفع 100 ر.س", isEnabled: true, onConfirm: {})
        .environment(\.layoutDirection, .rightToLeft)
}
