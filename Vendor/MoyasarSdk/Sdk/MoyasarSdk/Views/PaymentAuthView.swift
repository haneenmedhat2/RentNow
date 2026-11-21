import SwiftUI
import WebKit

public struct PaymentAuthView: UIViewRepresentable {
    public var url: URL
    public var callback: WebViewResultCallback
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = true
        context.coordinator.installLoadingIndicator(in: webView)
        context.coordinator.loadIfNeeded(url, in: webView)
        return webView
    }
    
    public func updateUIView(_ wkWebView: WKWebView, context: Context) {
        context.coordinator.loadIfNeeded(url, in: wkWebView)
    }

    public static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        coordinator.stopLoadingIndicator()
        webView.navigationDelegate = nil
        webView.stopLoading()
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        private var webView: PaymentAuthView
        private var requestedURL: URL?
        private var didReturnResult = false
        private let loadingIndicator = UIActivityIndicatorView(style: .medium)
        private var loadingTimeout: DispatchWorkItem?
        
        fileprivate init(_ webView: PaymentAuthView) {
            self.webView = webView
        }

        fileprivate func loadIfNeeded(_ url: URL, in view: WKWebView) {
            guard requestedURL != url else { return }
            requestedURL = url
            view.load(URLRequest(url: url))
        }

        fileprivate func installLoadingIndicator(in view: WKWebView) {
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loadingIndicator)
            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

        fileprivate func stopLoadingIndicator() {
            loadingTimeout?.cancel()
            loadingTimeout = nil
            loadingIndicator.stopAnimating()
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            guard !didReturnResult else { return }
            #if DEBUG
            print("Moyasar 3DS: navigation started")
            #endif
            stopLoadingIndicator()
            loadingIndicator.startAnimating()
            let timeout = DispatchWorkItem { [weak self, weak webView] in
                guard let self, !self.didReturnResult else { return }
                webView?.stopLoading()
                self.returnFailure(NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut))
            }
            loadingTimeout = timeout
            DispatchQueue.main.asyncAfter(deadline: .now() + 45, execute: timeout)
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            stopLoadingIndicator()
            #if DEBUG
            print("Moyasar 3DS: navigation finished")
            #endif
        }
        
        // TODO: Handle navigation errors
        
        // TODO: Handle business and server errors
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            switch navigationAction.request.url?.host {
            case "sdk.moyasar.com":
                decisionHandler(.cancel)
                if !didReturnResult {
                    didReturnResult = true
                    stopLoadingIndicator()
                    #if DEBUG
                    let components = URLComponents(url: navigationAction.request.url!, resolvingAgainstBaseURL: false)
                    let status = components?.queryItems?.first(where: { $0.name == "status" })?.value?.lowercased() ?? ""
                    let safeStatus = ["initiated", "paid", "failed", "authorized", "captured"].contains(status) ? status : "other"
                    print("Moyasar 3DS: return callback, status=\(safeStatus)")
                    #endif
                    self.webView.returnResultFromUrl(url: navigationAction.request.url!)
                }
            default:
                decisionHandler(.allow)
            }
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            returnFailure(error)
        }
        
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            returnFailure(error)
        }

        public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            returnFailure(NSError(domain: "MoyasarPaymentAuth", code: 1))
        }

        private func returnFailure(_ error: Error) {
            let nsError = error as NSError
            guard !didReturnResult, !(nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled) else { return }
            didReturnResult = true
            stopLoadingIndicator()
            self.webView.returnFailureIfPossibleError(error: error)
        }
    }
    
    private func returnResultFromUrl(url: URL) {
        let comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let id = comp?.queryItems?.getByKey("id") ?? ""
        let status = comp?.queryItems?.getByKey("status") ?? ""
        let message = comp?.queryItems?.getByKey("message") ?? ""
        
        callback(WebViewResult.completed(WebViewPaymentInfo(id: id, status: status, message: message)))
    }
    
    /// Calls the callback with a failure case if the error is considered fatal
    private func returnFailureIfPossibleError(error: Error) {
        let nsError = error as NSError
        
        // TODO: Should we cover more errors?
        if nsError.code == NSURLErrorTimedOut {
            callback(WebViewResult.failed(PaymentAuthError.timeOut))
        } else if nsError.code == NSURLErrorNotConnectedToInternet {
            callback(WebViewResult.failed(PaymentAuthError.notConnectedToInternet))
        } else if nsError.code == NSURLErrorCannotConnectToHost || nsError.code == NSURLErrorCannotFindHost {
            callback(WebViewResult.failed(PaymentAuthError.unexpectedError(error)))
        } else {
            callback(WebViewResult.failed(PaymentAuthError.unexpectedError(error)))
        }
    }
}

public typealias WebViewResultCallback = (WebViewResult) -> ()

public struct WebViewPaymentInfo {
    var id: String
    var status: String
    var message: String?
}

public enum WebViewResult {
    case completed(WebViewPaymentInfo)
    case failed(PaymentAuthError)
}

public enum PaymentAuthError: Error {
    case timeOut
    case notConnectedToInternet
    case unexpectedError(Error)
}

extension Array where Element == URLQueryItem {
    func getByKey(_ key: String) -> String {
        return self.first(where: { $0.name == key })?.value ?? ""
    }
}

extension ApiPayment {
    mutating func updateFromWebViewPaymentInfo(_ info: WebViewPaymentInfo) {
        self.status = ApiPaymentStatus(rawValue: info.status)!
        if case var .creditCard(source) = self.source {
            source.message = info.message
            self.source = .creditCard(source)
        }
    }
}
