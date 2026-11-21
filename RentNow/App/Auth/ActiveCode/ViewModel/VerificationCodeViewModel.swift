//
//  Untitled.swift
//  Holool
//
//  Created by Elshamy on 11/11/2025.
//

import SwiftUI
import Combine



final class VerificationCodeViewModel: BaseViewModel {
    
    // MARK: - Published Properties
    @Published var code: String = ""
    @Published var codeError: String? = nil
    @Published var timeRemaining: Int = 59
    @Published var canResend: Bool = false
    @Published var message: String? = nil

    private var timer: Timer?
    var activeCodeData: ActiveCodeModel?

    // Computed property for backward compatibility with OTPView
    var showValidationError: Bool {
        codeError != nil
    }

    // Computed property for formatted time (MM:SS)
    var formattedTimeRemaining: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init(activeCodeData: ActiveCodeModel,
         responseHandler: any ResponseHandler = DefaultResponseHandler()) {
        self.activeCodeData = activeCodeData
        super.init(responseHandler: responseHandler)
        startTimer()
    }

    // MARK: - Validation
    func validateCode() -> Bool {
        let error = ActiveCodeValidation.validateCodeForm(code: code)
        codeError = error

        return error == nil
    }
    
    // MARK: - Timer
    func startTimer() {
        timer?.invalidate()
        timeRemaining = 59
        canResend = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.canResend = true
            }
        }
    }
    
    // MARK: - Resend Code
    func resendCode() {
        if canResend {
            switch activeCodeData?.currentType {
            case .activeAccount:
                resendActiveCodeApi()
            case .forgetPassword:
                resendPasswordCodeApi()
            default:
                break
            }
           
        } else {
            message = "⏳ Please wait until the time is up before resubmitting.".localized
        }
    }
    
    // MARK: - Verify Code
    func verifyCode() {
        guard validateCode() else { return }
        switch activeCodeData?.currentType {
        case .activeAccount:
            activeCodeApi()
        case .forgetPassword:
            forgetPasswordCheckCodeApi()
        default:
            break
        }
    }
}


// MARK: - User active code

extension VerificationCodeViewModel {
    func resendActiveCodeApi() {
        Task {
            showIndicator()
            guard let countryCode = activeCodeData?.countryCode , let phoneNumber = activeCodeData?.phoneNumber else {
                return
            }
            let endPoint = AuthEndpoint.resendCode(countryCode: countryCode, phone: phoneNumber)
            
            do {
                let response = try await requestFullResponse(endPoint)
              
                await MainActor.run {
                    message = nil
                    startTimer()
                    showSuccess(response.message)
                                    }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }
    
    func activeCodeApi() {
        Task {
            showIndicator()
            guard let countryCode = activeCodeData?.countryCode , let phoneNumber = activeCodeData?.phoneNumber  else {
                return
            }
            let endPoint = AuthEndpoint.activeCode(countryCode: countryCode, phone: phoneNumber, code: code)
            
            do {
                let response = try await requestFullResponse(endPoint)
                guard response.data != nil else { return }

                await MainActor.run {
                    UserDefaults.user = response.data
                    UserDefaults.accessToken = response.data?.token
                    UserDefaults.isFirstTime = false
                    UserDefaults.isLogin = true
                    UserDefaults.isVisitor = false
                    successMessage = response.message
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }

}

// MARK: - Forget password code

extension VerificationCodeViewModel {
    func resendPasswordCodeApi() {
        Task {
            showIndicator()
            guard let countryCode = activeCodeData?.countryCode , let phoneNumber = activeCodeData?.phoneNumber else {
                return
            }
            let endPoint = AuthEndpoint.resendForgotPasswordCode(countryCode: countryCode, phone: phoneNumber)

            do {
                let response = try await requestFullResponse(endPoint)

                await MainActor.run {
                    message = nil
                    startTimer()
                    showSuccess(response.message)
                                    }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }
    
    func forgetPasswordCheckCodeApi() {
        Task {
            showIndicator()
            guard let countryCode = activeCodeData?.countryCode , let phoneNumber = activeCodeData?.phoneNumber  else {
                return
            }
            let endPoint = AuthEndpoint.forgetPasswordCheckCode(countryCode: countryCode, phone: phoneNumber, code: code)
            
            do {
                let response = try await requestFullResponse(endPoint)

                await MainActor.run {
                    showSuccess(response.message)
                    self.successMessage = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.successMessage = response.message
                    }
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }

}
