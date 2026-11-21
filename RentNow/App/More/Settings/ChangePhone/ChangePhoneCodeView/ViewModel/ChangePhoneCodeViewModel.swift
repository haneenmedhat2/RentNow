//
//  ChangePhoneCodeViewModel.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI
import Combine

final class ChangePhoneCodeViewModel: BaseViewModel {

    let phoneCode: String
    let newPhoneNumber: String

    @Published var code: String = ""
    @Published var showValidationError: Bool = false
    @Published var timeRemaining: Int = 59
    @Published var canResend: Bool = false
    @Published var showSuccess: Bool = false

    private var timer: Timer?

    var formattedTimeRemaining: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init(phoneCode: String, newPhoneNumber: String) {
        self.phoneCode = phoneCode
        self.newPhoneNumber = newPhoneNumber
        super.init()
        startTimer()
    }

    // MARK: - Validation

    private func validateCode() -> Bool {
        if code.count < 4 {
            showValidationError = true
            return false
        }
        showValidationError = false
        return true
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

    // MARK: - API: Confirm Change Phone

    func confirmChangePhoneApi() {
        guard validateCode() else { return }
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.confirmChangePhone(phoneCode: phoneCode, newPhoneNumber: newPhoneNumber, code: code)
            do {
                _ = try await requestFullResponse(endpoint)
                await MainActor.run {
                    self.showSuccess = true
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }

    // MARK: - API: Resend Code

    func resendCode() {
        guard canResend else {
            ToastManager.shared.show(
                message: ("you can't resend code before".localized + " " + formattedTimeRemaining + " " + "verification_timer_seconds".localized),
                type: .error
            )
            return
        }
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.resendChangePhoneCode(phoneCode: phoneCode, newPhoneNumber: newPhoneNumber)
            do {
                let response = try await requestFullResponse(endpoint)
                await MainActor.run {
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

    @MainActor deinit {
        timer?.invalidate()
    }
}
