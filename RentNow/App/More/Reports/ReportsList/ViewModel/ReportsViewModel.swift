//
//  ReportsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class ReportsViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var reports: [ReportItem] = []

    // MARK: - Computed Properties
    var isEmpty: Bool {
        reports.isEmpty && !isLoading
    }

    // MARK: - API Calls
    func fetchReports() async {
        showIndicator()
        do {
            let data = try await request(MoreEndpoint.getAllReportIncidents())
            self.reports = data ?? []
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    func refreshReports() async {
        do {
            let data = try await request(MoreEndpoint.getAllReportIncidents())
            self.reports = data ?? []
        } catch {
            showError(error.localizedDescription)
        }
    }
}
