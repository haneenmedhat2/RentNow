import SwiftUI
import WebKit
import SafariServices

struct TamaraInstallmentView: View {
    let amount: Double
    let currency: String
    var isEmbedded = false
    var style: TamaraWidgetConfiguration.Style = .promo

    @State private var height: CGFloat = 240
    @State private var isLoading = true
    @State private var failed = false
    @State private var showDetails = false
    @State private var retryID = UUID()

    var body: some View {
        if currency.isEmpty || currency.uppercased() == "SAR",
           let url = TamaraWidgetConfiguration.installmentURL(amount: amount, language: Language.apiLanguage(), style: style) {
            VStack(spacing: 0) {
                if failed {
                    VStack(spacing: 8) {
                        Text("Unable to load Tamara installments.".localized)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                        Button("Try Again".localized) {
                            failed = false
                            isLoading = true
                            retryID = UUID()
                        }
                    }
                    .padding()
                } else {
                    TamaraWidgetWebView(html: TamaraWidgetConfiguration.inlineHTML(amount: amount, language: Language.apiLanguage(), style: style), height: $height, isLoading: $isLoading, failed: $failed)
                        .frame(height: height)
                        .allowsHitTesting(false)
                        .overlay {
                            Button { showDetails = true } label: { Color.clear.contentShape(Rectangle()) }
                                .accessibilityLabel("Learn more about Tamara installments".localized)
                        }
                        .id("\(url.absoluteString)-\(retryID)")
                        .overlay {
                            if isLoading { ProgressView() }
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(isEmbedded ? 0 : 12)
            .background {
                if !isEmbedded { Color.clear.glassyBackground(cornerRadius: 16) }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .sheet(isPresented: $showDetails) { TamaraWidgetDetailsView(url: url) }
        }
    }
}

/// Tamara's official mobile widget, separate from payment checkout.
private struct TamaraWidgetWebView: UIViewRepresentable {
    let html: String
    @Binding var height: CGFloat
    @Binding var isLoading: Bool
    @Binding var failed: Bool

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(context.coordinator, name: "widgetHeight")
        configuration.userContentController.addUserScript(WKUserScript(source: """
            function updateHeight() {
                const widget = document.querySelector('tamara-widget');
                if (!widget) return;
                const children = widget.shadowRoot ? Array.from(widget.shadowRoot.children) : [];
                const height = Math.max(widget.getBoundingClientRect().height,
                    ...children.map(element => element.getBoundingClientRect().height));
                if (height > 20) window.webkit.messageHandlers.widgetHeight.postMessage(height);
            }
            customElements.whenDefined('tamara-widget').then(() => {
                const widget = document.querySelector('tamara-widget');
                if (!widget) return;
                const resize = new ResizeObserver(updateHeight);
                resize.observe(widget);
                const observeContent = () => {
                    if (widget.shadowRoot) {
                        Array.from(widget.shadowRoot.children).forEach(element => resize.observe(element));
                    }
                    updateHeight();
                };
                if (widget.shadowRoot) {
                    new MutationObserver(observeContent).observe(widget.shadowRoot, {childList: true, subtree: true});
                }
                observeContent();
            });
            """, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.underPageBackgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString(html, baseURL: URL(string: "https://cdn-sandbox.tamara.co"))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.parent = self
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.stopLoading()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "widgetHeight")
        webView.navigationDelegate = nil
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: TamaraWidgetWebView
        init(parent: TamaraWidgetWebView) { self.parent = parent }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.frameInfo.isMainFrame, let height = message.body as? Double,
                  height.isFinite, height > 20 else { return }
            let newHeight = CGFloat(ceil(height))
            if abs(parent.height - newHeight) > 1 { parent.height = newHeight }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            handle(error)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            handle(error)
        }

        private func handle(_ error: Error) {
            guard (error as NSError).code != NSURLErrorCancelled else { return }
            parent.isLoading = false
            parent.failed = true
        }

    }
}

private struct TamaraWidgetDetailsView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}
