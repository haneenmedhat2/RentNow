import Foundation

/// Shared payment payload for PayOrder, ChargeWallet, and Subscribe, including provider checkout data.
struct PayOrderData: Codable {
    let isPackagePayment: Bool?
    let paymentUrl: String?
    let transactionId: String?
    let message: String?
    let provider: PaymentProvider?
    let paymentMethodId: Int?
    let amount: Double?
    let amountDecimal: Decimal?
    let moyasarPaymentAttemptId: String?
    let currency: String?
    let expiresAt: String?
    let paymentStatus: OrderPaymentStatus?
    let paymentStatusText: String?
    let tabby: TabbyPaymentData?
    let tamara: TamaraPaymentData?

    enum CodingKeys: String, CodingKey {
        case isPackagePayment, paymentUrl, transactionId, message, provider, paymentMethodId
        case amount, currency, expiresAt, paymentStatus, paymentStatusText, tabby, tamara, moyasarPaymentAttemptId
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isPackagePayment, forKey: .isPackagePayment)
        try container.encodeIfPresent(paymentUrl, forKey: .paymentUrl)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(provider, forKey: .provider)
        try container.encodeIfPresent(paymentMethodId, forKey: .paymentMethodId)
        try container.encodeIfPresent(amountDecimal, forKey: .amount)
        try container.encodeIfPresent(currency, forKey: .currency)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(paymentStatus, forKey: .paymentStatus)
        try container.encodeIfPresent(paymentStatusText, forKey: .paymentStatusText)
        try container.encodeIfPresent(tabby, forKey: .tabby)
        try container.encodeIfPresent(tamara, forKey: .tamara)
        try container.encodeIfPresent(moyasarPaymentAttemptId, forKey: .moyasarPaymentAttemptId)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isPackagePayment = try container.decodeIfPresent(Bool.self, forKey: .isPackagePayment)
        paymentUrl = try container.decodeIfPresent(String.self, forKey: .paymentUrl)
        transactionId = try container.decodePaymentTransactionIDIfPresent(forKey: .transactionId)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        provider = try container.decodeIfPresent(PaymentProvider.self, forKey: .provider)
        paymentMethodId = try container.decodeIfPresent(Int.self, forKey: .paymentMethodId)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        amountDecimal = try container.decodeIfPresent(Decimal.self, forKey: .amount)
        moyasarPaymentAttemptId = try container.decodeIfPresent(String.self, forKey: .moyasarPaymentAttemptId)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        expiresAt = try container.decodeIfPresent(String.self, forKey: .expiresAt)
        paymentStatus = try container.decodeIfPresent(OrderPaymentStatus.self, forKey: .paymentStatus)
        paymentStatusText = try container.decodeIfPresent(String.self, forKey: .paymentStatusText)
        tabby = try container.decodeIfPresent(TabbyPaymentData.self, forKey: .tabby)
        tamara = try container.decodeIfPresent(TamaraPaymentData.self, forKey: .tamara)
    }
}

struct TabbyPaymentData: Codable {
    let status: String?
    let paymentId: String?
    let sessionId: String?
    let webUrl: String?
    let rejectionReason: String?
    let rejectionMessage: String?
}

struct TamaraPaymentData: Codable, Equatable {
    let isEligible: Bool?
    let checkoutUrl: String?
    let orderId: String?
    let checkoutId: String?
    let successUrl: String?
    let failureUrl: String?
    let cancelUrl: String?
    let rejectionReason: String?
    let rejectionMessage: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isEligible = try container.decodeIfPresent(Bool.self, forKey: .isEligible)
        checkoutUrl = try container.decodeIfPresent(String.self, forKey: .checkoutUrl)
        orderId = try container.decodeIfPresent(String.self, forKey: .orderId) ?? ""
        checkoutId = try container.decodeIfPresent(String.self, forKey: .checkoutId)
        successUrl = try container.decodeIfPresent(String.self, forKey: .successUrl)
        failureUrl = try container.decodeIfPresent(String.self, forKey: .failureUrl)
        cancelUrl = try container.decodeIfPresent(String.self, forKey: .cancelUrl)
        rejectionReason = try container.decodeIfPresent(String.self, forKey: .rejectionReason) ?? ""
        rejectionMessage = try container.decodeIfPresent(String.self, forKey: .rejectionMessage) ?? ""
    }
}

/// Payment providers returned by the backend.
enum PaymentProvider: String, Codable {
    case moyasar, tabby, tamara, unknown

    init(from decoder: any Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = Self(rawValue: value.lowercased()) ?? .unknown
    }
}

/// Response types for Payment/Status, used to verify order-provider checkout.
enum OrderPaymentStatus: String, Codable {
    case unpaid = "Unpaid"
    case pending = "Pending"
    case paid = "Paid"
    case rejected = "Rejected"
    case cancelled = "Cancelled"
    case expired = "Expired"
    case needsReview = "NeedsReview"
    case refunded = "Refunded"
    case unknown = "Unknown"

    init(from decoder: any Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value.lowercased() {
        case "unpaid": self = .unpaid
        case "pending": self = .pending
        case "paid": self = .paid
        case "rejected": self = .rejected
        case "cancelled", "canceled": self = .cancelled
        case "expired": self = .expired
        case "needsreview": self = .needsReview
        case "refunded": self = .refunded
        default: self = .unknown
        }
    }
}
