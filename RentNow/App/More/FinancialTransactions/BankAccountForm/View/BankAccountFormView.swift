//
//  BankAccountFormView.swift
//  RentNow
//

import SwiftUI

struct BankAccountFormView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: BankAccountFormViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 16) {
                AppTextView(
                    title: "Bank Name".localized,
                    image: "",
                    placeHolder: "Bank Name".localized,
                    text: $viewModel.bankName,
                    textError: $viewModel.bankNameError
                )

                AppTextView(
                    title: "Account Number".localized,
                    image: "",
                    placeHolder: "Account Number".localized,
                    keyboardType: .numberPad,
                    text: $viewModel.accountNumber,
                    textError: $viewModel.accountNumberError
                )

                AppTextView(
                    title: "Account Holder Name".localized,
                    image: "",
                    placeHolder: "Account Holder Name".localized,
                    text: $viewModel.accountHolderName,
                    textError: $viewModel.accountHolderNameError
                )

                AppTextView(
                    title: "IBAN Number".localized,
                    image: "",
                    placeHolder: "IBAN Number".localized,
                    text: $viewModel.iban,
                    textError: $viewModel.ibanError
                )

                MainButton(title: "Confirm Send".localized) {
                    viewModel.submitSettlement()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.top, 16)
        }
        .navigationTitle("Bank Account Details".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}
