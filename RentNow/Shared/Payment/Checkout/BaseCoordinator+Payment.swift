import SwiftUI

extension BaseCoordinator {
    func presentPayment(
        session: PaymentSession,
        onResult: @escaping (PaymentResult) -> Void
    ) {
        if session.moyasar?.method == .applePay {
            presentOverlay(MoyasarApplePayCheckoutView(session: session) { [weak self] result in
                self?.overlayContent = nil
                onResult(result)
            })
            return
        }

        let onFinish: (PaymentResult) -> Void = { [weak self] result in
            self?.dismiss()
            onResult(result)
        }
        if session.isTabby {
            presentFullScreen(TabbyCheckoutView(session: session, onFinish: onFinish))
        } else if session.provider == .tamara {
            presentFullScreen(TamaraCheckoutView(session: session, onFinish: onFinish))
        } else if session.moyasar != nil {
            presentFullScreen(MoyasarNativeCheckoutView(session: session, onFinish: onFinish))
        } else {
            onResult(.failed(message: "Invalid payment response".localized))
        }
    }
}
