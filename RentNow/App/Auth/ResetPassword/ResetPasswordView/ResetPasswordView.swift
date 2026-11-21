//
//  LoginView.swift
//  Holool
//
//  Created by Elshamy on 27/10/2025.
//

import SwiftUI

struct ResetPasswordView: View {

    var coordinator: AuthCoordinatorProtocol?

    @ObservedObject var viewModel: ResetPasswordViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {
                VStack(spacing: 0) {

                        VStack(spacing: 48) {
                            ResetPasswordHeaderView()
                                VStack(spacing: 16) {

                                    // MARK: - Password Field
                                    PasswordTextView(
                                        title: "reset_password_field".localized,
                                        password: $viewModel.password,
                                        passwordError: $viewModel.passwordError,
                                        hasEditedPassword: .constant(false),
                                        showErrorAlways: true
                                    )
                                    .onChange(of: viewModel.password) { _ in
                                        viewModel.passwordError = nil
                                        viewModel.confirmPasswordError = nil
                                    }

                                    // MARK: - Password Hint
                                    HStack(spacing: 8) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color.black.opacity(0.6))
                                            .font(.system(size: 14))
                                        Text("reset_password_hint".localized)
                                            .expoSystemFont(size: FontSize.small, weight: .regular)
                                            .foregroundColor(Color.black.opacity(0.6))
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)

                                    // MARK: - Confirm Password
                                    PasswordTextView(
                                        title: "reset_password_confirm_field".localized,
                                        password: $viewModel.confirmPassword,
                                        passwordError: $viewModel.confirmPasswordError,
                                        hasEditedPassword: .constant(false),
                                        showErrorAlways: true
                                    )
                                    .onChange(of: viewModel.confirmPassword) { _ in
                                        viewModel.passwordError = nil
                                        viewModel.confirmPasswordError = nil
                                    }

                                    MainButton(title: "reset_password_button".localized) {
                                        viewModel.callApi()
                                    }

                                }



                        }




                }
            }
            Spacer()
        }
        .onChange(of: viewModel.showSuccessOverlay) { showSuccess in
            if showSuccess {
                coordinator?.showResetPasswordSuccessPopup()
            }
        }
    }
}

