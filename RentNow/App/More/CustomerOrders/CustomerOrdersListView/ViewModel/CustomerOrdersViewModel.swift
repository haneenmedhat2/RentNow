//
//  CustomerOrdersViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Combine

@MainActor
class CustomerOrdersViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var orders: [CustomerOrderItem] = []
    @Published var selectedFilter: CustomerOrderFilterType = .currently
    private var currentFetchTask: Task<Void, Never>?

    // MARK: - Computed Properties
    var isEmpty: Bool {
        orders.isEmpty && !isLoading
    }

    // MARK: - API Calls
    func fetchOrders(showLoading: Bool = true) async {
        if showLoading { showIndicator() }
        defer { if showLoading { hideIndicator() } }
        let endpoint = MoreEndpoint.getMyCarOrders(filter: selectedFilter.rawValue)
        do {
            let response = try await request(endpoint)
            orders = response ?? []
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }
    }

    // MARK: - Actions
    func selectFilter(_ filter: CustomerOrderFilterType) {
        guard filter != selectedFilter else { return }
        selectedFilter = filter
        orders = []
        currentFetchTask?.cancel()
        currentFetchTask = Task { await fetchOrders() }
    }
}
