//
//  ChangePhoneNumberView.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI

struct ChangePhoneNumberView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ChangePhoneNumberViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 24) {

                // MARK: - Subtitle
                Text("Please enter the new phone number to send verification code to verify your identity".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)

                // MARK: - Phone Field
                PhoneTextView(
                    phone: $viewModel.phone,
                    phoneError: $viewModel.phoneError,
                    hasEditedPhone: $viewModel.hasEditedPhone,
                    countryCode: $viewModel.countryCode,
                    countries: viewModel.countriesArray,
                    isRequired: true
                )

                Spacer()

                // MARK: - Next Button
                MainButton(title: "Next".localized) {
                    viewModel.requestChangePhoneApi()
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Change phone number".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.getCountries()
        }
        .onChange(of: viewModel.successMessage) { newValue in
            guard newValue != nil else { return }
            let phoneCode = PhoneTextView.getCountryCodeOrDefault(viewModel.countryCode)
            let phoneNumber = PhoneTextView.formatPhoneForApi(viewModel.phone, countryCode: viewModel.countryCode?.key)
            coordinator.showChangePhoneCode(phoneCode: phoneCode, newPhoneNumber: phoneNumber)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.successMessage = nil
            }
        }
    }
}
