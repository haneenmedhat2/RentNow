//
//  WalletRechargeSheetView.swift
//  RentNow
//

import SwiftUI

struct WalletRechargeSheetView: View {
    var onClose: () -> Void
    var onConfirm: (Double, Int, MoyasarPaymentMethod) -> Void

    @StateObject private var viewModel = AmountPaymentOptionsViewModel()
    @State private var amountError: String? = nil
    @State private var isConfirming = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack(spacing: 12) {
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.red)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(Color.white.opacity(0.6)))
                    }

                    Text("Recharge Balance".localized)
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                        .foregroundColor(.mainColor)

                    Spacer()
                }
                .padding(.horizontal, 16)

                // Amount field
                AppTextView(
                    title: "",
                    image: "",
                    placeHolder: "Enter amount".localized,
                    keyboardType: .decimalPad,
                    text: $viewModel.amount,
                    textError: $amountError
                )

                if viewModel.validAmount != nil {
                    VStack(spacing: 12) {
                        ForEach(visiblePaymentOptions) { option in
                            if option.id == 1 {
                                paymentRow(option, moyasar: .applePay)
                                paymentRow(option, moyasar: .card)
                            } else {
                                paymentRow(option)
                            }
                        }

                        if viewModel.isCheckingEligibility {
                            HStack(spacing: 8) {
                                ProgressView()
                                Text("Updating payment options...".localized)
                                    .expoSystemFont(size: FontSize.small)
                            }
                        } else if let error = viewModel.eligibilityError {
                            Text(error)
                                .expoSystemFont(size: FontSize.small)
                                .foregroundColor(.red)
                            Button("Retry".localized) {
                                Task { await viewModel.checkEligibility() }
                            }
                            .foregroundColor(.mainColor)
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Confirm
                MainButton(title: "Confirm".localized) {
                    confirm()
                }
                .disabled(!viewModel.canConfirm || isConfirming)

                Spacer(minLength: 0)
            }
            .padding(.top, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(MainGradientView().ignoresSafeArea())
        .environment(\.layoutDirection, Language.isRTL() ? .rightToLeft : .leftToRight)
        .task(id: viewModel.amount) { await viewModel.checkEligibility() }
        .logViewAppearance()
    }

    private func confirm() {
        guard !isConfirming, viewModel.canConfirm, let value = viewModel.validAmount, let method = viewModel.selectedMethodId else {
            amountError = "Please enter a valid amount".localized
            return
        }
        amountError = nil
        isConfirming = true
        onConfirm(value, method, viewModel.moyasarMethod)
    }

    private var visiblePaymentOptions: [OrderPaymentOption] {
        guard (viewModel.validAmount ?? 0) < 1_000 else { return viewModel.paymentOptions }
        return viewModel.paymentOptions.filter { $0.id != 2 && $0.id != 4 }
    }

    private func paymentRow(_ option: OrderPaymentOption, moyasar: MoyasarPaymentMethod? = nil) -> some View {
        let isAvailable = option.isAvailable == true && (moyasar != .applePay || MoyasarConfiguration.canUseApplePay)
        let isSelected = viewModel.selectedMethodId == option.id && (moyasar == nil || viewModel.moyasarMethod == moyasar)

        return WalletPaymentMethodRowView(
            title: paymentTitle(option, moyasar: moyasar),
            subtitle: paymentSubtitle(option, moyasar: moyasar, isAvailable: isAvailable),
            badge: moyasar == .applePay ? .applePay : (moyasar == .card ? .card : .installments(option.instalmentsCount)),
            isSelected: isSelected,
            isEnabled: isAvailable && !viewModel.isCheckingEligibility && !isConfirming,
            onSelect: {
                guard let id = option.id else { return }
                if let moyasar { viewModel.moyasarMethod = moyasar }
                viewModel.selectMethod(id)
                if moyasar == .applePay { confirm() }
            }
        )
    }

    private func paymentTitle(_ option: OrderPaymentOption, moyasar: MoyasarPaymentMethod?) -> String {
        switch moyasar {
        case .applePay: return "Apple Pay"
        case .card: return "Mada or credit card".localized
        case nil: return option.name ?? ""
        }
    }

    private func paymentSubtitle(_ option: OrderPaymentOption, moyasar: MoyasarPaymentMethod?, isAvailable: Bool) -> String {
        guard isAvailable else {
            if option.isAvailable == true { return "Apple Pay is currently unavailable.".localized }
            return option.unavailableReason.flatMap { $0.isEmpty ? nil : $0 }
                ?? "This payment method is currently unavailable.".localized
        }
        switch moyasar {
        case .applePay: return "package_payment_apple_pay_hint".localized
        case .card: return "Mada, Visa and Mastercard".localized
        case nil: return option.id == 4 ? "package_payment_tabby_hint".localized : "package_payment_installment_hint".localized
        }
    }

}

private struct WalletPaymentMethodRowView: View {
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
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                selectionIndicator

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                        .foregroundColor(.black)
                    Text(subtitle)
                        .expoSystemFont(size: FontSize.small)
                        .foregroundColor(.grayTextColor)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

                badgeView
                    .frame(width: 66, height: 46)
                    .background(Color.gray.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                    .accessibilityHidden(true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 82)
            .background(usesTintedBackground ? Color.mainColor.opacity(0.05) : .white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(isSelected ? Color.mainColor : Color.borderColor, lineWidth: isSelected ? 2 : 1)
            }
            .opacity(isEnabled ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var selectionIndicator: some View {
        ZStack {
            Circle().fill(isSelected ? Color.mainColor : .white)
            Circle().strokeBorder(isSelected ? Color.mainColor : Color.gray.opacity(0.65), lineWidth: 2)
            if isSelected { Circle().fill(.white).frame(width: 8, height: 8) }
        }
        .frame(width: 22, height: 22)
        .accessibilityHidden(true)
    }

    private var usesTintedBackground: Bool {
        switch badge {
        case .applePay, .installments:
            return true
        case .card:
            return isSelected
        }
    }

    @ViewBuilder
    private var badgeView: some View {
        switch badge {
        case .applePay:
            Text(verbatim: "Pay")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.mainColor)
        case .card:
            Image(systemName: "creditcard.fill")
                .font(.system(size: 18))
                .foregroundColor(.mainColor)
        case .installments(let count):
            Text(verbatim: "×\(count ?? 4)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.grayTextColor)
                .environment(\.layoutDirection, .leftToRight)
        }
    }
}
