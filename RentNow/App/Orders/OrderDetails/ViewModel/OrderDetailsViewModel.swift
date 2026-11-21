//
//  OrderDetailsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class OrderDetailsViewModel: BaseViewModel {
    @Published var details: OrderDetailsData?
    @Published var paymentMethods: [OrderPaymentMethod] = []
    @Published var selectedPaymentMethod: String?
    @Published var extraKilometersMoyasarMethod: MoyasarPaymentMethod = .card
    @Published var showExtraKMSuccess: Bool = false
    @Published var showMapPickerDialog: Bool = false
    @Published private(set) var isStartingPayment = false
    @Published var mediaViewerManager = MediaViewerManager()

    private var pendingMapLatitude: Double?
    private var pendingMapLongitude: Double?
    private var pendingMapLabel: String = ""
    private var paymentDetailsRevision = UUID()

    let orderId: Int
    var onPaymentRequested: ((PaymentSession) -> Void)?
    var paymentConfirmAction: (() -> Void)?

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
        let revision = paymentDetailsRevision
        showIndicator()
        do {
            let data = try await request(OrdersEndpoint.getOrderDetails(orderId: orderId))
            if revision == paymentDetailsRevision { self.details = data }
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    func refreshOrderDetails() async {
        let revision = paymentDetailsRevision
        do {
            let data = try await request(OrdersEndpoint.getOrderDetails(orderId: orderId))
            if revision == paymentDetailsRevision { self.details = data }
        } catch {
            showError(error.localizedDescription)
        }
    }

    // MARK: - Formatted Properties

    func applyPaymentMethodChange(_ updated: OrderDetailsData) {
        paymentDetailsRevision = UUID()
        details = updated
        showSuccess("Payment method updated".localized)
    }

    var formattedDate: String {
        details?.order?.creationDateFormatted ?? ""
    }

    var bottomButtonTitle: String {
        guard let actions = details?.buttonActions else { return "" }
        if actions.isNew == true { return "Cancel Order".localized }
        if actions.isPayment == true { return "Pay".localized }
        if actions.isDelivered  == true  && details?.handoverData == nil { return "Delivered".localized }
        if actions.isReceived  == true && details?.returnData == nil { return "Received".localized }
        if actions.isRate == true { return "Rate Car".localized }
        return ""
    }

    var isCancelAction: Bool {
        details?.buttonActions?.isNew == true
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

    func cancelOrder() {
        Task {
            showIndicator()
            do {
                let _ = try await request(OrdersEndpoint.cancelOrder(orderId: orderId))
                await fetchOrderDetails()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    // MARK: - Payment

    func payOrder() {
        guard !isStartingPayment else { return }
        isStartingPayment = true

        Task {
            showIndicator()
            var openedCheckout = false
            defer {
                hideIndicator()
                if !openedCheckout { isStartingPayment = false }
            }

            do {
                guard let payment = try await request(OrdersEndpoint.payOrder(orderId: orderId)) else {
                    showError("Invalid payment response".localized)
                    return
                }

                let session: PaymentSession?
                if payment.provider == .tabby {
                    session = await prepareTabbyCheckout(payment)
                } else if payment.provider == .tamara {
                    session = await prepareTamaraCheckout(payment)
                } else {
                    session = await prepareStandardCheckout(payment)
                }

                guard let session else { return }
                guard let onPaymentRequested else {
                    showError("Invalid payment response".localized)
                    return
                }
                openedCheckout = true
                onPaymentRequested(session)
            } catch {
                showError(error.localizedDescription)
            }
        }
    }

    private func prepareTabbyCheckout(_ payment: PayOrderData) async -> PaymentSession? {
        if payment.paymentStatus == .paid {
            showSuccess("Payment Successful".localized)
            await fetchOrderDetails()
            return nil
        }

        if payment.paymentStatus == .rejected || payment.tabby?.status?.lowercased() == "rejected" {
            let messages = [payment.tabby?.rejectionMessage, payment.message, payment.paymentStatusText]
            let rejectionMessage = messages.compactMap { $0 }.first {
                !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            showError(rejectionMessage ?? "Tabby could not approve this payment. Please choose another payment method.".localized)
            return nil
        }

        guard let session = PaymentSession(tabbyPayment: payment, orderId: orderId) else {
            showError("Unable to start Tabby checkout. Please refresh the order and try again.".localized)
            return nil
        }
        return session
    }

    private func prepareTamaraCheckout(_ payment: PayOrderData) async -> PaymentSession? {
        if payment.paymentStatus == .paid {
            showSuccess("Payment Successful".localized)
            await fetchOrderDetails()
            return nil
        }

        if payment.paymentStatus == .needsReview {
            showInfo(payment.paymentStatusText ?? "Your payment is under review.".localized)
            await fetchOrderDetails()
            return nil
        }

        if payment.paymentStatus == .rejected || payment.tamara?.isEligible == false {
            let messages = [payment.message, payment.tamara?.rejectionMessage, payment.paymentStatusText]
            let message = messages.compactMap { $0 }.first {
                !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            showError(message ?? "Tamara could not approve this payment. Please choose another payment method.".localized)
            return nil
        }

        guard let session = PaymentSession(tamaraPayment: payment, orderId: orderId) else {
            showError("Unable to start Tamara checkout. Please refresh the order and try again.".localized)
            return nil
        }
        return session
    }

    private func prepareStandardCheckout(_ payment: PayOrderData) async -> PaymentSession? {
        if let session = PaymentSession(moyasarPayment: payment, kind: .order, orderId: orderId, method: MoyasarPaymentPreference.get(orderId: orderId, userId: UserDefaults.user?.id)) {
            return session
        }

        if payment.isPackagePayment == true && payment.paymentStatus != .pending && payment.paymentStatus != .unpaid {
            showSuccess("Payment Successful".localized)
            await fetchOrderDetails()
            return nil
        }

        let message = payment.message ?? ""
        showError(message.isEmpty ? "Invalid payment response".localized : message)
        return nil
    }

    func confirmHandover(photoData: Data, reading: Double) {
        Task {
            showIndicator()
            do {
                let _ = try await request(OrdersEndpoint.confirmHandover(
                    orderId: orderId,
                    odometerPhoto: photoData,
                    odometerReading: reading
                ))
                await fetchOrderDetails()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func confirmReturn(photoData: Data, reading: Double) {
        Task {
            showIndicator()
            do {
                let _ = try await request(OrdersEndpoint.confirmReturn(
                    orderId: orderId,
                    odometerPhoto: photoData,
                    odometerReading: reading
                ))
                await fetchOrderDetails()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func rateOrder(rating: Int) {
        Task {
            showIndicator()
            do {
                let _ = try await request(OrdersEndpoint.rateOrder(orderId: orderId, rating: rating))
                await fetchOrderDetails()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func fetchExtraKMPaymentMethods() {
        Task {
            showIndicator()
            do {
                let data = try await request(OrdersEndpoint.getPaymentMethods())
                paymentMethods = data ?? []
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func payExceededKilometers() {
        guard !isStartingPayment else { return }
        isStartingPayment = true
        Task {
            showIndicator()
            var openedCheckout = false
            defer {
                hideIndicator()
                if !openedCheckout { isStartingPayment = false }
            }
            do {
                let data = try await request(OrdersEndpoint.payExceededKilometers(orderId: orderId))
                if let data, let session = PaymentSession(moyasarPayment: data, kind: .exceededKilometers, orderId: orderId, method: extraKilometersMoyasarMethod) {
                    guard let onPaymentRequested else {
                        showError("Invalid payment response".localized)
                        return
                    }
                    openedCheckout = true
                    onPaymentRequested(session)
                } else if data?.isPackagePayment == true && data?.paymentStatus != .pending && data?.paymentStatus != .unpaid {
                    showExtraKMSuccess = true
                    await fetchOrderDetails()
                } else {
                    showError(data?.message?.isEmpty == false ? data?.message ?? "" : "Invalid payment response".localized)
                }
            } catch {
                showError(error.localizedDescription)
            }
        }
    }

    func handlePaymentResult(_ result: PaymentResult, kind: PaymentKind) {
        isStartingPayment = false
        switch result {
        case .paid:
            Task {
                if kind == .exceededKilometers {
                    showExtraKMSuccess = true
                } else {
                    showSuccess("Payment Successful".localized)
                }
                await fetchOrderDetails()
            }
        case .failed(let message):
            showError(message ?? "Payment failed".localized)
            Task { await refreshOrderDetails() }
        case .canceled:
            Task { await refreshOrderDetails() }
        case .expired(let message):
            showError(message ?? "Payment expired".localized)
            Task { await refreshOrderDetails() }
        case .needsReview(let message):
            showInfo(message ?? "Your payment is under review.".localized)
            Task { await refreshOrderDetails() }
        case .pending:
            showInfo("Payment is still being verified. Check the order status before trying again.".localized)
            Task { await refreshOrderDetails() }
        }
    }

    func handleBottomAction(coordinator: OrdersCoordinatorProtocol) {
        guard let actions = details?.buttonActions else { return }
        if actions.isNew == true {
            cancelOrder()
            
            
        } else if actions.isPayment == true {
            payOrder()
            
            
        }else if actions.isDelivered == true  && details?.handoverData == nil {
            coordinator.captureOdometer(orderId: orderId) { [weak self] photoData, reading in
                self?.confirmHandover(photoData: photoData, reading: reading)
            }
            
            
        }else if actions.isReceived == true && details?.returnData == nil {
           
            
            coordinator.captureOdometer(orderId: orderId) { [weak self] photoData, reading in
                self?.confirmReturn(photoData: photoData, reading: reading)
            }
        }
        else if actions.isRate == true {
            coordinator.showRatingSheet { [weak self] rating in
                self?.rateOrder(rating: rating)
            }
        }
    }
}
