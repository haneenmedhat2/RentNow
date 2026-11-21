//
//  MyWalletView.swift
//  RentNow
//

import SwiftUI
import Lottie

struct MyWalletView: View {
    let coordinator: MoreCoordinatorProtocol
    @StateObject private var viewModel: MyWalletViewModel

    init(coordinator: MoreCoordinatorProtocol, viewModel: MyWalletViewModel) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 24) {
                LottieSwiftUIView(animationName: "Wallet", loopMode: .loop)
                    .frame(width: 150, height: 150)
                    .padding(.top, 40)

                VStack(spacing: 6) {
                    Text("Current Balance".localized)
                        .expoSystemFont(size: FontSize.large, weight: .medium)
                        .foregroundColor(.secondaryDarkFont)

                    Text("\(viewModel.balance) " + "SAR".localized)
                        .expoSystemFont(size: 24, weight: .bold)
                        .foregroundColor(.mainColor)
                }

                HStack(spacing: 12) {
                    WalletActionButton(title: "Recharge".localized, isFilled: true) {
                        coordinator.showWalletRechargeSheet { amount, method, moyasarMethod in
                            viewModel.chargeWallet(amount: amount, paymentMethod: method, moyasarMethod: moyasarMethod)
                        }
                    }

                    WalletActionButton(title: "Withdraw".localized, isFilled: false) {
                        coordinator.showWalletWithdrawSheet(balance: viewModel.balance) { amount, iban, accountName, accountNumber, bankName in
                            viewModel.createWithdrawRequest(
                                amount: amount,
                                iban: iban,
                                accountName: accountName,
                                accountNumber: accountNumber,
                                bankName: bankName
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)

                Spacer()
            }
        }
        .navigationTitle("My Wallet".localized)
        .task {
            await viewModel.fetchBalance()
        }
        .onChange(of: viewModel.paymentSession) { _, session in
            guard let session else { return }
            coordinator.showPayment(session: session) { result in
                viewModel.handlePaymentResult(result)
            }
            viewModel.paymentSession = nil
        }
    }
}
