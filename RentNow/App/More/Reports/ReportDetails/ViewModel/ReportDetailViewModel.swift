//
//  ReportDetailViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class ReportDetailViewModel: BaseViewModel {

    // MARK: - Properties
    let reportId: Int

    // MARK: - Published Properties
    @Published var detail: ReportDetailData?
    @Published var showPDFPreview: Bool = false

    // MARK: - Init
    init(reportId: Int) {
        self.reportId = reportId
    }

    // MARK: - API Calls
    func fetchReportDetail() async {
        showIndicator()
        do {
            let data = try await request(MoreEndpoint.getReportIncidentDetails(reportId: reportId))
            self.detail = data
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    // MARK: - Formatted Properties
    var formattedIncidentDate: String {
        detail?.incidentDateFormatted ?? ""
    }

    var formattedIncidentTime: String {
        guard let dateStr = detail?.incidentDate, !dateStr.isEmpty else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = formatter.date(from: dateStr) else { return "" }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "hh:mm a"
        outputFormatter.locale = Locale(identifier: "ar")
        return outputFormatter.string(from: date)
    }

    // MARK: - PDF
    var pdfURL: URL? {
        guard let urls = detail?.incidentReportsUrls, let first = urls.first, !first.isEmpty else { return nil }
        let baseURL = "https://dashboard.rentnow-app.com/"
        return URL(string: baseURL + first)
    }

    var pdfFileName: String? {
        guard let urls = detail?.incidentReportsUrls, let first = urls.first, !first.isEmpty else { return nil }
        return (first as NSString).lastPathComponent
    }
}
