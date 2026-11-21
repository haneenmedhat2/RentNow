//
//  CreateReportViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class CreateReportViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var incidentDate: String = ""
    @Published var incidentTime: String = ""
    @Published var location: String = ""
    @Published var locationLatitude: Double = 0.0
    @Published var locationLongitude: Double = 0.0
    @Published var issuingAuthority: String = ""
    @Published var documentURL: URL?
    @Published var documentName: String = ""

    // MARK: - Error Bindings
    @Published var incidentDateError: String?
    @Published var incidentTimeError: String?
    @Published var locationError: String?
    @Published var issuingAuthorityError: String?
    @Published var documentError: String?

    // MARK: - Callbacks
    var onSuccess: (() -> Void)?

    let orderId: Int

    init(orderId: Int) {
        self.orderId = orderId
        super.init()
    }

    // MARK: - Location
    func setLocation(address: String, latitude: Double, longitude: Double) {
        self.location = address
        self.locationLatitude = latitude
        self.locationLongitude = longitude
        self.locationError = nil
    }

    // MARK: - Submit
    func submitReport() {
        guard validate() else { return }

        Task {
            showIndicator()
            do {
                let combinedDateTime = "\(incidentDate) \(incidentTime)"

                var fileUploads: [UploadData] = []
                if let url = documentURL, let fileData = try? Data(contentsOf: url) {
                    fileUploads.append(
                        UploadData(key: "IncidentReportFiles", data: fileData, mimeType: .pdf)
                    )
                }

                let _ = try await request(
                    OrdersEndpoint.reportIncident(
                        orderId: orderId,
                        incidentDate: combinedDateTime,
                        latitude: locationLatitude,
                        longitude: locationLongitude,
                        incidentReportIssuer: issuingAuthority,
                        files: fileUploads
                    )
                )
                onSuccess?()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    // MARK: - Validation
    private func validate() -> Bool {
        var isValid = true

        if incidentDate.isEmpty {
            incidentDateError = "Select Incident Date".localized
            isValid = false
        } else {
            incidentDateError = nil
        }

        if incidentTime.isEmpty {
            incidentTimeError = "Select Incident Time".localized
            isValid = false
        } else {
            incidentTimeError = nil
        }

        if location.isEmpty {
            locationError = "Select Incident Location".localized
            isValid = false
        } else {
            locationError = nil
        }

        if issuingAuthority.isEmpty {
            issuingAuthorityError = "Enter Issuing Authority".localized
            isValid = false
        } else {
            issuingAuthorityError = nil
        }

        if documentURL == nil {
            documentError = "Attach Report".localized
            isValid = false
        } else {
            documentError = nil
        }

        return isValid
    }
}
