//
//  ComplaintsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class ComplaintsViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var complaints: [ComplaintItem] = []

    // MARK: - Computed Properties
    var isEmpty: Bool {
        complaints.isEmpty && !isLoading
    }

    // MARK: - API Calls
    func fetchComplaints() async {
        showIndicator()
        let endpoint = MoreEndpoint.getAllComplaints()
        do {
            let response = try await request(endpoint)
            complaints = response ?? []
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
