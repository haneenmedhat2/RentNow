import SwiftUI

enum PackagePaymentStyle {
    static let navy = Color(hex: "102D60")
    static let border = Color(hex: "E3E5EC")
    static let secondaryText = Color(hex: "777E8D")
    static let selectedBackground = Color(hex: "F4F6FD")
    static let badgeBackground = Color(hex: "F3F4F6")
    static let gold = Color(hex: "CDA13E")
}

struct PackagePaymentHeaderView: View {
    let packageName: String
    let priceText: String
    var detailsText: String = ""
    var onClose: () -> Void
    @State private var showsDetails = false

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .accessibilityHidden(true)

                Text("package_payment_title".localized)
                    .expoSystemFont(size: 18, weight: .bold)
                    .foregroundStyle(PackagePaymentStyle.navy)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(PackagePaymentStyle.navy)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close".localized)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(packageName)
                            .expoSystemFont(size: FontSize.normal)
                            .foregroundStyle(PackagePaymentStyle.secondaryText)
                        Text("\(priceText) \("SAR".localized)")
                            .expoSystemFont(size: 24, weight: .bold)
                            .foregroundStyle(PackagePaymentStyle.navy)
                            .monospacedDigit()
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if !detailsText.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) { showsDetails.toggle() }
                        } label: {
                            Text((showsDetails ? "package_payment_hide_details" : "package_payment_details").localized)
                                .expoSystemFont(size: FontSize.normal)
                                .foregroundStyle(PackagePaymentStyle.gold)
                                .frame(minHeight: 44)
                        }
                        .buttonStyle(.plain)
                    }
                }

                if showsDetails {
                    Divider()
                    Text(detailsText)
                        .expoSystemFont(size: FontSize.small)
                        .foregroundStyle(PackagePaymentStyle.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(14)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(PackagePaymentStyle.border, lineWidth: 1)
            }
        }
        .padding(.horizontal, 20)
    }
}
