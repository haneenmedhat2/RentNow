//
//  CreateOrderViewModel.swift
//  RentNow
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class CreateOrderViewModel: BaseViewModel {

    let advertisementId: Int

    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Double?, Double?) -> Void)?

    @Published var pageData: OrderPageData?
    @Published var dateFrom: String = ""
    @Published var dateTo: String = ""
    @Published var startTime: String = ""
    @Published var numberOfDays: String = ""
    @Published var selectedPaymentMethodId: Int?
    @Published var selectedAdditionalFeatureIds: Set<Int> = []
    @Published var deliveryMethod: DeliveryMethod = .pickupFromLocation
    @Published var deliveryLatitude: Double?
    @Published var deliveryLongitude: Double?
    @Published var deliveryAirportId: Int?
    @Published var deliveryAddress: String?
    @Published var deliveryNotes: String = ""
    @Published var returnPickupMethod: DeliveryMethod = .pickupFromLocation
    @Published var returnPickupLatitude: Double?
    @Published var returnPickupLongitude: Double?
    @Published var returnPickupAirportId: Int?
    @Published var returnPickupAddress: String?
    @Published var returnPickupNotes: String = ""
    @Published var agreedToTerms: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var createdOrderId: Int?

    // Payment Summary
    @Published var paymentSummary: OrderPaymentSummary?
    @Published var showPriceSummary: Bool = false
    @Published var moyasarMethod: MoyasarPaymentMethod = MoyasarConfiguration.canUseApplePay ? .applePay : .card
    @Published private(set) var paymentOptions: [OrderPaymentOption] = []
    @Published private(set) var isCheckingPaymentOptions = false
    @Published private(set) var paymentOptionsError: String?
    @Published private(set) var isCreatingOrder = false

    private var summaryTask: Task<Void, Never>?
    private var summaryRequestID = UUID()
    private var confirmedSummaryInput: SummaryInput?

    private typealias SummaryInput = OrderBookingRequest

    private var pagePaymentOptions: [OrderPaymentOption] {
        return OrderPaymentOption.selectableOptions(pageData?.paymentOptions)
    }

    /// Keep installments hidden until the server has calculated the final payable total.
    var visiblePaymentOptions: [OrderPaymentOption] {
        let installmentsAreEligible = (paymentSummary?.total ?? 0) >= 1_000
        let displayOrder = [1: 0, 4: 1, 2: 2]
        return paymentOptions
            .filter { option in
                guard let id = option.id else { return false }
                return id == 1 || (installmentsAreEligible && (id == 4 || id == 2))
            }
            .sorted { lhs, rhs in
                displayOrder[lhs.id ?? -1, default: Int.max] < displayOrder[rhs.id ?? -1, default: Int.max]
            }
    }

    private func preferredPaymentMethodId(in options: [OrderPaymentOption]) -> Int? {
        [1, 4, 2].first { OrderPaymentOption.validSelection($0, in: options) != nil }
    }

    var hasRequiredBookingDetails: Bool {
        !dateFrom.isEmpty && !dateTo.isEmpty && daysCount > 0 && !startTime.isEmpty &&
        (deliveryMethod != .delivery || (deliveryLatitude != nil && deliveryLongitude != nil)) &&
        (returnPickupMethod != .delivery || (returnPickupLatitude != nil && returnPickupLongitude != nil))
    }

    var canSelectPaymentMethod: Bool {
        hasRequiredBookingDetails && !isCheckingPaymentOptions && !isCreatingOrder &&
        paymentSummary != nil && paymentOptionsError == nil
    }

    private var bookingDates: (from: String, to: String)? {
        BookingDateFormatter.dateTimes(from: dateFrom, to: dateTo, time: startTime)
    }

    private var summaryInput: SummaryInput? {
        let optionsForDefault = paymentOptions.isEmpty ? pagePaymentOptions : paymentOptions
        guard hasRequiredBookingDetails, advertisementId > 0, let dates = bookingDates,
              let method = selectedPaymentMethodId
                ?? preferredPaymentMethodId(in: optionsForDefault),
              [1, 2, 4].contains(method),
              let delivery = Int(deliveryMethod.rawValue),
              let pickup = Int(returnPickupMethod.rawValue)
        else { return nil }
        return SummaryInput(
            advertisementId: advertisementId, dateFrom: dates.from, dateTo: dates.to,
            additionalFeatureIds: selectedAdditionalFeatureIds.sorted(), paymentMethod: method,
            deliveryMethod: delivery,
            deliveryLatitude: deliveryMethod == .delivery ? deliveryLatitude : nil,
            deliveryLongitude: deliveryMethod == .delivery ? deliveryLongitude : nil,
            deliveryAirportId: deliveryMethod == .delivery ? deliveryAirportId : nil,
            deliveryNotes: deliveryMethod == .delivery && !deliveryNotes.isEmpty ? deliveryNotes : nil,
            returnPickupMethod: pickup,
            returnPickupLatitude: returnPickupMethod == .delivery ? returnPickupLatitude : nil,
            returnPickupLongitude: returnPickupMethod == .delivery ? returnPickupLongitude : nil,
            returnPickupAirportId: returnPickupMethod == .delivery ? returnPickupAirportId : nil,
            returnPickupNotes: returnPickupMethod == .delivery && !returnPickupNotes.isEmpty ? returnPickupNotes : nil
        )
    }

    var canConfirmOrder: Bool {
        !isCheckingPaymentOptions && !isCreatingOrder && paymentSummary != nil &&
        confirmedSummaryInput != nil && confirmedSummaryInput == summaryInput &&
        (selectedPaymentMethodId != 1 || moyasarMethod != .applePay || MoyasarConfiguration.canUseApplePay) &&
        OrderPaymentOption.validSelection(selectedPaymentMethodId, in: visiblePaymentOptions) != nil
    }

    // Error bindings
    @Published var dateFromError: String?
    @Published var dateToError: String?
    @Published var startTimeError: String?
    @Published var numberOfDaysError: String?
    @Published var paymentMethodError: String?
    @Published var deliveryLocationError: String?
    @Published var returnPickupLocationError: String?
    @Published var termsError: String?

    init(advertisementId: Int) {
        self.advertisementId = advertisementId
    }

    // MARK: - Computed Properties

    var pricePerDay: Double {
        pageData?.adDetails?.pricePerDay ?? 0
    }

    var daysCount: Int {
        Int(numberOfDays) ?? 0
    }

    var isDeliveryEnabled: Bool {
        pageData?.adDetails?.isDeliveryToRenterLocationEnabled ?? false
    }

    var isReturnPickupEnabled: Bool {
        pageData?.adDetails?.isReceivedFromRenterLocationEnabled ?? false
    }

    var allRequiredFieldsFilled: Bool {
        !dateFrom.isEmpty &&
        !dateTo.isEmpty &&
        (Int(numberOfDays) ?? 0) > 0 &&
        !startTime.isEmpty &&
        selectedPaymentMethodId != nil
    }

    /// Formatted date range for display (e.g. "28 يوليو - 31 يوليو")
    var formattedDateRange: String {
        guard !dateFrom.isEmpty, !dateTo.isEmpty else { return "" }

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "d MMMM"
        displayFormatter.locale = Locale(identifier: Language.currentLanguage())

        guard let fromDate = inputFormatter.date(from: dateFrom),
              let toDate = inputFormatter.date(from: dateTo) else { return "" }

        let fromStr = displayFormatter.string(from: fromDate)
        let toStr = displayFormatter.string(from: toDate)
        return "\(fromStr) - \(toStr)"
    }

    // MARK: - Methods

    func fetchPageData() async {
        showIndicator()
        do {
            let response = try await request(HomeEndpoint.getOrderPageData(advertisementId: advertisementId))
            self.pageData = response

            paymentOptions = pagePaymentOptions
            // Start with Moyasar (Apple Pay when configured, otherwise Mada/card).
            selectedPaymentMethodId = preferredPaymentMethodId(in: paymentOptions)
            checkAndFetchSummary()
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    func updateDateToFromDays() {
        guard !dateFrom.isEmpty, let days = Int(numberOfDays), days > 0 else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let fromDate = formatter.date(from: dateFrom) else { return }
        guard let toDate = Calendar.current.date(byAdding: .day, value: days, to: fromDate) else { return }

        dateTo = formatter.string(from: toDate)
    }

    func updateDaysFromDates() {
        guard !dateFrom.isEmpty, !dateTo.isEmpty else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let fromDate = formatter.date(from: dateFrom),
              let toDate = formatter.date(from: dateTo) else { return }

        let components = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        if let days = components.day, days >= 0 {
            numberOfDays = "\(days + 1)"
        }
    }

    func toggleAdditionalFeature(_ featureId: Int?) {
        guard let id = featureId else { return }
        if selectedAdditionalFeatureIds.contains(id) {
            selectedAdditionalFeatureIds.remove(id)
        } else {
            selectedAdditionalFeatureIds.insert(id)
        }
    }

    // MARK: - Payment Summary

    func checkAndFetchSummary() {
        summaryTask?.cancel()
        summaryRequestID = UUID()
        confirmedSummaryInput = nil
        paymentSummary = nil
        showPriceSummary = false
        paymentOptionsError = nil
        isCheckingPaymentOptions = false

        guard let input = summaryInput else {
            paymentOptions = pagePaymentOptions
            if hasRequiredBookingDetails {
                paymentOptionsError = "Please check the booking dates and payment method.".localized
            }
            reconcilePaymentSelection()
            return
        }

        let requestID = summaryRequestID
        isCheckingPaymentOptions = true
        summaryTask = Task { [weak self] in
            // Coalesce date/feature/location changes into one request.
            do { try await Task.sleep(nanoseconds: 300_000_000) }
            catch { return }
            guard let self else { return }
            do {
                let response = try await request(
                    HomeEndpoint.getOrderPaymentSummary(request: input)
                )
                guard !Task.isCancelled, summaryRequestID == requestID, summaryInput == input else { return }
                guard let response else {
                    paymentOptionsError = "Unable to update payment options. Please try again.".localized
                    isCheckingPaymentOptions = false
                    return
                }
                paymentSummary = response
                confirmedSummaryInput = input
                showPriceSummary = true
                // Availability must come from this quote, never a stale page/legacy list.
                paymentOptions = OrderPaymentOption.selectableOptions(response.paymentOptions)
                if response.paymentOptions == nil {
                    paymentOptionsError = "Unable to update payment options. Please try again.".localized
                    confirmedSummaryInput = nil
                }
                isCheckingPaymentOptions = false
                reconcilePaymentSelection()
                if !paymentOptions.isEmpty, confirmedSummaryInput != summaryInput {
                    checkAndFetchSummary()
                }
            } catch {
                guard !Task.isCancelled, summaryRequestID == requestID, summaryInput == input else { return }
                isCheckingPaymentOptions = false
                paymentOptionsError = error.localizedDescription
            }
        }
    }

    func selectPaymentMethod(_ value: Int) {
        guard canSelectPaymentMethod,
              OrderPaymentOption.validSelection(value, in: visiblePaymentOptions) != nil else { return }
        selectedPaymentMethodId = value
        paymentMethodError = nil
        checkAndFetchSummary()
    }

    private func reconcilePaymentSelection() {
        guard OrderPaymentOption.validSelection(selectedPaymentMethodId, in: visiblePaymentOptions) == nil else { return }
        selectedPaymentMethodId = preferredPaymentMethodId(in: visiblePaymentOptions)
        paymentMethodError = nil
    }

    func stopCheckingPaymentOptions() {
        summaryTask?.cancel()
        summaryRequestID = UUID()
        isCheckingPaymentOptions = false
        confirmedSummaryInput = nil
    }

    // MARK: - Create Order

    func createOrder() {
        clearErrors()

        guard validate() else { return }
        guard canConfirmOrder, let input = confirmedSummaryInput else {
            paymentMethodError = "Please wait for updated payment options before booking.".localized
            return
        }
        // Freeze the validated request before starting the async operation.
        isCreatingOrder = true
        Task {
            showIndicator()
            defer { isCreatingOrder = false; hideIndicator() }
            do {
                let endpoint = HomeEndpoint.createOrder(request: input)
                let response = try await request(endpoint)
                guard let orderId = response?.orderId else {
                    showError("Unable to create order. Please try again.".localized)
                    return
                }
                if input.paymentMethod == 1 {
                    MoyasarPaymentPreference.set(moyasarMethod, orderId: orderId, userId: UserDefaults.user?.id)
                }
                createdOrderId = orderId
                showSuccessPopup = true
            } catch {
                showError(error.localizedDescription)
            }
        }
    }

    // MARK: - Location

    func getCurrentLocation(completion: @escaping (Double?, Double?) -> Void) {
        self.locationCompletion = completion

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.attemptLocationFetch()
            }

        case .restricted, .denied:
            showError("location_permission_denied".localized)
            completion(nil, nil)

        case .authorizedAlways, .authorizedWhenInUse:
            attemptLocationFetch()

        @unknown default:
            completion(nil, nil)
        }
    }

    private func attemptLocationFetch() {
        if let location = locationManager.location {
            locationCompletion?(location.coordinate.latitude, location.coordinate.longitude)
        } else {
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else { return }
                if let location = self.locationManager.location {
                    self.locationCompletion?(location.coordinate.latitude, location.coordinate.longitude)
                } else {
                    self.locationCompletion?(nil, nil)
                }
                self.locationManager.stopUpdatingLocation()
            }
        }
    }

    // MARK: - Validation

    private func validate() -> Bool {
        var isValid = true

        if dateFrom.isEmpty {
            dateFromError = "Please select rental start date".localized
            isValid = false
        }

        if dateTo.isEmpty {
            dateToError = "Please select rental end date".localized
            isValid = false
        }

        if startTime.isEmpty {
            startTimeError = "Please select rental start time".localized
            isValid = false
        }

        if numberOfDays.isEmpty || (Int(numberOfDays) ?? 0) <= 0 {
            numberOfDaysError = "Please enter number of days".localized
            isValid = false
        }

        if OrderPaymentOption.validSelection(selectedPaymentMethodId, in: visiblePaymentOptions) == nil {
            paymentMethodError = "Please select payment method".localized
            isValid = false
        }

        if deliveryMethod == .delivery && deliveryLatitude == nil {
            deliveryLocationError = "Please select delivery location".localized
            isValid = false
        }

        if returnPickupMethod == .delivery && returnPickupLatitude == nil {
            returnPickupLocationError = "Please select return pickup location".localized
            isValid = false
        }

        if !agreedToTerms {
            termsError = "Please agree to cancellation and delay terms".localized
            isValid = false
        }

        return isValid
    }

    private func clearErrors() {
        dateFromError = nil
        dateToError = nil
        startTimeError = nil
        numberOfDaysError = nil
        paymentMethodError = nil
        deliveryLocationError = nil
        returnPickupLocationError = nil
        termsError = nil
    }
}
