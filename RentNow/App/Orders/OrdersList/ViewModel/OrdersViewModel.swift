//
//  OrdersViewModel.swift
//  RentNow
//
//  Created by Claude on 2026-02-09.
//

import Foundation
import Combine

@MainActor
class OrdersViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var orders: [OrderItem] = []
    @Published var selectedFilter: OrderFilterType = .new
    private var currentFetchTask: Task<Void, Never>?

    // MARK: - Computed Properties
    var isEmpty: Bool {
        orders.isEmpty && !isLoading
    }

    // MARK: - API Calls
    func fetchOrders(showLoading: Bool = true) async {
        if showLoading { showIndicator() }
        defer { if showLoading { hideIndicator() } }
        let endpoint = OrdersEndpoint.getMyOrders(filter: selectedFilter.rawValue)
        do {
            let response = try await request(endpoint)
            orders = response ?? []
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }
    }

    // MARK: - Actions
    func selectFilter(_ filter: OrderFilterType) {
        guard filter != selectedFilter else { return }
        selectedFilter = filter
        orders = []
        currentFetchTask?.cancel()
        currentFetchTask = Task { await fetchOrders() }
    }

    // MARK: - Date Formatting
    func formattedDate(_ isoString: String?) -> String {
        guard let isoString = isoString, !isoString.isEmpty else { return "" }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // Try with fractional seconds first, then without
        var date = isoFormatter.date(from: isoString)
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: isoString)
        }

        guard let parsedDate = date else { return isoString }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        displayFormatter.locale = Locale(identifier: Language.currentLanguage())
        return displayFormatter.string(from: parsedDate)
    }
}
