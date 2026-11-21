//
//  AuthCoordinator.swift
//  Holool
//
//  Created by Elshamy on 21/10/2025.
//

import SwiftUI
import CoreLocation

// MARK: - Auth Routes
enum AuthRoute: Hashable {
    case login
    case register
    case verification(countryCode: String, phoneNumber: String, currentType: ActiveType)
    case forgetPassword
    case resetPassword(activeCode: String, phoneNumber: String, countryCode: String)
    case locationPicker(isUserLocation: Bool)
    case termsAndConditions
}

// MARK: - Auth Coordinator Protocol
protocol AuthCoordinatorProtocol {
    func showRegisterScreen()
    func showActivationScreen(countryCode: String, phoneNumber: String, currentType: ActiveType)
    func forgetPassword()
    func resentPasswordScreen(activeCode: String, phoneNumber: String, countryCode: String)
    func showResetPasswordSuccessPopup()
    func showNafathVerificationPopup()
    func showTermsAndConditions()
    func popToRoot()
    func closeView()
}

// MARK: - Auth Coordinator
@MainActor
final class AuthCoordinator: BaseCoordinator<AuthRoute>, AuthCoordinatorProtocol {

    var onLocationComplete: (() -> Void)?

    override init() {
        super.init()
    }

    // MARK: - View Builder
    @ViewBuilder
    func buildAuthFlow() -> some View {
        NavigationStack(path: bindingPath) {
            makeView(for: .login)
                .navigationDestination(for: AuthRoute.self) { route in
                    self.makeView(for: route)
                }
        }
        .withCoordinatorPresentation(self)
    }

    @ViewBuilder
    func buildLocationPickerFlow() -> some View {
        let viewModel = LocationPickerViewModel()
        LocationPickerView(
            viewModel: viewModel,
            onSelect: { [weak self] coordinate, address in
                self?.onLocationComplete?()
            },
            isUserLocation: true
        )
    }

    @ViewBuilder
    private func makeView(for route: AuthRoute) -> some View {
        switch route {
        case .login:
            let viewModel = LoginViewModel()
            LoginView(coordinator: self, onFinish: { [weak self] in
                self?.onFinish?()
            }, viewModel: viewModel)

        case .register:
            let viewModel = RegisterViewModel()
            RegisterView(coordinator: self, viewModel: viewModel)

        case .verification(let countryCode, let phoneNumber, let currentType):
            let viewModel = VerificationCodeViewModel(
                activeCodeData: .init(
                    phoneNumber: phoneNumber,
                    countryCode: countryCode,
                    currentType: currentType
                )
            )
            VerificationCodeView(coordinator: self, viewModel: viewModel)
                .onFinishHandler { [weak self] in
                    if UserDefaults.user?.lat == nil || UserDefaults.user?.lng == nil || UserDefaults.user?.mapDesc == nil {
                        self?.push(.locationPicker(isUserLocation: true))
                    } else {
                        self?.onFinish?()
                    }
                }

        case .forgetPassword:
            let viewModel = ForgetPasswordViewModel()
            ForgetPasswordView(coordinator: self, viewModel: viewModel)

        case .resetPassword(let activeCode, let phoneNumber, let countryCode):
            let viewModel = ResetPasswordViewModel(activeCode: activeCode, phoneNumber: phoneNumber, countryCode: countryCode)
            ResetPasswordView(coordinator: self, viewModel: viewModel)

        case .locationPicker(let isUserLocation):
            let viewModel = LocationPickerViewModel()
            LocationPickerView(
                viewModel: viewModel,
                onSelect: { [weak self] coordinate, address in
                    self?.onFinish?()
                },
                isUserLocation: isUserLocation
            )

        case .termsAndConditions:
            InfoContentView(viewModel: InfoContentViewModel(type: .termsAndConditions))
        }
    }

    // MARK: - AuthCoordinatorProtocol

    func showRegisterScreen() {
        push(.register)
    }

    func showActivationScreen(countryCode: String, phoneNumber: String, currentType: ActiveType) {
        push(.verification(countryCode: countryCode, phoneNumber: phoneNumber, currentType: currentType))
    }

    func forgetPassword() {
        push(.forgetPassword)
    }

    func resentPasswordScreen(activeCode: String, phoneNumber: String, countryCode: String) {
        push(.resetPassword(activeCode: activeCode, phoneNumber: phoneNumber, countryCode: countryCode))
    }

    func showTermsAndConditions() {
        push(.termsAndConditions)
    }

    func closeView() {
        close()
    }

    func showResetPasswordSuccessPopup() {
        let successView = SuccessView(
            title: "reset_password_success_title".localized,
            subtitle: "reset_password_success_subtitle".localized
        ) { [weak self] in
            self?.dismiss()
            // Wait for popup dismiss animation (0.3s) to complete before navigating
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self?.popToRoot()
            }
        }
        presentAsPopup(successView)
    }

    func showNafathVerificationPopup() {
        let popupView = NafathVerificationPopupView { [weak self] in
            self?.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self?.onFinish?()
            }
        }
        presentAsPopup(popupView)
    }
}

// MARK: - OnFinish Handler View Modifier
private struct OnFinishHandlerModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                // Store the callback for later use
            }
    }
}

extension View {
    func onFinishHandler(_ action: @escaping () -> Void) -> some View {
        self
    }
}
