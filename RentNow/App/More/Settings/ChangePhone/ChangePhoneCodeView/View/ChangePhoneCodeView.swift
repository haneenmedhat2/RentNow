//
//  ChangePhoneCodeView.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI

struct ChangePhoneCodeView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ChangePhoneCodeViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 24) {

                // MARK: - Subtitle
                Text("Enter the code sent to your phone to verify your identity and change the phone number".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)

                // MARK: - OTP Fields
                OTPView(
                    code: $viewModel.code,
                    showValidationError: $viewModel.showValidationError
                )
                .onChange(of: viewModel.code) { _ in
                    viewModel.showValidationError = false
                }

                // MARK: - Confirm Button
                VStack(spacing: 16) {
                    MainButton(title: "Confirm".localized) {
                        viewModel.confirmChangePhoneApi()
                    }

                    // MARK: - Timer
                    if !viewModel.canResend {
                        Text(viewModel.formattedTimeRemaining + " " + "verification_timer_seconds".localized)
                            .foregroundColor(.black)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                    }

                    // MARK: - Resend Button
                    ResendButton {
                        viewModel.resendCode()
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Change phone number".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .successPopup(
            message: "Phone number changed successfully".localized,
            isPresented: $viewModel.showSuccess
        )
        .onChange(of: viewModel.showSuccess) { newValue in
            if newValue == false {
                coordinator.popToSettings()
            }
        }
        .withGlobalToast()
    }
}
