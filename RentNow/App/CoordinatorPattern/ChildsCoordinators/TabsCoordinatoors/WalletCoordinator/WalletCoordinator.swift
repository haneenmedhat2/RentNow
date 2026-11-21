//
//  WalletCoordinator.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI

// MARK: - Wallet Routes
enum WalletRoute: Hashable {
    case wallet
    case packagesList
}

// MARK: - Wallet Coordinator Protocol
@MainActor
protocol WalletCoordinatorProtocol {
    func showPackagesList()
    func showPackagePaymentSheet(package: PackageItem, onConfirm: @escaping (Int, MoyasarPaymentMethod) -> Void)
    func showPayment(session: PaymentSession, onResult: @escaping (PaymentResult) -> Void)
    func showCancelConfirmation(onConfirm: @escaping () -> Void)
    func showSubscriptionSuccess()
    func showLogin()
    func closeView()
}

// MARK: - Wallet Coordinator
@MainActor
final class WalletCoordinator: BaseCoordinator<WalletRoute>, WalletCoordinatorProtocol {

    private var walletViewModel = WalletViewModel()
    private var packagesListViewModel = PackagesListViewModel()

    var onLogout: (() -> Void)?

    override init() {
        super.init()
    }

    // MARK: - View Builder
    @ViewBuilder
    func buildWalletFlow() -> some View {
        NavigationStack(path: bindingPath) {
            makeView(for: .wallet)
                .navigationDestination(for: WalletRoute.self) { route in
                    self.makeView(for: route)
                }
        }
        .withCoordinatorPresentation(self)
    }

    @ViewBuilder
    private func makeView(for route: WalletRoute) -> some View {
        switch route {
        case .wallet:
            WalletView(coordinator: self, viewModel: walletViewModel)

        case .packagesList:
            PackagesListView(coordinator: self, viewModel: packagesListViewModel)
                .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: - Navigation Methods
    func showPackagesList() {
        packagesListViewModel = PackagesListViewModel()
        push(.packagesList)
    }

    func showPackagePaymentSheet(package: PackageItem, onConfirm: @escaping (Int, MoyasarPaymentMethod) -> Void) {
        let sheet = PackagePaymentSheetView(
            package: package,
            onClose: { [weak self] in self?.dismiss() },
            onConfirm: { [weak self] method, moyasarMethod in
                self?.dismissSheet {
                    onConfirm(method, moyasarMethod)
                }
            }
        )
        presentAsSheet(sheet, detents: [.large], showsDragIndicator: false)
    }

    func showPayment(
        session: PaymentSession,
        onResult: @escaping (PaymentResult) -> Void
    ) {
        presentPayment(session: session) { [weak self] result in
            if result == .paid { self?.walletViewModel.fetchSubscription() }
            onResult(result)
        }
    }

    func showCancelConfirmation(onConfirm: @escaping () -> Void) {
        let confirmView = CancelSubscriptionConfirmationView(
            onConfirm: { [weak self] in
                self?.dismiss()
                onConfirm()
            },
            onCancel: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsSheet(confirmView, detentHeight: 380)
    }

    func showSubscriptionSuccess() {
        let successView = SuccessPopupView(
            message: "Subscription successful".localized,
            isPresented: Binding(
                get: { true },
                set: { [weak self] newValue in
                    if !newValue {
                        self?.dismiss()
                        self?.popToRoot()
                        self?.walletViewModel.fetchSubscription()
                    }
                }
            )
        )
        presentAsPopup(successView)
    }

    func showLogin() {
        onLogout?()
    }

    func closeView() {
        pop()
    }
}
