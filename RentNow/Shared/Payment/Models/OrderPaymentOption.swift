import Foundation

/// A payment choice returned by order page and summary APIs, including availability.
struct OrderPaymentOption: Codable, Identifiable {
    let id: Int?
    let provider: PaymentProvider?
    let name: String?
    let isAvailable: Bool?
    let unavailableReasonKey: String?
    let rejectionReason: String?
    let unavailableReason: String?
    let amount: Double?
    let currency: String?
    let instalmentsCount: Int?
    let instalmentAmount: Double?

    init(id: Int, name: String, isAvailable: Bool, unavailableReason: String? = nil,
         instalmentsCount: Int? = nil, instalmentAmount: Double? = nil, currency: String? = nil) {
        self.id = id
        self.name = name
        self.isAvailable = isAvailable
        self.unavailableReason = unavailableReason
        self.instalmentsCount = instalmentsCount
        self.instalmentAmount = instalmentAmount
        self.currency = currency
        provider = nil
        unavailableReasonKey = nil
        rejectionReason = nil
        amount = nil
    }

    static func selectableOptions(_ options: [Self]?) -> [Self] {
        var seen = Set<Int>()
        return (options ?? []).filter {
            guard let id = $0.id, [1, 2, 4].contains(id) else { return false }
            return seen.insert(id).inserted
        }
    }

    static func validSelection(_ selection: Int?, in options: [Self]) -> Int? {
        guard let selection, [1, 2, 4].contains(selection),
              options.contains(where: { $0.id == selection && $0.isAvailable == true }) else { return nil }
        return selection
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        provider = try container.decodeIfPresent(PaymentProvider.self, forKey: .provider)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        isAvailable = try container.decodeIfPresent(Bool.self, forKey: .isAvailable)
        unavailableReasonKey = try container.decodeIfPresent(String.self, forKey: .unavailableReasonKey) ?? ""
        rejectionReason = try container.decodeIfPresent(String.self, forKey: .rejectionReason)
        unavailableReason = try container.decodeIfPresent(String.self, forKey: .unavailableReason) ?? ""
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        instalmentsCount = try container.decodeIfPresent(Int.self, forKey: .instalmentsCount)
        instalmentAmount = try container.decodeIfPresent(Double.self, forKey: .instalmentAmount)
    }
}

/// Two customer-facing Moyasar choices share backend payment method 1.
enum MoyasarPaymentMethod: String, Codable, Equatable {
    case card
    case applePay
}
