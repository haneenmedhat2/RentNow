import SwiftUI
import WebKit
import Tabby

struct TabbyCheckoutWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    let onNavigationStart: () -> Void
    let onTabbyResult: (TabbyResult) -> Void
    let onError: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // The backend creates the session; receive checkout events through Tabby's bridge.
        configuration.userContentController.add(context.coordinator, name: "tabbyMobileSDK")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.stopLoading()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "tabbyMobileSDK")
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        private let parent: TabbyCheckoutWebView

        init(parent: TabbyCheckoutWebView) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "tabbyMobileSDK",
                  message.frameInfo.securityOrigin.protocol == "https",
                  PaymentSession.isTabbyCheckoutHost(message.frameInfo.securityOrigin.host),
                  let body = message.body as? String else { return }
            let result: TabbyResult
            switch body.trimmingCharacters(in: CharacterSet(charactersIn: "\"")) {
            case "authorized": result = .authorized
            case "rejected": result = .rejected
            case "close": result = .close
            case "expired": result = .expired
            default: return
            }
            parent.onTabbyResult(result)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
            parent.isLoading = true
            parent.onNavigationStart()
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
            parent.isLoading = false
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation?,
            withError error: any Error
        ) {
            handle(error)
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation?,
            withError error: any Error
        ) {
            handle(error)
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }

            let scheme = url.scheme?.lowercased()
            if scheme == "http" || scheme == "https" || scheme == "about" {
                if navigationAction.targetFrame == nil {
                    webView.load(navigationAction.request)
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
                return
            }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        }

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            if let requestURL = navigationAction.request.url {
                webView.load(URLRequest(url: requestURL))
            }
            return nil
        }

        private func handle(_ error: any Error) {
            let nsError = error as NSError
            guard nsError.code != NSURLErrorCancelled else { return }
            parent.isLoading = false
            parent.onError("Unable to load payment page".localized)
        }
    }
}
