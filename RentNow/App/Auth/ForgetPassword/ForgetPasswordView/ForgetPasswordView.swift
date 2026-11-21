//
//  ForgetPasswordView.swift
//  RentNow
//
//  Created by Elshamy on 27/10/2025.
//

import SwiftUI

struct ForgetPasswordView: View {

    var coordinator: AuthCoordinatorProtocol?

    @ObservedObject var viewModel: ForgetPasswordViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 0) {

                    VStack(spacing: 40) {
                        // Header
                        ForgetPasswordHeaderView()

                        // Form fields
                        VStack(spacing: 16) {
                            PhoneTextView(
                                phone: $viewModel.phoneNumber,
                                phoneError: $viewModel.phoneError,
                                hasEditedPhone: .constant(false),
                                countryCode: $viewModel.countryCode,
                                countries: viewModel.countriesArray,
                                showErrorAlways: true,
                                countryCodeError: viewModel.countryCodeError,
                                isRequired: true
                            )
                            .onChange(of: viewModel.phoneNumber) { _ in
                                viewModel.phoneError = nil
                            }
                            .onChange(of: viewModel.countryCode) { _ in
                                viewModel.countryCodeError = nil
                            }
                        }

                        // Send button
                        MainButton(title: "forget_password_button".localized) {
                            viewModel.callApi()
                        }
                        .padding(.top, 8)
                    }
                

                Spacer()
            }
            .onChange(of: viewModel.successMessage) { newValue in
                guard newValue != nil else { return }
                guard let code = viewModel.countryCode?.key else { return }
                coordinator?.showActivationScreen(
                    countryCode: code,
                    phoneNumber: viewModel.phoneNumber,
                    currentType: .forgetPassword
                )
            }
            .onAppear {
                viewModel.successMessage = nil
            }
        }
    }
}

