//
//  ComplaintDetailViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
final class ComplaintDetailViewModel: BaseViewModel {

    let complaintId: Int
    @Published var detail: ComplaintDetailData?
    @Published var mediaViewerManager = MediaViewerManager()

    init(complaintId: Int) {
        self.complaintId = complaintId
        super.init()
        mediaViewerManager.viewModel = self
    }

    func fetchComplaintDetail() async {
        showIndicator()
        let endpoint = MoreEndpoint.getComplaintById(id: complaintId)
        do {
            let data = try await request(endpoint)
            self.detail = data
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
