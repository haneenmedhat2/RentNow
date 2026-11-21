import SwiftUI

struct TabbyCheckoutView: View {
    @StateObject private var viewModel: TabbyCheckoutViewModel
    @State private var isPageLoading = true
    @State private var pageError: String?
    @State private var webViewId = UUID()

    private let onFinish: (PaymentResult) -> Void

    init(session: PaymentSession, onFinish: @escaping (PaymentResult) -> Void) {
        _viewModel = StateObject(wrappedValue: TabbyCheckoutViewModel(session: session))
        self.onFinish = onFinish
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if let paymentURL = viewModel.session.paymentURL {
                TabbyCheckoutWebView(
                    url: paymentURL,
                    isLoading: $isPageLoading,
                    onNavigationStart: { pageError = nil },
                    onTabbyResult: viewModel.handleTabbyResult,
                    onError: { pageError = $0 }
                )
                .id(webViewId)
                }

                if isPageLoading {
                    ProgressView()
                        .controlSize(.large)
                        .padding(24)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }

                if let pageError {
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 30))
                            .foregroundStyle(.red)
                        Text(pageError)
                            .multilineTextAlignment(.center)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)

                        Button("Try Again".localized) {
                            self.pageError = nil
                            isPageLoading = true
                            webViewId = UUID()
                        }
                    }
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .padding(24)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if viewModel.isCheckingStatus || viewModel.hasStatusConnectionIssue {
                    HStack(spacing: 8) {
                        if viewModel.isCheckingStatus || !viewModel.hasStatusConnectionIssue {
                            ProgressView()
                        } else {
                            Image(systemName: "wifi.exclamationmark")
                        }

                        Text(statusMessage)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.thinMaterial)
                }
            }
            .navigationTitle("Tabby".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close".localized) {
                        viewModel.closePayment()
                    }
                    .disabled(viewModel.isClosing)
                }
            }
        }
        .interactiveDismissDisabled()
        .logViewAppearance()
        .onDisappear { viewModel.stop() }
        .onChange(of: viewModel.result) { _, result in
            guard let result else { return }
            onFinish(result)
        }
    }

    private var statusMessage: String {
        if viewModel.hasStatusConnectionIssue {
            return "Unable to check payment status. Retrying...".localized
        }
        return "Checking payment status...".localized
    }

}
