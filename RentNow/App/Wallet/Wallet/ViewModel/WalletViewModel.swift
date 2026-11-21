//
//  WalletViewModel.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import Foundation
import Combine

@MainActor
class WalletViewModel: BaseViewModel {

    @Published var subscription: ActiveSubscription?
    @Published var hasFetchedSubscription = false

    var hasActiveSubscription: Bool {
        subscription != nil
    }

    var durationText: String {
        guard let days = subscription?.durationInDays, days > 0 else { return "" }
        let months = days / 30
        if months > 0 {
            return "\(months) " + "months".localized
        }
        return "\(days) " + "days".localized
    }

    var descriptionText: String {
        let localized = Language.isRTL()
            ? (subscription?.descriptionAr ?? "")
            : (subscription?.descriptionEn ?? "")
        return localized.isEmpty ? (subscription?.description ?? "") : localized
    }

    func fetchSubscription() {
        Task {
            showIndicator()
            let endpoint = WalletEndpoint.getMyActiveSubscription()
            do {
                let response = try await requestFullResponse(endpoint)
                if response.key == .success {
                    self.subscription = response.data
                } else {
                    self.subscription = nil
                }
            } catch {
                self.subscription = nil
            
            }
            hideIndicator()
            hasFetchedSubscription = true
        }
    }

    func cancelSubscription() {
        guard let subscriptionId = subscription?.id else { return }
        Task {
            showIndicator()
            let endpoint = WalletEndpoint.cancelSubscription(subscriptionId: subscriptionId)
            do {
                let response = try await requestFullResponse(endpoint)
                if response.key == .success {
                    showSuccess("Subscription cancelled successfully".localized)
                    self.subscription = nil
                } else {
                    showError(response.message ?? "")
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
