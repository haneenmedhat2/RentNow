//
//  LoginView.swift
//  RentNow
//
//  Created by Elshamy on 27/10/2025.
//

import SwiftUI
import UIKit

struct LoginView: View {
    var coordinator: AuthCoordinatorProtocol?
    var onFinish: (() -> Void)?

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {
                VStack(spacing: 0) {
                    // Top bar with language toggle and visitor button
                    HStack {
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: 6) {
                                Text(Language.currentLang() == .arabic ? "🇸🇦" : "🇺🇸")
                                    .font(.system(size: 22))
                                Text(Language.currentLang() == .arabic ? "العربية" : "English")
                                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                                    .foregroundColor(.black.opacity(0.6))
                            }
                        }

                        Spacer()

                        Button(action: {
                            UserDefaults.isVisitor = true
                            UserDefaults.isLogin = false
                            UserDefaults.isFirstTime = false
                            UserDefaults.accessToken = nil
                            UserDefaults.user = nil
                            onFinish?()
                        }) {
                            Text("Login as visitor".localized)
                                .expoSystemFont(size: FontSize.normal, weight: .medium)
                                .foregroundColor(.black.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 32) {
                            // Header
                            LoginHeaderView(onVisitorTap: {})
                                .padding(.top, 20)

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
                                }

                                ForgetPasswordButton {
                                    coordinator?.forgetPassword()
                                }
                            }

                            // Login button
                            MainButton(title: "Login".localized) {

                                viewModel.callApi()
                            }
                            .padding(.top, 8)
                            
                            // Register button at bottom
                            RegisterButton(action: {
                                coordinator?.showRegisterScreen()
                            })

                        }
                    }

                   
                }
            }
            .onReceive(viewModel.loginEvent) { event in
                switch event {
                case .success:
                    onFinish?()
                case .needsActivation(let countryCode, let phone):
                    coordinator?.showActivationScreen(countryCode: countryCode, phoneNumber: phone, currentType: .activeAccount)
                }
            }
        }
    }
}
