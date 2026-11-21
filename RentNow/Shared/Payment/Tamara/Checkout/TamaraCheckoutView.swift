import SwiftUI

struct TamaraCheckoutView: View {
    @StateObject private var viewModel: TamaraCheckoutViewModel
    private let onFinish: (PaymentResult) -> Void

    init(session: PaymentSession, onFinish: @escaping (PaymentResult) -> Void) {
        _viewModel = StateObject(wrappedValue: TamaraCheckoutViewModel(session: session))
        self.onFinish = onFinish
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if let payment = viewModel.session.tamara {
                    TamaraSDKCheckoutView(
                        payment: payment,
                        onSuccess: { viewModel.verifyPayment(afterSuccess: true) },
                        onFailureOrCancel: { viewModel.verifyPayment(afterSuccess: false) }
                    )
                    .allowsHitTesting(!viewModel.isVerifying)
                }

                if viewModel.isVerifying {
                    Color.black.opacity(0.15).ignoresSafeArea()
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Checking payment status...".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                    }
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .navigationTitle("Tamara".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close".localized) {
                        viewModel.verifyPayment(afterSuccess: false)
                    }
                    .disabled(viewModel.isVerifying)
                }
            }
        }
        .interactiveDismissDisabled()
        .logViewAppearance()
        .onDisappear { viewModel.stop() }
        .onChange(of: viewModel.result) { _, result in
            if let result { onFinish(result) }
        }
    }
}
