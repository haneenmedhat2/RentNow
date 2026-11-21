//
//  RegisterView.swift
//  Holool
//
//  Created by Elshamy on 09/11/2025.
//

import SwiftUI

struct RegisterView: View {

    var coordinator: AuthCoordinatorProtocol?
    @ObservedObject var viewModel: RegisterViewModel
    @State private var profileMediaItems: [MediaItem] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 32) {

                            // MARK: - Header
                            RegisterHeaderView()
                                .padding(.top, 20)

                            // MARK: - Form Fields
                            VStack(spacing: 16) {

                                // MARK: - Profile Image (Optional)
                                ProfileImagePickerView(
                                    mediaItems: $profileMediaItems,
                                    imageData: $viewModel.profileImage
                                )

                                // MARK: - Full Name Field
                                AppTextView(
                                    title: "Full name".localized,
                                    image: "",
                                    placeHolder: "Full name".localized,
                                    isRequired: true,
                                    text: $viewModel.name,
                                    textError: $viewModel.nameError
                                )
                                .onChange(of: viewModel.name) { _ in
                                    viewModel.nameError = nil
                                }

                                // MARK: - Phone Field
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

                                // MARK: - National ID Field
                                AppTextView(
                                    title: "National ID".localized,
                                    image: "",
                                    placeHolder: "National ID".localized,
                                    keyboardType: .numberPad,
                                    isRequired: true,
                                    text: $viewModel.nationalId,
                                    textError: $viewModel.nationalIdError
                                )
                                .onChange(of: viewModel.nationalId) { _ in
                                    viewModel.nationalIdError = nil
                                }

                                // MARK: - Country Picker
                                AppPickerField(
                                    title: "Country".localized,
                                    imageName: "",
                                    items: viewModel.countriesArray,
                                    selectedItem: $viewModel.country,
                                    errorMessage: viewModel.countryError ?? "",
                                    isRequired: true
                                )
                                .onChange(of: viewModel.country) { newCountry in
                                    viewModel.countryError = nil
                                    viewModel.onCountrySelected(newCountry)
                                }

                                // MARK: - City Picker
                                AppPickerField(
                                    title: "City".localized,
                                    imageName: "",
                                    items: viewModel.citiesArray,
                                    selectedItem: $viewModel.city,
                                    errorMessage: viewModel.cityError ?? "",
                                    isRequired: true
                                )
                                .onChange(of: viewModel.city) { _ in
                                    viewModel.cityError = nil
                                }

                                // MARK: - Password Field
                                PasswordTextView(
                                    title: "Password".localized,
                                    password: $viewModel.password,
                                    passwordError: $viewModel.passwordError,
                                    hasEditedPassword: .constant(false),
                                    showErrorAlways: true,
                                    isRequired: true
                                )
                                .onChange(of: viewModel.password) { _ in
                                    viewModel.passwordError = nil
                                    viewModel.confirmPasswordError = nil
                                }

                                // MARK: - Password Hint
                                HStack(spacing: 4) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 12))
                                    Text("Password must contain letters, numbers and symbols".localized)
                                        .expoSystemFont(size: FontSize.small, weight: .regular)
                                }
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.top, -8)

                                // MARK: - Confirm Password
                                PasswordTextView(
                                    title: "Confirm password".localized,
                                    password: $viewModel.confirmPassword,
                                    passwordError: $viewModel.confirmPasswordError,
                                    hasEditedPassword: .constant(false),
                                    showErrorAlways: true,
                                    isRequired: true
                                )
                                .onChange(of: viewModel.confirmPassword) { _ in
                                    viewModel.passwordError = nil
                                    viewModel.confirmPasswordError = nil
                                }

                                // MARK: - Terms and Conditions
                                TermsAndConditionsButton(
                                    isChecked: $viewModel.isAgree,
                                    agreeError: viewModel.agreeError
                                ) {
                                    coordinator?.showTermsAndConditions()
                                }
                                .onChange(of: viewModel.isAgree) { _ in
                                    viewModel.agreeError = nil
                                }
                            }

                            // MARK: - Register Button
                            MainButton(title: "Create account".localized) {
                          

                                viewModel.callApi()
                            }
                            .padding(.top, 8)

                            // MARK: - Login Button
                            LoginButton {
                                dismiss()
                            }
                        }
                    }
                }
            }
            .onChange(of: viewModel.successMessage) { _ in
                let code = PhoneTextView.getCountryCodeOrDefault(viewModel.countryCode)
                coordinator?.showActivationScreen(
                    countryCode: code,
                    phoneNumber: viewModel.phoneNumber,
                    currentType: .activeAccount
                )
            }
        }
    }
}
