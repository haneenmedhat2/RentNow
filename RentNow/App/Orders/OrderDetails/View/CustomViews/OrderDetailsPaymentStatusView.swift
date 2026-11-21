import SwiftUI

struct OrderDetailsPaymentStatusView: View {
    let data: PaymentInfoData
    var onChangeMethod: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.grayTextColor)

            HStack(spacing: 12) {
                if let iconName {
                    Image(iconName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconName == "creditCard" ? 24 : 64, height: 28)
                        .accessibilityHidden(true)
                }
                Text(data.paymentMethod ?? "")
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)
                Spacer()
            }

            if !statusText.isEmpty {
                HStack(alignment: .top) {
                    Text("Payment status".localized)
                        .foregroundColor(.grayTextColor)
                    Spacer()
                    Text(statusText)
                        .foregroundColor(statusColor)
                        .multilineTextAlignment(.trailing)
                }
                .expoSystemFont(size: FontSize.normal, weight: .medium)
            }

            if let reason = data.paymentRejectionReason, !reason.isEmpty {
                Text(reason)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if data.canChangePaymentMethod == true {
                Button("Change payment method".localized, action: onChangeMethod)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.mainColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassyBackground(cornerRadius: 16)
    }

    private var iconName: String? {
        switch data.paymentProvider {
        case .moyasar: return "creditCard"
        case .tabby: return "tabbyLogo"
        case .tamara: return "tamaraLogo"
        default:
            switch data.paymentMethodId {
            case 1: return "creditCard"
            case 4: return "tabbyLogo"
            case 2: return "tamaraLogo"
            default: return nil
            }
        }
    }

    private var statusText: String {
        if let text = data.paymentStatusText, !text.isEmpty { return text }
        switch data.paymentStatus {
        case .unpaid: return "Unpaid".localized
        case .pending: return "Awaiting payment confirmation".localized
        case .paid: return "Paid".localized
        case .rejected: return "Rejected".localized
        case .cancelled: return "Payment canceled".localized
        case .expired: return "Payment expired".localized
        case .needsReview: return "Payment under review".localized
        case .refunded: return "Refunded".localized
        case .unknown: return "Payment status unavailable".localized
        case nil: return ""
        }
    }

    private var statusColor: Color {
        switch data.paymentStatus {
        case .paid: return .green
        case .rejected, .cancelled, .expired: return .red
        case .pending, .needsReview: return .orange
        default: return .grayTextColor
        }
    }
}

#Preview {
    let data = try! JSONDecoder().decode(PaymentInfoData.self, from: Data(#"{"paymentMethod":"Tabby","paymentProvider":"tabby","paymentMethodId":4,"paymentStatus":"Rejected","paymentStatusText":"Rejected","paymentRejectionReason":"Please choose another payment method.","canChangePaymentMethod":true}"#.utf8))
    OrderDetailsPaymentStatusView(data: data, onChangeMethod: {})
        .padding()
}
