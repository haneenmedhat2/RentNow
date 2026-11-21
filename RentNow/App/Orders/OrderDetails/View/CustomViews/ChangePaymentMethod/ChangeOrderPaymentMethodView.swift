import SwiftUI

struct ChangeOrderPaymentMethodView: View {
    @StateObject var viewModel: ChangeOrderPaymentMethodViewModel
    var onSaved: (OrderDetailsData) -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            MainGradientView().ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Text("Change payment method".localized)
                        .expoSystemFont(size: FontSize.large, weight: .semiBold)
                    Spacer()
                    Button("Close".localized, action: onClose)
                        .disabled(viewModel.isSaving)
                }
                .padding(.horizontal, 16)

                ScrollView {
                    CreateOrderPaymentMethodView(
                        paymentOptions: viewModel.options,
                        selectedMethodId: viewModel.selectedMethodId,
                        moyasarMethod: $viewModel.moyasarMethod,
                        error: viewModel.saveError,
                        isRefreshing: viewModel.isFetching,
                        refreshError: viewModel.loadError,
                        onSelect: viewModel.select,
                        onRetry: { Task { await viewModel.loadMethods() } }
                    )
                    .disabled(viewModel.isSaving)
                }

                if viewModel.isSaving {
                    ProgressView("Updating payment method...".localized)
                }
                MainButton(title: "Confirm".localized) {
                    Task {
                        if let updated = await viewModel.save() {
                            onSaved(updated)
                        }
                    }
                }
                .disabled(!viewModel.canSave)
                .opacity(viewModel.canSave ? 1 : 0.5)
            }
            .padding(.vertical, 24)
        }
        .interactiveDismissDisabled(viewModel.isSaving)
        .task { await viewModel.loadMethods() }
    }
}
