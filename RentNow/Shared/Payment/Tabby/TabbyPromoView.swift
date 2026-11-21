import SwiftUI
import WebKit

/// Uses Tabby's official promotional script with a transparent canvas.
/// The hosted tabby-promo.html currently hardcodes shouldInheritBg to false.
struct TabbyPromoView: View {
    let amount: Double
    @State private var height: CGFloat = 100
    @State private var details: TabbyPromoDetails?

    var body: some View {
        TabbyPromoWebView(html: Self.html(amount: amount, language: Language.apiLanguage()), height: $height) {
            details = $0
        }
        .frame(height: height)
        .fullScreenCover(item: $details) { details in
            NavigationStack {
                TabbyPromoWebView(details: details, height: .constant(0), onDetails: { _ in })
                    .navigationTitle("Tabby".localized)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Close".localized) { self.details = nil }
                        }
                    }
            }
        }
    }

    static func html(amount: Double, language: String) -> String {
        let lang = language == "ar" ? "ar" : "en"
        let price = String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), amount)
        return """
        <!doctype html><html lang="\(lang)" dir="\(lang == "ar" ? "rtl" : "ltr")">
        <head><meta name="viewport" content="width=device-width, initial-scale=1">
        <style>html,body { margin:0; padding:0; background:transparent; }</style>
        <script src="https://checkout.tabby.ai/widgets/tabby-promo.js"></script></head>
        <body><div id="tabbyPromo"></div><script>
        window.TabbyPromo({selector:"#tabbyPromo", lang:"\(lang)", currency:"SAR",
            price:"\(price)", publicKey:"\(TabbyConfiguration.publicKey)",
            merchantCode:"\(TabbyConfiguration.merchantCode)", shouldInheritBg:true});
        </script></body></html>
        """
    }
}

private struct TabbyPromoDetails: Decodable, Identifiable {
    let url: String
    let data: String
    var id: String { url + data }
}

private struct TabbyPromoWebView: UIViewRepresentable {
    var html: String? = nil
    var details: TabbyPromoDetails? = nil
    @Binding var height: CGFloat
    let onDetails: (TabbyPromoDetails) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        config.userContentController.add(context.coordinator, name: "tabbyMobileSDK")
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = details != nil
        if details == nil {
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.underPageBackgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
        }
        if let html {
            webView.loadHTMLString(html, baseURL: URL(string: "https://widgets.tabby.ai"))
        } else if let details, let url = URL(string: details.url), Self.isTabbyURL(url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.parent = self
        // TabbyInstallmentView changes identity when amount or language changes.
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "tabbyMobileSDK")
    }

    private static func isTabbyURL(_ url: URL) -> Bool {
        guard url.scheme == "https", url.user == nil, url.password == nil,
              let host = url.host?.lowercased() else { return false }
        return host == "tabby.ai" || host.hasSuffix(".tabby.ai") || host == "tabby.sa" || host.hasSuffix(".tabby.sa")
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: TabbyPromoWebView
        init(parent: TabbyPromoWebView) { self.parent = parent }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let details = parent.details,
                  let payload = try? JSONSerialization.data(withJSONObject: ["type": "initializationData", "data": details.data]),
                  let json = String(data: payload, encoding: .utf8) else { return }
            webView.evaluateJavaScript("window.postMessage(\(json), '*');")
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
            decisionHandler(url.absoluteString == "about:blank" || TabbyPromoWebView.isTabbyURL(url) ? .allow : .cancel)
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let string = message.body as? String, let data = string.data(using: .utf8),
                  let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            switch object["type"] as? String {
            case "onChangeDimensions":
                guard parent.details == nil, let dimensions = object["data"] as? [String: Any],
                      let height = dimensions["height"] as? Double, height.isFinite, height > 0 else { return }
                parent.height = CGFloat(height)
            case "onLearnMoreClicked":
                guard let details = try? JSONDecoder().decode(TabbyPromoDetails.self, from: data),
                      let url = URL(string: details.url), TabbyPromoWebView.isTabbyURL(url) else { return }
                parent.onDetails(details)
            default: break
            }
        }
    }
}
