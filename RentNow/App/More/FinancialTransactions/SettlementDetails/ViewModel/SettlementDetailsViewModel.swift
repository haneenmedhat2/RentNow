//
//  SettlementDetailsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class SettlementDetailsViewModel: BaseViewModel {

    // MARK: - Properties
    let settlementId: Int
    @Published var details: SettlementDetailsData?

    // MARK: - Init
    init(settlementId: Int) {
        self.settlementId = settlementId
        super.init()
    }

    // MARK: - Computed
    var statusColor: StatusColorType {
        switch details?.statusId {
        case 1: return .pending
        case 2: return .approved
        case 3: return .rejected
        default: return .pending
        }
    }

    var showTransferImage: Bool {
        details?.transferImage != nil && !(details?.transferImage?.isEmpty ?? true)
    }

    var showRejectionReason: Bool {
        details?.rejectionReason != nil && !(details?.rejectionReason?.isEmpty ?? true)
    }

    // MARK: - API
    func fetchDetails() async {
        showIndicator()
        do {
            let endpoint = FinancialEndpoint.getSettlementDetails(id: settlementId)
            let response = try await request(endpoint)
            details = response
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}

// MARK: - Status Color Type
enum StatusColorType {
    case pending, approved, rejected
}
