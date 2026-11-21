//
//  BaseViewModel.swift
//  App
//
//  Created by elshamy on 04/01/2024.
//



import Foundation
import Combine
import SwiftUI

/// Struct to represent a Toast notification
struct ToastData:Equatable {
    let message: String
    let type: ToastType
    let duration: TimeInterval
}

class BaseViewModel: ObservableObject {
    
    // MARK: - Published properties for SwiftUI
    @Published var isLoading: Bool = false
    @Published var toast: ToastData? = nil
    private var toastWorkItem: DispatchWorkItem?
    @Published var successMessage: String? = nil
    @Published var responseKey: ServerResponseKey? = .success

    // MARK: - Combine cancellables
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Response handler
    let responseHandler: ResponseHandler
    
    init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        self.responseHandler = responseHandler
    }
    
    // MARK: - Network requests
    func request<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int) -> Void)? = nil) async throws -> ResponseData? {
        let response = try await self.responseHandler.get(endPoint, progress: progress)
        switch response.key {
        case .success:
            return response.data
        case .fail, .error, .notVerifiedFromNafaz:
            throw ResponseError.server(message: response.message)
        case .unauthenticated , .unauthorized , .blocked:
            handleSessionExpired(message: response.message)
            throw ResponseError.server(message: response.message)
        case .needActive:
            return response.data
        case .exception:
            throw ResponseError.serverError
        }
    }
    
    func requestFullResponse<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int) -> Void)? = nil) async throws -> BaseResponse<ResponseData> {
        let response = try await self.responseHandler.get(endPoint, progress: progress)
        switch response.key {
        case .success:
            return response
        case .fail, .error, .notVerifiedFromNafaz:
            throw ResponseError.server(message: response.message)
        case .unauthenticated, .unauthorized , .blocked:
            handleSessionExpired(message: response.message)
            throw ResponseError.server(message: response.message)
        case .needActive:
            return response
        case .exception:
            throw ResponseError.serverError
        }
    }
    
    // MARK: - Loader helpers
    func showIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
        }
    }
    
    // MARK: - Toast helpers
    func showToast(message: String, type: ToastType = .success, duration: TimeInterval = 2.5) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // إلغاء أي Toast قائم
            self.toastWorkItem?.cancel()
            
            let workItem = DispatchWorkItem { [weak self] in
                withAnimation(.easeInOut) {
                    self?.toast = nil
                }
            }
            
            self.toastWorkItem = workItem
            
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                self.toast = ToastData(message: message, type: type, duration: duration)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
        }
    }

    
    func showSuccess(_ message: String) {
        showToast(message: message, type: .success)
    }
    
    func showError(_ message: String) {
        if isCancellationError(message) { return }
        // Skip showing toast for no internet connection errors (popup is shown instead)
        if isNoInternetError(message) {
            return
        }
        showToast(message: message, type: .error)
    }

    /// Check if the error message indicates a cancelled request
    private func isCancellationError(_ message: String) -> Bool {
        let keywords = ["explicitly cancelled", "NSURLErrorCancelled", "-999"]
        let lower = message.lowercased()
        return keywords.contains { lower.contains($0.lowercased()) }
    }

    /// Check if the error message indicates no internet connection
    private func isNoInternetError(_ message: String) -> Bool {
        let noInternetKeywords = [
            "NSURLErrorDomain",
            "-1009",
            "-1005",
            "not connected to the internet",
            "no internet",
            "network connection",
            "لا يوجد اتصال",
            "الإنترنت",
            "offline"
        ]
        let lowercasedMessage = message.lowercased()
        return noInternetKeywords.contains { lowercasedMessage.contains($0.lowercased()) }
    }
    
    func showWarning(_ message: String) {
        showToast(message: message, type: .warning)
    }
    
    func showInfo(_ message: String) {
        showToast(message: message, type: .info)
    }
    
    // MARK: - Session Management
    private func handleSessionExpired(message: String) {
        showError(message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SessionManager.shared.handleSessionExpired()

        }
    }
}
