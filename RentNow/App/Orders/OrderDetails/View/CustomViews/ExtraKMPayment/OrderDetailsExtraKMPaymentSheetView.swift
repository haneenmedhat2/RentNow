//
//  OrderDetailsExtraKMPaymentSheetView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsExtraKMPaymentSheetView: View {
    let paymentMethods: [OrderPaymentMethod]
    @State private var selectedValue: String?
    @State private var moyasarMethod: MoyasarPaymentMethod = .card
    @State private var isConfirming = false
    var onConfirm: (String?, MoyasarPaymentMethod) -> Void
    var onClose: () -> Void

    private var canConfirm: Bool {
        guard let selectedValue,
              let selected = paymentMethods.first(where: { $0.value == selectedValue && $0.disabled != true }) else { return false }
        return selected.paymentOption?.id != 1 || moyasarMethod != .applePay || MoyasarConfiguration.canUseApplePay
    }

    init(paymentMethods: [OrderPaymentMethod], selectedValue: String?, onConfirm: @escaping (String?, MoyasarPaymentMethod) -> Void, onClose: @escaping () -> Void) {
        self.paymentMethods = paymentMethods
        self._selectedValue = State(initialValue: selectedValue)
        self.onConfirm = onConfirm
        self.onClose = onClose
    }

    var body: some View {
        ZStack {
            MainGradientView()
            VStack(spacing: 24) {
            // Header
            HStack {
                Button {
                    onClose()
                } label: {
                    Image("closeButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                }

                Text("Payment".localized)
                    .expoSystemFont(size: FontSize.large, weight: .semiBold)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            // Subtitle
            HStack {
                Text("Select payment method".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 24)

            // Payment Methods
            VStack(spacing: 8) {
                ForEach(paymentMethods) { method in
                    if method.paymentOption?.id == 1 {
                        extraMethodRow(method, moyasar: .applePay)
                        extraMethodRow(method, moyasar: .card)
                    } else {
                        extraMethodRow(method)
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Confirm Button
            MainButton(title: "Confirm".localized) {
                confirmSelectedMethod()
            }
            .disabled(!canConfirm || isConfirming)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            }
        }
        .logViewAppearance()
    }

    private func extraMethodRow(_ method: OrderPaymentMethod, moyasar: MoyasarPaymentMethod? = nil) -> some View {
        let available = method.disabled != true && (moyasar != .applePay || MoyasarConfiguration.canUseApplePay)
        let selected = selectedValue == method.value && (moyasar == nil || moyasarMethod == moyasar)
        return Button {
            selectedValue = method.value
            if let moyasar { moyasarMethod = moyasar }
            if moyasar == .applePay {
                confirmSelectedMethod(value: method.value, moyasarMethod: .applePay)
            }
        } label: {
            HStack(spacing: 12) {
                RadioButton(isSelected: selected).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(moyasar == .applePay ? "Apple Pay" : moyasar == .card ? "Mada or credit card".localized : (method.text ?? ""))
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                    if moyasar == .applePay && !MoyasarConfiguration.canUseApplePay {
                        Text("Apple Pay is currently unavailable.".localized)
                            .expoSystemFont(size: FontSize.small, weight: .regular)
                    }
                }
                Spacer()
            }
            .foregroundColor(available ? .black : .gray)
            .padding(12)
            .glassyBackground(cornerRadius: 10)
        }
        .disabled(!available)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private func confirmSelectedMethod(value: String? = nil, moyasarMethod: MoyasarPaymentMethod? = nil) {
        let selectedValue = value ?? self.selectedValue
        let selectedMoyasarMethod = moyasarMethod ?? self.moyasarMethod
        guard !isConfirming,
              let selectedValue,
              let selected = paymentMethods.first(where: { $0.value == selectedValue && $0.disabled != true }),
              selected.paymentOption?.id != 1 || selectedMoyasarMethod != .applePay || MoyasarConfiguration.canUseApplePay else { return }

        isConfirming = true
        onConfirm(selectedValue, selectedMoyasarMethod)
    }

}

