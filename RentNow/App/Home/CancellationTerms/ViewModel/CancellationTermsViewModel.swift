//
//  CancellationTermsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
final class CancellationTermsViewModel: BaseViewModel {

    @Published var conditions: String = ""

    func fetchConditions() async {
        showIndicator()
        let endpoint = HomeEndpoint.getCancellationTerms()
        do {
            let data = try await request(endpoint)
            self.conditions = data?.conditions ?? ""
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
