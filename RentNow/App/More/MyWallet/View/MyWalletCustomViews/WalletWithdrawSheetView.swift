//
//  WalletWithdrawSheetView.swift
//  RentNow
//

import SwiftUI

struct WalletWithdrawSheetView: View {
    var balance: Double
    var onClose: () -> Void
    var onConfirm: (Double, String, String, String, String) -> Void

    @State private var amount: String = ""
    @State private var iban: String = ""
    @State private var accountName: String = ""
    @State private var accountNumber: String = ""
    @State private var bankName: String = ""

    @State private var amountError: String? = nil
    @State private var ibanError: String? = nil
    @State private var accountNameError: String? = nil
    @State private var accountNumberError: String? = nil
    @State private var bankNameError: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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

                Text("Withdraw Balance".localized)
                    .expoSystemFont(size: FontSize.large, weight: .bold)
                    .foregroundColor(.mainColor)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 16)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    AppTextView(
                        title: "",
                        image: "",
                        placeHolder: "Enter amount".localized,
                        keyboardType: .decimalPad,
                        text: $amount,
                        textError: $amountError
                    )

                    AppTextView(
                        title: "",
                        image: "",
                        placeHolder: "IBAN".localized,
                        text: $iban,
                        textError: $ibanError
                    )

                    AppTextView(
                        title: "",
                        image: "",
                        placeHolder: "Account Name".localized,
                        text: $accountName,
                        textError: $accountNameError
                    )

                    AppTextView(
                        title: "",
                        image: "",
                        placeHolder: "Account Number".localized,
                        keyboardType: .numberPad,
                        text: $accountNumber,
                        textError: $accountNumberError
                    )

                    AppTextView(
                        title: "",
                        image: "",
                        placeHolder: "Bank Name".localized,
                        text: $bankName,
                        textError: $bankNameError
                    )

                    MainButton(title: "Confirm".localized) {
                        confirm()
                    }
                    .padding(.top, 4)
                }
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(MainGradientView().ignoresSafeArea())
        .logViewAppearance()
    }

    private func confirm() {
        let required = "This field is required".localized

        ibanError = iban.trimmingCharacters(in: .whitespaces).isEmpty ? required : nil
        accountNameError = accountName.trimmingCharacters(in: .whitespaces).isEmpty ? required : nil
        accountNumberError = accountNumber.trimmingCharacters(in: .whitespaces).isEmpty ? required : nil
        bankNameError = bankName.trimmingCharacters(in: .whitespaces).isEmpty ? required : nil

        guard let value = Double(amount), value > 0 else {
            amountError = "Please enter a valid amount".localized
            return
        }
        guard value <= balance else {
            amountError = "Amount exceeds your balance".localized
            return
        }
        amountError = nil

        guard ibanError == nil, accountNameError == nil,
              accountNumberError == nil, bankNameError == nil else {
            return
        }

        onConfirm(value, iban, accountName, accountNumber, bankName)
    }
}
