//
//  ChangePasswordView.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI

struct ChangePasswordView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ChangePasswordViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 24) {

                // MARK: - Current Password
                PasswordTextView(
                    title: "Current password".localized,
                    password: $viewModel.currentPassword,
                    passwordError: $viewModel.currentPasswordError,
                    hasEditedPassword: $viewModel.hasEditedCurrentPassword,
                    isRequired: true
                )
                .padding(.top, 24)

                // MARK: - New Password
                PasswordTextView(
                    title: "New password".localized,
                    password: $viewModel.newPassword,
                    passwordError: $viewModel.newPasswordError,
                    hasEditedPassword: $viewModel.hasEditedNewPassword,
                    isRequired: true
                )

                // MARK: - Password Hint
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))

                    Text("Password must contain letters, numbers and symbols".localized)
                        .expoSystemFont(size: FontSize.altraSmall, weight: .regular)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, -16)

                // MARK: - Confirm Password
                PasswordTextView(
                    title: "Confirm New Password".localized,
                    password: $viewModel.confirmPassword,
                    passwordError: $viewModel.confirmPasswordError,
                    hasEditedPassword: $viewModel.hasEditedConfirmPassword,
                    isRequired: true
                )

                Spacer()

                // MARK: - Confirm Button
                MainButton(title: "Confirm".localized) {
                    viewModel.changePassword()
                }
                .padding(.bottom, 24)
            }
        }
        .successPopup(
            message: "Password changed successfully".localized,
            isPresented: $viewModel.showSuccess
        )
        .navigationTitle("Change password".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: viewModel.showSuccess) { newValue in
            if !newValue {
                coordinator.popToSettings()
            }
        }
    }
}
