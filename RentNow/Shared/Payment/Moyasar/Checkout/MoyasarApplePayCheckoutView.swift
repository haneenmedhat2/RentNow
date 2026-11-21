import SwiftUI

/// Keeps the current screen visible while PassKit presents its payment sheet.
struct MoyasarApplePayCheckoutView: View {
    @StateObject private var viewModel: MoyasarNativeCheckoutViewModel
    private let onFinish: (PaymentResult) -> Void

    init(session: PaymentSession, onFinish: @escaping (PaymentResult) -> Void) {
        _viewModel = StateObject(wrappedValue: MoyasarNativeCheckoutViewModel(session: session))
        self.onFinish = onFinish
    }

    var body: some View {
        ZStack {
            Color.clear

            if viewModel.isVerifying {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    ProgressView()
                    Text("Confirming payment...".localized)
                    Button("Close".localized) { viewModel.close() }
                }
                .padding(24)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .allowsHitTesting(viewModel.isVerifying)
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
        .onChange(of: viewModel.result) { _, result in
            guard let result else { return }
            onFinish(result)
        }
    }
}
