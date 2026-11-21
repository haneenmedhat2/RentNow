import Foundation

/// Shared payment initiation response for wallet, packages, and extra kilometers.
struct PaymentInitiationData: Codable {
    let isPackagePayment: Bool?
    let paymentUrl: String?
    let transactionId: String?
    let message: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isPackagePayment = try container.decodeIfPresent(Bool.self, forKey: .isPackagePayment)
        paymentUrl = try container.decodeIfPresent(String.self, forKey: .paymentUrl) ?? ""
        transactionId = try container.decodePaymentTransactionIDIfPresent(forKey: .transactionId)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}

/// PayOrder returns a string transaction ID; status responses may return a number.
extension KeyedDecodingContainer {
    func decodePaymentTransactionIDIfPresent(forKey key: Key) throws -> String? {
        guard contains(key), try !decodeNil(forKey: key) else { return nil }
        if let value = try? decode(String.self, forKey: key) { return value }
        return String(try decode(Int64.self, forKey: key))
    }
}
