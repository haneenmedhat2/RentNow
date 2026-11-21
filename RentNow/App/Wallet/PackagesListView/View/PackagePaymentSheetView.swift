import SwiftUI

struct PackagePaymentSheetView: View {
    let package: PackageItem
    let onClose: () -> Void
    let onConfirm: (Int, MoyasarPaymentMethod) -> Void
    @StateObject private var viewModel = AmountPaymentOptionsViewModel()
    @State private var isConfirming = false

    private var formattedPrice: String {
        (package.price ?? 0).formatted(.number.locale(Locale(identifier: Language.currentLanguage())).precision(.fractionLength(2)))
    }

    private var confirmationTitle: String {
        String(format: "package_payment_continue".localized, formattedPrice, "SAR".localized)
    }

    private var orderedOptions: [OrderPaymentOption] {
        let order = [1: 0, 2: 1, 4: 2]
        return viewModel.paymentOptions
            .filter { option in
                option.id != 2 && option.id != 4 || meetsInstallmentMinimum
            }
            .sorted { order[$0.id ?? -1, default: 3] < order[$1.id ?? -1, default: 3] }
    }

    private var meetsInstallmentMinimum: Bool {
        guard let price = package.price, price.isFinite else { return false }
        return price >= 1_000
    }

    private var canConfirm: Bool {
        viewModel.canConfirm && !isConfirming &&
        OrderPaymentOption.validSelection(viewModel.selectedMethodId, in: orderedOptions) != nil
    }

    private var packageDetails: String {
        let localizedDescription = Language.isRTL() ? package.descriptionAr : package.descriptionEn
        let description = (localizedDescription?.isEmpty == false ? localizedDescription : package.description) ?? ""
        var details = description.isEmpty ? [] : [description]
        if let days = package.durationInDays, days > 0 {
            details.append(String(format: "package_payment_duration".localized, days))
        }
        if let discount = package.discountPercentage, discount > 0 {
            let percentage = discount.formatted(.number.precision(.fractionLength(0...2)))
            details.append("\("Discount percentage".localized): \(percentage)%")
        }
        if let count = package.waivedDeliveryFeesOrdersCount, count > 0 {
            details.append("\("Number of free delivery times".localized): \(count)")
        }
        return details.joined(separator: "\n")
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                PackagePaymentHeaderView(
                    packageName: package.name ?? "",
                    priceText: formattedPrice,
                    detailsText: packageDetails,
                    onClose: onClose
                )

                VStack(spacing: 12) {
                    ForEach(orderedOptions) { option in
                        if option.id == 1 {
                            paymentRow(option, moyasar: .applePay)
                            paymentRow(option, moyasar: .card)
                        } else {
                            VStack(spacing: 8) {
                                paymentRow(option)
                                installmentWidget(for: option)
                            }
                        }
                    }

                    if viewModel.isCheckingEligibility {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("Updating payment options...".localized)
                                .expoSystemFont(size: FontSize.small)
                        }
                        .foregroundStyle(PackagePaymentStyle.secondaryText)
                    } else if let error = viewModel.eligibilityError {
                        Text(error)
                            .expoSystemFont(size: FontSize.small)
                            .foregroundStyle(.red)
                        Button("Retry".localized) {
                            Task { await viewModel.checkEligibility() }
                        }
                        .foregroundStyle(PackagePaymentStyle.navy)
                        .disabled(isConfirming)
                    } else if orderedOptions.isEmpty {
                        Text("No payment methods are currently available.".localized)
                            .expoSystemFont(size: FontSize.small)
                            .foregroundStyle(PackagePaymentStyle.secondaryText)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            PackagePaymentFooterView(
                buttonTitle: confirmationTitle,
                isEnabled: canConfirm,
                onConfirm: {
                    guard canConfirm, let method = viewModel.selectedMethodId else { return }
                    isConfirming = true
                    onConfirm(method, viewModel.moyasarMethod)
                }
            )
        }
        .background(Color.white.ignoresSafeArea())
        .presentationBackground(.white)
        .environment(\.layoutDirection, Language.isRTL() ? .rightToLeft : .leftToRight)
        .logViewAppearance()
        .task {
            viewModel.moyasarMethod = MoyasarConfiguration.canUseApplePay ? .applePay : .card
            // The user cannot edit the server-provided package price.
            viewModel.amount = String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), package.price ?? 0)
            await viewModel.checkEligibility()
        }
    }

    @ViewBuilder
    private func installmentWidget(for option: OrderPaymentOption) -> some View {
        if meetsInstallmentMinimum, option.isAvailable == true,
           viewModel.selectedMethodId == option.id,
           !viewModel.isCheckingEligibility, viewModel.eligibilityError == nil,
           let amount = viewModel.validAmount {
            Group {
                if option.id == 4 {
                    TabbyInstallmentView(amount: amount, currency: "SAR", isEmbedded: true)
                } else if option.id == 2 {
                    TamaraInstallmentView(amount: amount, currency: "SAR", isEmbedded: true)
                }
            }
            .padding(12)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(PackagePaymentStyle.border, lineWidth: 1)
            }
        }
    }

    private func paymentRow(_ option: OrderPaymentOption, moyasar: MoyasarPaymentMethod? = nil) -> some View {
        let isAvailable = option.isAvailable == true && (moyasar != .applePay || MoyasarConfiguration.canUseApplePay)
        let isSelected = viewModel.selectedMethodId == option.id && (moyasar == nil || viewModel.moyasarMethod == moyasar)
        return PackagePaymentMethodRowView(
            title: paymentTitle(option, moyasar: moyasar),
            subtitle: paymentSubtitle(option, moyasar: moyasar, isAvailable: isAvailable),
            badge: moyasar == .applePay ? .applePay : (moyasar == .card ? .card : .installments(option.instalmentsCount)),
            isSelected: isSelected,
            isEnabled: isAvailable && viewModel.validAmount != nil && !viewModel.isCheckingEligibility && !isConfirming,
            onSelect: {
                guard let id = option.id else { return }
                if let moyasar { viewModel.moyasarMethod = moyasar }
                viewModel.selectMethod(id)
                if moyasar == .applePay, canConfirm {
                    isConfirming = true
                    onConfirm(1, .applePay)
                }
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
        case nil: return (option.id == 4 ? "package_payment_tabby_hint" : "package_payment_installment_hint").localized
        }
    }
}
