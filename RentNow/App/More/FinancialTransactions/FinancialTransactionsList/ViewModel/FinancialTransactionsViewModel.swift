//
//  FinancialTransactionsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class FinancialTransactionsViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var selectedTab: FinancialTabType = .outstanding
    @Published var waitingSettlements: [WaitingSettlementItem] = []
    @Published var waitingSummary: WaitingSettlementSummary?
    @Published var newSettlements: [SettlementListItem] = []
    @Published var endedSettlements: [SettlementListItem] = []
    private var currentFetchTask: Task<Void, Never>?

    // MARK: - Computed Properties
    var isEmpty: Bool {
        switch selectedTab {
        case .outstanding:      return waitingSettlements.isEmpty && !isLoading
        case .newSettlement:    return newSettlements.isEmpty && !isLoading
        case .endedSettlement:  return endedSettlements.isEmpty && !isLoading
        }
    }

    // MARK: - Actions
    func selectTab(_ tab: FinancialTabType) {
        guard tab != selectedTab else { return }
        selectedTab = tab
        currentFetchTask?.cancel()
        currentFetchTask = Task { await loadCurrentTabData() }
    }

    func switchToNewTab() {
        selectedTab = .newSettlement
        currentFetchTask?.cancel()
        currentFetchTask = Task { await loadCurrentTabData() }
    }

    func loadCurrentTabData() async {
        switch selectedTab {
        case .outstanding:
            await fetchWaitingSettlements()
        case .newSettlement:
            await fetchSettlements(status: "New")
        case .endedSettlement:
            await fetchSettlements(status: "Ended")
        }
    }

    // MARK: - API Calls
    private func fetchWaitingSettlements() async {
        showIndicator()
        do {
            let endpoint = FinancialEndpoint.getWaitingSettlements()
            let response = try await request(endpoint)
            waitingSettlements = response?.settlements ?? []
            waitingSummary = response?.summary
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    private func fetchSettlements(status: String) async {
        showIndicator()
        do {
            let endpoint = FinancialEndpoint.getAllSettlements(status: status)
            let response = try await request(endpoint)
            if status == "New" {
                newSettlements = response ?? []
            } else {
                endedSettlements = response ?? []
            }
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
