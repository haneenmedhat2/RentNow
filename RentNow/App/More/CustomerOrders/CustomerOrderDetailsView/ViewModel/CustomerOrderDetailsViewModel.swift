//
//  CustomerOrderDetailsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class CustomerOrderDetailsViewModel: BaseViewModel {
    @Published var details: OrderDetailsData?
    @Published var mediaViewerManager = MediaViewerManager()
    @Published var showMapPickerDialog: Bool = false

    private var pendingMapLatitude: Double?
    private var pendingMapLongitude: Double?
    private var pendingMapLabel: String = ""

    let orderId: Int

    init(orderId: Int) {
        self.orderId = orderId
        super.init()
        mediaViewerManager.viewModel = self
        observeOrderStatusChanges()
    }

    private func observeOrderStatusChanges() {
        NotificationCenter.default.addObserver(
            forName: .orderStatusChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            let changedOrderId = notification.userInfo?["order_id"] as? Int
            if changedOrderId == self.orderId {
                Task { @MainActor in
                    await self.refreshOrderDetails()
                }
            }
        }
    }

    func fetchOrderDetails() async {
        showIndicator()
        do {
            let data = try await request(MoreEndpoint.getOrderDetails(orderId: orderId))
            self.details = data
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    func refreshOrderDetails() async {
        do {
            let data = try await request(MoreEndpoint.getOrderDetails(orderId: orderId))
            self.details = data
        } catch {
            showError(error.localizedDescription)
        }
    }

    // MARK: - Formatted Properties

    var formattedDate: String {
        guard let dateStr = details?.order?.creationDateFormatted, !dateStr.isEmpty else { return "" }
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = isoFormatter.date(from: dateStr) ?? ISO8601DateFormatter().date(from: dateStr)
        guard let date else { return dateStr }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd - hh:mm a"
        formatter.locale = Locale(identifier: "en")
        return formatter.string(from: date)
    }

    var bottomButtonTitle: String {
        guard let actions = details?.buttonActions else { return "" }
        if actions.isPrepared == true { return "Prepared".localized }
        if actions.isDelivered == true { return "Confirm Delivery".localized }
        if actions.isReceived == true { return "Confirm Return".localized }
        return ""
    }

    var showBottomButton: Bool {
        return !bottomButtonTitle.isEmpty
    }

    // MARK: - Location / Maps

    func hasValidCoordinates(latitude: Double?, longitude: Double?) -> Bool {
        guard let latitude, let longitude else { return false }
        return latitude != 0 && longitude != 0
    }

    func openLocation(latitude: Double?, longitude: Double?, label: String) {
        guard hasValidCoordinates(latitude: latitude, longitude: longitude) else { return }
        pendingMapLatitude = latitude
        pendingMapLongitude = longitude
        pendingMapLabel = label
        showMapPickerDialog = true
    }

    func openInAppleMaps() {
        guard let latitude = pendingMapLatitude, let longitude = pendingMapLongitude else { return }
        MapHelper.openLocation(latitude: latitude, longitude: longitude, label: pendingMapLabel)
    }

    func openInGoogleMaps() {
        guard let latitude = pendingMapLatitude, let longitude = pendingMapLongitude else { return }
        MapHelper.openInGoogleMaps(latitude: latitude, longitude: longitude)
    }

    func handleBottomAction() {
        guard let actions = details?.buttonActions else { return }
        if actions.isPrepared == true {
            markPrepared()
        } else if actions.isDelivered == true {
            confirmHandover()
        } else if actions.isReceived == true  {
            confirmReturn()
        }
    }

    func markPrepared() {
        Task {
            showIndicator()
            do {
                let _ = try await request(MoreEndpoint.markPreparedByProvider(orderId: orderId))
                await fetchOrderDetails()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func confirmHandover() {
        Task {
            showIndicator()
            do {
                let _ = try await request(MoreEndpoint.confirmHandoverByProvider(orderId: orderId))
                await fetchOrderDetails()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func confirmReturn() {
        Task {
            showIndicator()
            do {
                let _ = try await request(MoreEndpoint.confirmReturnByProvider(orderId: orderId))
                await fetchOrderDetails()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
