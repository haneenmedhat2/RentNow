import Foundation

///Tabby & Tamara
/// Response types for Payment/Status/
struct OrderPaymentStatusData: Codable {
    let transactionId: String?
    let status: String?
    let provider: PaymentProvider?
    let target: String?
    let targetId: Int?
    let orderId: Int?
    let amount: Double?
    let currency: String?
    let paymentStatus: OrderPaymentStatus?
    let paymentStatusText: String?
    let paymentUrl: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try container.decodePaymentTransactionIDIfPresent(forKey: .transactionId)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        provider = try container.decodeIfPresent(PaymentProvider.self, forKey: .provider)
        target = try container.decodeIfPresent(String.self, forKey: .target) ?? ""
        targetId = try container.decodeIfPresent(Int.self, forKey: .targetId)
        orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        paymentStatus = try container.decodeIfPresent(OrderPaymentStatus.self, forKey: .paymentStatus)
        paymentStatusText = try container.decodeIfPresent(String.self, forKey: .paymentStatusText) ?? ""
        paymentUrl = try container.decodeIfPresent(String.self, forKey: .paymentUrl)
    }
}
