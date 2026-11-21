//
//  VerificationCodeView.swift
//  Holool
//
//  Created by Elshamy on 11/11/2025.
//


import SwiftUI
import Combine

struct VerificationCodeView: View {

    var coordinator: AuthCoordinatorProtocol?
    @ObservedObject var viewModel: VerificationCodeViewModel
    var onFinish: (() -> Void)?

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 48) {

                            // MARK: - Header
                            VerificationHeaderView()

                            // MARK: - Form Fields
                            VStack(spacing: 24) {

                                // MARK: - OTP Fields
                                   OTPView(code: $viewModel.code,
                                                      showValidationError: .constant(viewModel.showValidationError))
                                   .onChange(of: viewModel.code) { _ in
                                       viewModel.codeError = nil
                                   }

                                // MARK: - Buttons
                                VStack(spacing: 16) {
                                     MainButton(title: "verification_code_button".localized) {
                                         viewModel.verifyCode()
                                     }

                                    // MARK: - Timer
                                    if viewModel.canResend == false {
                                        Text(viewModel.formattedTimeRemaining + " " + "verification_timer_seconds".localized)
                                            .foregroundColor(.black)
                                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                                    }

                                    // MARK: - Resend Button
                                    ResendButton {
                                        if viewModel.canResend == true {
                                            viewModel.resendCode()
                                        } else {
                                            ToastManager.shared.show(message: ("you can't resend code before".localized + " " + viewModel.formattedTimeRemaining + " " + "verification_timer_seconds".localized), type: .error)
                                        }
                                    }
                                }


                            }
                        }
                    }

                    // MARK: - Bottom Register Button


                }
                .onChange(of: viewModel.successMessage) { newValue in
                    guard newValue != nil else { return }

                    switch viewModel.activeCodeData?.currentType {
                    case .activeAccount:
                        coordinator?.showNafathVerificationPopup()

                    case .forgetPassword:
                        guard let phone = viewModel.activeCodeData?.phoneNumber,
                              let countryCode = viewModel.activeCodeData?.countryCode else { return }
                        coordinator?.resentPasswordScreen(activeCode: viewModel.code, phoneNumber: phone, countryCode: countryCode)
                    default:
                        break
                    }

                    // Clear successMessage after navigation to prevent double navigation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.successMessage = nil
                    }
                }
                .onAppear {
                    // Clear any previous success message when view appears
                    viewModel.successMessage = nil
                }
            }
        }
        .withGlobalToast()
    }
}
