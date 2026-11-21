import Foundation
import Combine

@MainActor
final class ChangeOrderPaymentMethodViewModel: BaseViewModel {
    @Published private(set) var options: [OrderPaymentOption] = []
    @Published private(set) var isFetching = false
    @Published private(set) var isSaving = false
    @Published private(set) var loadError: String?
    @Published private(set) var saveError: String?
    @Published private(set) var selectedMethodId: Int?
    @Published var moyasarMethod: MoyasarPaymentMethod

    private let orderId: Int
    private let currentMethodId: Int?
    private let totalPrice: Double?
    private let currentMoyasarMethod: MoyasarPaymentMethod

    init(orderId: Int, currentMethodId: Int?, totalPrice: Double?, responseHandler: ResponseHandler = DefaultResponseHandler()) {
        self.orderId = orderId
        self.currentMethodId = currentMethodId
        self.totalPrice = totalPrice
        let initialMoyasarMethod = MoyasarPaymentPreference.get(orderId: orderId, userId: UserDefaults.user?.id)
        self.currentMoyasarMethod = initialMoyasarMethod
        self.moyasarMethod = initialMoyasarMethod
        selectedMethodId = currentMethodId
        super.init(responseHandler: responseHandler)
    }

    private var isBusy: Bool { isFetching || isSaving }

    var canSave: Bool {
        !isBusy && loadError == nil &&
        (selectedMethodId != currentMethodId || (selectedMethodId == 1 && moyasarMethod != currentMoyasarMethod)) &&
        (selectedMethodId != 1 || moyasarMethod != .applePay || MoyasarConfiguration.canUseApplePay) &&
        OrderPaymentOption.validSelection(selectedMethodId, in: options) != nil
    }

    func loadMethods() async {
        guard !isBusy else { return }
        isFetching = true
        loadError = nil
        defer { isFetching = false }
        do {
            guard let methods = try await request(OrdersEndpoint.getPaymentMethods()) else {
                loadError = "Unable to load payment methods. Please try again.".localized
                return
            }
            var selectableOptions = OrderPaymentOption.selectableOptions(methods.compactMap(\.paymentOption))
            if let totalPrice, totalPrice < 1_000 {
                selectableOptions.removeAll { $0.id == 2 || $0.id == 4 }
            }
            options = selectableOptions
            selectedMethodId = OrderPaymentOption.validSelection(selectedMethodId, in: options)
        } catch {
            guard !Task.isCancelled else { return }
            loadError = error.localizedDescription
        }
    }

    func select(_ methodId: Int) {
        guard !isBusy,
              OrderPaymentOption.validSelection(methodId, in: options) != nil else { return }
        selectedMethodId = methodId
        saveError = nil
    }

    func save() async -> OrderDetailsData? {
        guard canSave, let methodId = selectedMethodId else { return nil }
        isSaving = true
        saveError = nil
        defer { isSaving = false }
        do {
            let updated: OrderDetailsData?
            if methodId == currentMethodId {
                updated = try await request(OrdersEndpoint.getOrderDetails(orderId: orderId))
            } else {
                updated = try await request(OrdersEndpoint.changePaymentMethod(orderId: orderId, paymentMethod: methodId))
            }
            guard let updated, updated.paymentInfo != nil else {
                saveError = "Unable to update payment method. Please refresh the order and try again.".localized
                return nil
            }
            if methodId == 1 { MoyasarPaymentPreference.set(moyasarMethod, orderId: orderId, userId: UserDefaults.user?.id) }
            return updated
        } catch {
            saveError = error.localizedDescription
            return nil
        }
    }
}
