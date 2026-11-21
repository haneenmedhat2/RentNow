//
//  ChangePhonePasswordView.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI

struct ChangePhonePasswordView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ChangePhonePasswordViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 24) {

                // MARK: - Subtitle
                Text("To change your phone number, please enter the current password".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)

                // MARK: - Password Field
                PasswordTextView(
                    title: "Current Password".localized,
                    password: $viewModel.password,
                    passwordError: $viewModel.passwordError,
                    hasEditedPassword: $viewModel.hasEditedPassword,
                    isRequired: true
                )

                Spacer()

                // MARK: - Next Button
                MainButton(title: "Next".localized) {
                    viewModel.validatePasswordApi()
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Change phone number".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: viewModel.successMessage) { newValue in
            guard newValue != nil else { return }
            coordinator.showChangePhoneNewNumber()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.successMessage = nil
            }
        }
    }
}
