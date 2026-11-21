import Foundation

/// App checkout state shared by orders, wallet, packages, and extra kilometers.
enum PaymentKind: String, Codable {
    case wallet
    case package
    case order
    case exceededKilometers
}

struct PaymentSession: Equatable {
    let paymentURL: URL?
    let moyasar: MoyasarSDKPayment?
    let transactionId: String
    let kind: PaymentKind
    let orderId: Int?
    let provider: PaymentProvider
    let tamara: TamaraPaymentData?

    var isTabby: Bool { provider == .tabby }

    init?(tabbyPayment payment: PayOrderData, orderId: Int? = nil, kind: PaymentKind = .order) {
        guard payment.provider == .tabby,
              (kind == .order && (orderId ?? 0) > 0) || ((kind == .wallet || kind == .package) && orderId == nil),
              payment.paymentStatus == nil || payment.paymentStatus == .pending || payment.paymentStatus == .unpaid,
              let tabby = payment.tabby,
              tabby.status?.lowercased() != "rejected",
              let rawURL = tabby.webUrl, let url = URL(string: rawURL),
              url.scheme?.lowercased() == "https",
              url.user == nil, url.password == nil,
              url.port == nil || url.port == 443,
              Self.isTabbyCheckoutHost(url.host),
              let transactionId = payment.transactionId?.trimmingCharacters(in: .whitespacesAndNewlines),
              !transactionId.isEmpty else { return nil }
        self.paymentURL = url
        self.transactionId = transactionId
        self.orderId = orderId
        self.kind = kind
        self.provider = .tabby
        self.tamara = nil
        self.moyasar = nil
    }

    init?(tamaraPayment payment: PayOrderData, orderId: Int? = nil, kind: PaymentKind = .order) {
        guard payment.provider == .tamara,
              (kind == .order && (orderId ?? 0) > 0) || ((kind == .wallet || kind == .package) && orderId == nil),
              payment.paymentStatus == .pending || payment.paymentStatus == .unpaid,
              let tamara = payment.tamara, tamara.isEligible == true,
              let checkoutURL = Self.secureURL(tamara.checkoutUrl),
              let host = checkoutURL.host?.lowercased(),
              host == "tamara.co" || host.hasSuffix(".tamara.co"),
              Self.secureURL(tamara.successUrl) != nil,
              Self.secureURL(tamara.failureUrl) != nil,
              Self.secureURL(tamara.cancelUrl) != nil,
              Set([tamara.successUrl, tamara.failureUrl, tamara.cancelUrl]).count == 3,
              let providerOrderId = tamara.orderId, !providerOrderId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let checkoutId = tamara.checkoutId, !checkoutId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let transactionId = payment.transactionId?.trimmingCharacters(in: .whitespacesAndNewlines),
              !transactionId.isEmpty else { return nil }
        self.paymentURL = checkoutURL
        self.transactionId = transactionId
        self.kind = kind
        self.orderId = orderId
        self.provider = .tamara
        self.tamara = tamara
        self.moyasar = nil
    }

    private static func secureURL(_ value: String?) -> URL? {
        guard let value, let url = URL(string: value),
              url.scheme?.lowercased() == "https", let host = url.host, !host.isEmpty,
              url.user == nil, url.password == nil,
              url.port == nil || url.port == 443 else { return nil }
        return url
    }

    init?(moyasarPayment payment: PayOrderData, kind: PaymentKind, orderId: Int? = nil, method: MoyasarPaymentMethod = .card) {
        guard payment.provider == .moyasar,
              payment.paymentStatus == .pending || payment.paymentStatus == .unpaid,
              let transactionId = payment.transactionId?.trimmingCharacters(in: .whitespacesAndNewlines),
              !transactionId.isEmpty,
              let attemptId = payment.moyasarPaymentAttemptId,
              UUID(uuidString: attemptId) != nil,
              let amount = payment.amountDecimal,
              let currency = payment.currency?.uppercased(), currency == "SAR",
              let halalas = MoyasarSDKPayment.halalas(amount) else { return nil }
        if (kind == .order || kind == .exceededKilometers) && (orderId ?? 0) <= 0 { return nil }
        self.paymentURL = nil
        self.transactionId = transactionId
        self.kind = kind
        self.orderId = orderId
        self.provider = .moyasar
        self.tamara = nil
        self.moyasar = MoyasarSDKPayment(attemptId: attemptId, amountHalalas: halalas, currency: currency, expiresAt: payment.expiresAt, method: method)
    }

    static func isTabbyCheckoutHost(_ host: String?) -> Bool {
        guard let host = host?.lowercased() else { return false }
        return host == "checkout.tabby.ai" || host == "checkout.tabby.sa"
    }

    func matches(_ status: OrderPaymentStatusData) -> Bool {
        guard status.transactionId == transactionId, status.provider == provider else { return false }
        if kind == .wallet || kind == .package {
            // Wallet and package payments have no rental order ID; match the transaction and target.
            guard status.orderId == nil else { return false }
            return status.target == nil || status.target?.isEmpty == true || status.target?.lowercased() == kind.rawValue
        }
        if provider == .moyasar, moyasar != nil {
            guard let target = status.target, target.lowercased() == kind.rawValue.lowercased() else { return false }
            if kind == .exceededKilometers {
                return status.orderId == nil || status.orderId == orderId
            }
            if let orderId { return status.targetId == orderId && (status.orderId == nil || status.orderId == orderId) }
            return status.orderId == nil
        }
        guard kind == .order, let orderId,
              provider == .tabby || provider == .tamara else { return false }
        if let target = status.target, !target.isEmpty, target.lowercased() != "order" { return false }
        if let targetId = status.targetId, targetId != orderId { return false }
        if let returnedOrderId = status.orderId, returnedOrderId != orderId { return false }
        return status.orderId == orderId || status.targetId == orderId
    }
}

enum PaymentResult: Equatable {
    case paid
    case failed(message: String?)
    case canceled(message: String?)
    case expired(message: String?)
    case pending
    case needsReview(message: String?)
}

struct MoyasarSDKPayment: Equatable {
    let attemptId: String
    let amountHalalas: Int
    let currency: String
    let expiresAt: String?
    let method: MoyasarPaymentMethod

    var isExpired: Bool {
        guard let expiresAt, !expiresAt.isEmpty else { return false }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fractional = formatter.date(from: expiresAt)
        formatter.formatOptions = [.withInternetDateTime]
        guard let date = fractional ?? formatter.date(from: expiresAt) else { return false }
        return date <= Date()
    }

    static func halalas(_ amount: Decimal) -> Int? {
        guard !amount.isNaN, amount > 0 else { return nil }
        var scaled = amount * 100
        var rounded = Decimal()
        NSDecimalRound(&rounded, &scaled, 0, .plain)
        // Round the API decimal as specified by the backend, including floating-point artifacts.
        guard rounded <= Decimal(Int.max), rounded >= 100 else { return nil }
        return NSDecimalNumber(decimal: rounded).intValue
    }
}
