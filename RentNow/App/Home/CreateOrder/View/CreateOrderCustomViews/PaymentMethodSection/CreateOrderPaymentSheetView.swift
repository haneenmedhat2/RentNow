import SwiftUI

/// A docked sheet keeps the booking form interactive and leaves coordinator sheets available.
struct CreateOrderPaymentSheetView: View {
    @ObservedObject var viewModel: CreateOrderViewModel
    @Binding var isExpanded: Bool
    let maximumHeight: CGFloat

    var body: some View {
        PaymentSheetHeightLayout(maximumHeight: maximumHeight) {
            sheetContent
        }
    }

    private var sheetContent: some View {
        VStack(spacing: 12) {
            Button {
                setExpanded(!isExpanded)
            } label: {
                VStack(spacing: 8) {
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 44, height: 4)
                    if !isExpanded {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.mainColor)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 28)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel((isExpanded ? "checkout_collapse_payment" : "checkout_expand_payment").localized)
            .simultaneousGesture(DragGesture(minimumDistance: 20).onEnded { value in
                if abs(value.translation.height) > 30 {
                    setExpanded(value.translation.height < 0)
                }
            })

            if isExpanded {
                ViewThatFits(in: .vertical) {
                    paymentOptions.fixedSize(horizontal: false, vertical: true)
                    ScrollView(showsIndicators: false) { paymentOptions }
                }
            }

            Button(action: viewModel.createOrder) {
                HStack(spacing: 10) {
                    if viewModel.isCreatingOrder { ProgressView().tint(.white) }
                    Text("checkout_confirm_booking_payment".localized)
                        .expoSystemFont(size: 18, weight: .bold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 56)
                .background(CreateOrderPaymentSheetStyle.navy, in: RoundedRectangle(cornerRadius: 16))
                .opacity(viewModel.canConfirmOrder ? 1 : 0.4)
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.canConfirmOrder)
            .padding(.horizontal, 16)
        }
        .padding(.top, 4)
        .padding(.bottom, 16)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                .fill(.white)
                .ignoresSafeArea(edges: .bottom)
        }
    }

    private var paymentOptions: some View {
        CreateOrderPaymentMethodView(
            paymentOptions: viewModel.visiblePaymentOptions,
            selectedMethodId: viewModel.selectedPaymentMethodId,
            moyasarMethod: $viewModel.moyasarMethod,
            error: viewModel.paymentMethodError,
            isRefreshing: viewModel.isCheckingPaymentOptions,
            refreshError: viewModel.paymentOptionsError,
            isSelectionEnabled: viewModel.canSelectPaymentMethod,
            paymentAmount: viewModel.canConfirmOrder ? viewModel.paymentSummary?.total : nil,
            currency: viewModel.paymentSummary?.currency ?? "SAR",
            showsTitle: false,
            usesCheckoutLayout: true,
            onSelect: viewModel.selectPaymentMethod,
            onRetry: viewModel.checkAndFetchSummary
        )
    }

    private func setExpanded(_ expanded: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) { isExpanded = expanded }
    }
}

enum CreateOrderPaymentSheetStyle {
    static let navy = Color(hex: "102D60")
    static let border = Color(hex: "E3E5EC")
    static let selectedBackground = Color(hex: "F4F6FD")
    static let installmentAccent = Color(hex: "CDA13E")
}

/// Reserve only the sheet's content height, up to the limit needed to keep the form visible.
/// A flexible max-height frame would also reserve unused space above short payment lists.
private struct PaymentSheetHeightLayout: Layout {
    let maximumHeight: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let content = subviews.first else { return .zero }
        let idealSize = content.sizeThatFits(ProposedViewSize(width: proposal.width, height: nil))
        return CGSize(width: idealSize.width, height: min(idealSize.height, maximumHeight))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first?.place(
            at: bounds.origin,
            proposal: ProposedViewSize(width: bounds.width, height: bounds.height)
        )
    }
}
