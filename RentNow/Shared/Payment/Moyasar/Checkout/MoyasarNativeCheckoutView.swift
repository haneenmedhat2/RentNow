import SwiftUI
import MoyasarSdk
import PassKit

enum MoyasarConfiguration {
    static let publishableKey = "pk_test_AAzNXyM7oLqv48hLUHrUbWpcUG3QQLg7Jt3nz3wV"
    static let merchantID = "merchant.com.aait.rentnow"

    static var canUseApplePay: Bool {
        !merchantID.isEmpty && PKPaymentAuthorizationController.canMakePayments()
    }
}

struct MoyasarNativeCheckoutView: View {
    @StateObject private var viewModel: MoyasarNativeCheckoutViewModel
    private let onFinish: (PaymentResult) -> Void

    init(session: PaymentSession, onFinish: @escaping (PaymentResult) -> Void) {
        _viewModel = StateObject(wrappedValue: MoyasarNativeCheckoutViewModel(session: session))
        self.onFinish = onFinish
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isVerifying {
                    ProgressView()
                    Text("Confirming payment...".localized)
                } else if let request = viewModel.paymentRequest {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(spacing: 20) {
                                MoyasarCardContainer(request: request, onPaymentStarted: {
                                    viewModel.paymentWillStart()
                                }) { result in
                                    viewModel.handleSDKResult(result)
                                }
                                // WKWebView has no intrinsic height inside a ScrollView.
                                .frame(height: max(geometry.size.height - 40, 440))
                            }.padding()
                        }
                    }
                } else {
                    Text("Payment is unavailable. Please contact support.".localized)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea())
            .navigationTitle("Payment".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close".localized) { viewModel.close() }
                }
            }
        }
        .preferredColorScheme(.light)
        .interactiveDismissDisabled()
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
        .onChange(of: viewModel.result) { _, result in
            if let result { onFinish(result) }
        }
    }
}

private struct MoyasarCardContainer: View {
    @StateObject private var cardViewModel: CreditCardViewModel

    init(request: MoyasarSdk.PaymentRequest, onPaymentStarted: @escaping () -> Bool,
         onResult: @escaping (MoyasarSdk.PaymentResult) -> Void) {
        _cardViewModel = StateObject(wrappedValue: CreditCardViewModel(
            paymentRequest: request, resultCallback: onResult, onPaymentStarted: onPaymentStarted
        ))
    }

    var body: some View {
        CreditCardView(viewModel: cardViewModel)
    }
}

