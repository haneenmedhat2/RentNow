import SwiftUI
import TamaraSDK

/// Embeds Tamara's official checkout controller using the backend's URLs unchanged.
struct TamaraSDKCheckoutView: UIViewControllerRepresentable {
    let payment: TamaraPaymentData
    let onSuccess: () -> Void
    let onFailureOrCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onSuccess: onSuccess, onFailureOrCancel: onFailureOrCancel)
    }

    func makeUIViewController(context: Context) -> TamaraSDKCheckout {
        // PaymentSession validates these URLs before checkout is presented.
        let merchantURL = TamaraMerchantURL(
            success: payment.successUrl ?? "",
            failure: payment.failureUrl ?? "",
            cancel: payment.cancelUrl ?? "",
            // SDK 1.0.19 requires this argument but its checkout controller does not use it.
            // Webhooks stay server-side; no notification endpoint is called by the app.
            notification: ""
        )
        let checkout = TamaraSDKCheckout(url: payment.checkoutUrl ?? "", merchantURL: merchantURL)
        checkout.delegate = context.coordinator
        return checkout
    }

    func updateUIViewController(_ controller: TamaraSDKCheckout, context: Context) {}

    static func dismantleUIViewController(_ controller: TamaraSDKCheckout, coordinator: Coordinator) {
        controller.delegate = nil
    }

    final class Coordinator: NSObject, TamaraCheckoutDelegate {
        private let onSuccess: () -> Void
        private let onFailureOrCancel: () -> Void
        private var hasFinished = false

        init(onSuccess: @escaping () -> Void, onFailureOrCancel: @escaping () -> Void) {
            self.onSuccess = onSuccess
            self.onFailureOrCancel = onFailureOrCancel
        }

        func onSuccessfull() { finish(success: true) }
        func onFailured() { finish(success: false) }
        func onCancel() { finish(success: false) }

        private func finish(success: Bool) {
            // The SDK may report failure and cancel for overlapping redirect URLs.
            guard !hasFinished else { return }
            hasFinished = true
            if success { onSuccess() } else { onFailureOrCancel() }
        }
    }
}
