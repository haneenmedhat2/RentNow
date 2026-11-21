import Foundation
import Alamofire

/// Payment status endpoints; each returns its own server response model.
enum PaymentEndpoint {
    static func checkInstallmentEligibility(amount: Double, paymentMethod: Int? = nil) -> Endpoint<BaseResponse<InstallmentEligibilityData>> {
        var body: [String: Any?] = ["amount": amount]
        if let paymentMethod { body["paymentMethod"] = paymentMethod }
        return .init(
            method: .post,
            path: "Payment/CheckInstallmentEligibility",
            body: body,
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    
    static func confirmMoyasar(transactionId: String, paymentId: String, timeoutInterval: TimeInterval? = nil) -> Endpoint<BaseResponse<OrderPaymentStatusData>> {
        .init(method: .post, path: "Payment/Confirm",
              body: ["transactionId": transactionId, "moyasarPaymentId": paymentId],
              headerType: .authorized(token: UserDefaults.accessToken ?? ""), timeoutInterval: timeoutInterval)
    }

    /// Backend verification for order, wallet, and package checkout.
    static func getOrderStatus(transactionId: String, timeoutInterval: TimeInterval? = nil) -> Endpoint<BaseResponse<OrderPaymentStatusData>> {
        var allowed = CharacterSet.urlPathAllowed
        allowed.remove(charactersIn: "/?#%")
        let id = transactionId.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        return .init(
            method: .get,
            path: "Payment/Status/\(id)",
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            timeoutInterval: timeoutInterval
        )
    }
}
