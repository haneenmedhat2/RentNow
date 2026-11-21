//
//  OrdersCoordinator.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI
import CoreLocation

// MARK: - Orders Routes
enum OrdersRoute: Hashable {
    case orders
    case orderDetails(orderId: Int)
    case createReport(orderId: Int)
    case reportLocationPicker
}

// MARK: - Orders Coordinator Protocol
@MainActor
protocol OrdersCoordinatorProtocol {
    func showOrderDetails(orderId: Int)
    func showPayment(session: PaymentSession, onResult: @escaping (PaymentResult) -> Void)
    func captureOdometer(orderId: Int, onResult: @escaping (Data, Double) -> Void)
    func showRatingSheet(onSubmit: @escaping (Int) -> Void)
    func showExtraKMPaymentSheet(paymentMethods: [OrderPaymentMethod], selectedValue: String?, onConfirm: @escaping (String?, MoyasarPaymentMethod) -> Void)
    func showChangePaymentMethod(orderId: Int, currentMethodId: Int?, totalPrice: Double?, onSaved: @escaping (OrderDetailsData) -> Void)
    func showLogin()
    func showCreateReport(orderId: Int)
    func showReportLocationPicker(onSelect: @escaping (CLLocationCoordinate2D?, String) -> Void)
}

// MARK: - Orders Coordinator
@MainActor
final class OrdersCoordinator: BaseCoordinator<OrdersRoute>, OrdersCoordinatorProtocol {

    private var ordersViewModel = OrdersViewModel()
    private var reportLocationCallback: ((CLLocationCoordinate2D?, String) -> Void)?

    var onLogout: (() -> Void)?

    override init() {
        super.init()
    }

    // MARK: - View Builder
    @ViewBuilder
    func buildOrdersFlow() -> some View {
        NavigationStack(path: bindingPath) {
            makeView(for: .orders)
                .navigationDestination(for: OrdersRoute.self) { route in
                    self.makeView(for: route)
                }
        }
        .withCoordinatorPresentation(self)
    }

    @ViewBuilder
    private func makeView(for route: OrdersRoute) -> some View {
        switch route {
        case .orders:
            OrdersView(coordinator: self, viewModel: self.ordersViewModel)

        case .orderDetails(let orderId):
            OrderDetailsView(
                coordinator: self,
                viewModel: makeOrderDetailsViewModel(orderId: orderId)
            )
            .toolbar(.hidden, for: .tabBar)

        case .createReport(let orderId):
            CreateReportView(coordinator: self, viewModel: makeCreateReportViewModel(orderId: orderId))
                .toolbar(.hidden, for: .tabBar)

        case .reportLocationPicker:
            LocationPickerView(viewModel: LocationPickerViewModel(), onSelect: { [weak self] coordinate, address in
                self?.reportLocationCallback?(coordinate, address)
                self?.pop()
            })
            .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: - Helper
    private func makeOrderDetailsViewModel(orderId: Int) -> OrderDetailsViewModel {
        let viewModel = OrderDetailsViewModel(orderId: orderId)
        viewModel.onPaymentRequested = { [weak self, weak viewModel] session in
            self?.showPayment(session: session) { result in
                viewModel?.handlePaymentResult(result, kind: session.kind)
            }
        }
        return viewModel
    }

    // MARK: - Navigation Methods
    func showOrderDetails(orderId: Int) {
        push(.orderDetails(orderId: orderId))
    }

    func showPayment(
        session: PaymentSession,
        onResult: @escaping (PaymentResult) -> Void
    ) {
        presentPayment(session: session, onResult: onResult)
    }

    func showRatingSheet(onSubmit: @escaping (Int) -> Void) {
        let ratingView = OrderDetailsRatingSheetView(
            onSubmit: { [weak self] rating in
                self?.dismiss()
                onSubmit(rating)
            },
            onClose: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsSheet(ratingView, detentHeight: 400)
    }

    func showExtraKMPaymentSheet(paymentMethods: [OrderPaymentMethod], selectedValue: String?, onConfirm: @escaping (String?, MoyasarPaymentMethod) -> Void) {
        let sheetView = OrderDetailsExtraKMPaymentSheetView(
            paymentMethods: paymentMethods,
            selectedValue: selectedValue,
            onConfirm: { [weak self] selected, moyasarMethod in
                self?.dismiss()
                onConfirm(selected, moyasarMethod)
            },
            onClose: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsSheet(sheetView, detentHeight: 500)
    }

    func showLogin() {
        onLogout?()
    }


    func captureOdometer(orderId: Int, onResult: @escaping (Data, Double) -> Void) {
        let cameraView = CameraHostView(
            onResult: { [weak self] photoData, reading in
                self?.dismiss()
                onResult(photoData, reading)
            },
            onCancel: { [weak self] in
                self?.dismiss()
            }
        )
        presentFullScreen(cameraView)
    }

    func showCreateReport(orderId: Int) {
        push(.createReport(orderId: orderId))
    }

    func showReportLocationPicker(onSelect: @escaping (CLLocationCoordinate2D?, String) -> Void) {
        reportLocationCallback = onSelect
        push(.reportLocationPicker)
    }

    // MARK: - Create Report
    private func makeCreateReportViewModel(orderId: Int) -> CreateReportViewModel {
        let viewModel = CreateReportViewModel(orderId: orderId)
        viewModel.onSuccess = { [weak self] in
            let successView = SuccessView(
                title: "Report sent successfully".localized,
                subtitle: "Your report has been sent successfully".localized,
                onDismiss: { [weak self] in
                    self?.dismiss()
                    self?.pop()
                }
            )
            self?.presentAsPopup(successView)
        }
        return viewModel
    }
}

// Both Home and Orders can present order details.
extension BaseCoordinator {
    func showChangePaymentMethod(orderId: Int, currentMethodId: Int?, totalPrice: Double?, onSaved: @escaping (OrderDetailsData) -> Void) {
        let view = ChangeOrderPaymentMethodView(
            viewModel: ChangeOrderPaymentMethodViewModel(orderId: orderId, currentMethodId: currentMethodId, totalPrice: totalPrice),
            onSaved: { [weak self] updated in
                self?.dismiss()
                onSaved(updated)
            },
            onClose: { [weak self] in self?.dismiss() }
        )
        presentAsSheet(view, detentHeight: 550)
    }
}
