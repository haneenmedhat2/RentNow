import SwiftUI

struct CreateOrderPaymentMethodView: View {
    let paymentOptions: [OrderPaymentOption]
    let selectedMethodId: Int?
    var moyasarMethod: Binding<MoyasarPaymentMethod> = .constant(.card)
    let error: String?
    let isRefreshing: Bool
    let refreshError: String?
    var isSelectionEnabled: Bool = true
    var paymentAmount: Double? = nil
    var currency: String = "SAR"
    var usesBorderedCards: Bool = false
    var showsTitle: Bool = true
    var usesCheckoutLayout: Bool = false
    var onApplePaySelected: (() -> Void)? = nil
    var onSelect: (Int) -> Void
    var onRetry: () -> Void
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if showsTitle {
                Text("Select payment method".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)
            }

            if usesCheckoutLayout {
                checkoutOptions
            } else {
                VStack(spacing: usesBorderedCards ? 12 : 8) {
    
                    ForEach(paymentOptions) { option in
                        if option.id == 1 {
                            paymentRow(option, moyasar: .applePay)
                            paymentRow(option, moyasar: .card)
                        } else {
                            paymentRow(option)
                        }
                    }
                }
            }

            if isRefreshing {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Updating payment options...".localized)
                        .expoSystemFont(size: FontSize.small, weight: .regular)
                }
            } else if let refreshError {
                Text(refreshError)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.red)
                Button("Retry".localized, action: onRetry)
                    .foregroundColor(.mainColor)
            } else if paymentOptions.isEmpty {
                Text("No payment methods are currently available.".localized)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.grayTextColor)
            }

            if let error {
                Text(error)
                    .expoSystemFont(size: FontSize.small, weight: .medium)
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.horizontal, 16)
    }

    private var checkoutOptions: some View {
        VStack(spacing: 12) {
            if let moyasar = paymentOptions.first(where: { $0.id == 1 }) {
                checkoutButton(moyasar, moyasar: .applePay)
            }

            let columns = dynamicTypeSize.isAccessibilitySize ? 1 : max(checkoutCardOptions.count, 1)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns), spacing: 8) {
                ForEach(checkoutCardOptions) { option in
                    checkoutButton(option, moyasar: option.id == 1 ? .card : nil)
                }
            }

            if !isRefreshing, refreshError == nil, isSelectionEnabled {
                if let offer = installmentOffer {
                    (Text(String(format: "checkout_installment_offer".localized, offer.count) + " ")
                     + Text(offer.amount).foregroundColor(CreateOrderPaymentSheetStyle.installmentAccent).bold())
                    .expoSystemFont(size: FontSize.small)
                    .foregroundColor(.grayTextColor)
                    .multilineTextAlignment(.center)
                }

                if let selected = checkoutCardOptions.first(where: { $0.id == selectedMethodId && $0.isAvailable == true }),
                   let amount = paymentAmount {
                    if selected.id == 4 {
                        TabbyInstallmentView(amount: amount, currency: currency, isEmbedded: true)
                    } else if selected.id == 2 {
                        TamaraInstallmentView(amount: amount, currency: currency, isEmbedded: true)
                    }
                }
            }

            ForEach(checkoutCardOptions.filter { $0.isAvailable != true }) { option in
                Text("\(title(for: option, moyasar: option.id == 1 ? .card : nil)): \(unavailableReason(option))")
                    .expoSystemFont(size: FontSize.small)
                    .foregroundStyle(Color.grayTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if paymentOptions.contains(where: { $0.id == 1 && $0.isAvailable == true }), !MoyasarConfiguration.canUseApplePay {
                Text("Apple Pay is currently unavailable.".localized)
                    .expoSystemFont(size: FontSize.small)
                    .foregroundStyle(Color.grayTextColor)
            }
        }
    }

    private var checkoutCardOptions: [OrderPaymentOption] {
        let order = [1: 0, 2: 1, 4: 2]
        return paymentOptions.sorted { order[$0.id ?? -1, default: 3] < order[$1.id ?? -1, default: 3] }
    }

    private var installmentOffer: (count: Int, amount: String)? {
        let offers = checkoutCardOptions.filter {
            ($0.id == 2 || $0.id == 4) && $0.isAvailable == true &&
            ($0.instalmentsCount ?? 0) > 1 && ($0.instalmentAmount ?? 0) > 0 &&
            !($0.currency ?? "").isEmpty
        }
        guard let option = offers.first(where: { $0.id == selectedMethodId }) ?? offers.first,
              let count = option.instalmentsCount, let amount = option.instalmentAmount,
              let currency = option.currency else { return nil }
        let amountText = amount.formatted(.number.locale(Locale(identifier: Language.currentLanguage())).precision(.fractionLength(2)))
        return (count, "\(amountText) \(currency.localized)")
    }

    private func checkoutButton(_ option: OrderPaymentOption, moyasar: MoyasarPaymentMethod?) -> some View {
        let isApplePay = moyasar == .applePay
        let isAvailable = option.isAvailable == true && (!isApplePay || MoyasarConfiguration.canUseApplePay)
        let isSelected = selectedMethodId == option.id && (moyasar == nil || moyasarMethod.wrappedValue == moyasar)
        return Button {
            select(option, moyasar: moyasar)
        } label: {
            VStack(spacing: 0) {
                if isApplePay {
                    Text(verbatim: "Apple Pay")
                        .font(.system(size: 22, weight: .bold))
                } else {
                    Text(moyasar == .card ? "checkout_card".localized : title(for: option, moyasar: nil))
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                    Text(moyasar == .card ? "checkout_card_networks".localized : "checkout_installments".localized)
                        .expoSystemFont(size: 10)
                        .foregroundStyle(Color.grayTextColor)
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 56)
            .foregroundStyle(isApplePay ? .white : .black)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isApplePay ? .black : (isSelected ? CreateOrderPaymentSheetStyle.selectedBackground : .white))
            }
            .overlay {
                if !isApplePay {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(isSelected ? CreateOrderPaymentSheetStyle.navy : CreateOrderPaymentSheetStyle.border, lineWidth: isSelected ? 1.5 : 1)
                }
            }
            .overlay(alignment: .trailing) {
                if isApplePay, isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .accessibilityHidden(true)
                }
            }
            .opacity(isAvailable ? 1 : 0.45)
        }
        .buttonStyle(.plain)
        .disabled(!isAvailable || isRefreshing || !isSelectionEnabled)
        .accessibilityLabel(title(for: option, moyasar: moyasar))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func select(_ option: OrderPaymentOption, moyasar: MoyasarPaymentMethod?) {
        guard let id = option.id else { return }
        if let moyasar { moyasarMethod.wrappedValue = moyasar }
        onSelect(id)
        if moyasar == .applePay { onApplePaySelected?() }
    }

    private func paymentRow(_ option: OrderPaymentOption, moyasar: MoyasarPaymentMethod? = nil) -> some View {
        let isAvailable = option.isAvailable == true && (moyasar != .applePay || MoyasarConfiguration.canUseApplePay)
        let isSelected = selectedMethodId == option.id && (moyasar == nil || moyasarMethod.wrappedValue == moyasar)
        return VStack(spacing: 0) {
            Button {
                select(option, moyasar: moyasar)
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    RadioButton(isSelected: isSelected)
                        .accessibilityHidden(true)

                    paymentIcon(for: option.id, moyasar: moyasar)
                        .frame(width: 64, height: 28)
                        .opacity(isAvailable ? 1 : 0.5)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(title(for: option, moyasar: moyasar))
                            .expoSystemFont(size: FontSize.normal, weight: usesBorderedCards ? .semiBold : .regular)
                            .foregroundColor(isAvailable ? .black : .gray)

                        if let subtitle = subtitle(for: moyasar) {
                            Text(subtitle)
                                .expoSystemFont(size: FontSize.small, weight: .regular)
                                .foregroundColor(.grayTextColor)
                        }
                        if !isRefreshing, refreshError == nil, let installments = instalmentText(option) {
                            Text(installments)
                                .expoSystemFont(size: FontSize.small, weight: .regular)
                                .foregroundColor(.grayTextColor)
                        }
                        if !isAvailable {
                            Text(option.isAvailable != true ? unavailableReason(option) : "Apple Pay is currently unavailable.".localized)
                                .expoSystemFont(size: FontSize.small, weight: .regular)
                                .foregroundColor(.grayTextColor)
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(usesBorderedCards ? 14 : 12)
                .contentShape(Rectangle())
            }
            .disabled(!isAvailable || isRefreshing || !isSelectionEnabled)
            .accessibilityAddTraits(isSelected ? .isSelected : [])

            if isSelected, isAvailable, option.id == 2 || option.id == 4,
               !isRefreshing, refreshError == nil, isSelectionEnabled,
               let amount = paymentAmount {
                Group {
                    if option.id == 4 {
                        TabbyInstallmentView(amount: amount, currency: currency, isEmbedded: true)
                    } else {
                        TamaraInstallmentView(amount: amount, currency: currency, isEmbedded: true)
                    }
                }
                .padding(12)
                .background {
                    if option.id == 4 { Color.clear.glassyBackground(cornerRadius: 12) }
                }
                .overlay {
                    if option.id != 4 {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.white.opacity(0.85), lineWidth: 1)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .background { paymentCardBackground(isSelected: isSelected && isAvailable) }
    }

    @ViewBuilder
    private func paymentCardBackground(isSelected: Bool) -> some View {
        if usesBorderedCards {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(isSelected ? Color.mainColor.opacity(0.05) : Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(isSelected ? Color.mainColor : Color.borderColor, lineWidth: isSelected ? 2 : 1)
                }
                .shadow(color: Color.mainColor.opacity(isSelected ? 0.08 : 0.025), radius: 8, x: 0, y: 3)
        } else {
            Color.clear.glassyBackground(cornerRadius: 10)
        }
    }

    @ViewBuilder
    private func paymentIcon(for id: Int?, moyasar: MoyasarPaymentMethod?) -> some View {
        if moyasar == .applePay {
            HStack(spacing: 1) {
                Image(systemName: "apple.logo")
                Text("Pay").fontWeight(.semibold)
            }
            .font(.system(size: 17))
            .foregroundColor(.black)
        } else if let icon = paymentIconName(for: id) {
            Image(icon)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: id == 1 ? 24 : 64, height: 28)
        }
    }

    private func title(for option: OrderPaymentOption, moyasar: MoyasarPaymentMethod?) -> String {
        switch moyasar {
        case .applePay: return "Apple Pay"
        case .card: return "Mada or credit card".localized
        case nil: return option.name ?? ""
        }
    }

    private func subtitle(for moyasar: MoyasarPaymentMethod?) -> String? {
        switch moyasar {
        case .applePay: return "Pay securely with Apple Pay".localized
        case .card: return "Mada, Visa and Mastercard".localized
        case nil: return nil
        }
    }

    private func paymentIconName(for methodID: Int?) -> String? {
        switch methodID {
        case 1: return "creditCard"
        case 4: return "tabbyLogo"
        case 2: return "tamaraLogo"
        default: return nil
        }
    }

    private func unavailableReason(_ option: OrderPaymentOption) -> String {
        guard let reason = option.unavailableReason, !reason.isEmpty else {
            return "This payment method is currently unavailable.".localized
        }
        return reason
    }

    private func instalmentText(_ option: OrderPaymentOption) -> String? {
        guard option.isAvailable == true, let count = option.instalmentsCount, count > 0,
              let amount = option.instalmentAmount, amount > 0,
              let currency = option.currency, !currency.isEmpty else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: Language.currentLanguage())
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        guard let amountText = formatter.string(from: NSNumber(value: amount)) else { return nil }
        return String(format: "%d payments × %@ %@".localized, count, amountText, currency.localized)
    }
}
