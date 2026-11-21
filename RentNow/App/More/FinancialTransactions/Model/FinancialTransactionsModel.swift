//
//  FinancialTransactionsModel.swift
//  RentNow
//

import Foundation

// MARK: - Tab Type
enum FinancialTabType: Int, CaseIterable, Identifiable {
    case outstanding = 0
    case newSettlement = 1
    case endedSettlement = 2

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .outstanding:      return "Outstanding".localized
        case .newSettlement:     return "New Settlement".localized
        case .endedSettlement:   return "Completed Settlement".localized
        }
    }
}

// MARK: - Waiting Settlement Item (Outstanding Order)
struct WaitingSettlementItem: Codable, Identifiable {
    let id: Int?
    let orderNum: String?
    let since: String?
    let price: String?
    let tax: String?
    let vat: String?
    let commissionDiscount:String?
    let amountDue: String?
    let finalTotal: String?
    let adminCommission: String?

    init(id: Int?, orderNum: String?, since: String?, price: String?, tax: String?, vat: String?, amountDue: String?, finalTotal: String?, adminCommission: String? , commissionDiscount:String?) {
        self.id = id; self.orderNum = orderNum; self.since = since; self.price = price
        self.tax = tax; self.vat = vat; self.amountDue = amountDue; self.finalTotal = finalTotal
        self.adminCommission = adminCommission
        self.commissionDiscount = commissionDiscount
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.orderNum = try container.decodeIfPresent(String.self, forKey: .orderNum) ?? ""
        self.since = try container.decodeIfPresent(String.self, forKey: .since) ?? ""
        if let priceDouble = try? container.decodeIfPresent(Double.self, forKey: .price) {
            self.price = String(format: "%.2f", priceDouble)
        } else {
            self.price = try container.decodeIfPresent(String.self, forKey: .price) ?? "0"
        }
        if let taxDouble = try? container.decodeIfPresent(Double.self, forKey: .tax) {
            self.tax = String(format: "%.2f", taxDouble)
        } else {
            self.tax = try container.decodeIfPresent(String.self, forKey: .tax) ?? "0"
        }
        if let vatDouble = try? container.decodeIfPresent(Double.self, forKey: .vat) {
            self.vat = String(format: "%.2f", vatDouble)
        } else {
            self.vat = try container.decodeIfPresent(String.self, forKey: .vat) ?? "0"
        }
        if let commissionDiscountDouble = try? container.decodeIfPresent(Double.self, forKey: .commissionDiscount) {
            self.commissionDiscount = String(format: "%.2f", commissionDiscountDouble)
        } else {
            self.commissionDiscount = try container.decodeIfPresent(String.self, forKey: .commissionDiscount) ?? "0"
        }
        
        
        if let amountDueDouble = try? container.decodeIfPresent(Double.self, forKey: .amountDue) {
            self.amountDue = String(format: "%.2f", amountDueDouble)
        } else {
            self.amountDue = try container.decodeIfPresent(String.self, forKey: .amountDue) ?? "0"
        }
        if let finalTotalDouble = try? container.decodeIfPresent(Double.self, forKey: .finalTotal) {
            self.finalTotal = String(format: "%.2f", finalTotalDouble)
        } else {
            self.finalTotal = try container.decodeIfPresent(String.self, forKey: .finalTotal) ?? "0"
        }
        if let adminCommissionDouble = try? container.decodeIfPresent(Double.self, forKey: .adminCommission) {
            self.adminCommission = String(format: "%.2f", adminCommissionDouble)
        } else {
            self.adminCommission = try container.decodeIfPresent(String.self, forKey: .adminCommission) ?? "0"
        }
    }
}

// MARK: - Waiting Settlement Summary
struct WaitingSettlementSummary: Codable {
    let total: Double?
    let totalVat: Double?
    let totalTax: Double?
    let totalAmountDue: Double?
    let totalCommissionDiscount:Double?

    init(total: Double?, totalVat: Double?, totalTax: Double?, totalAmountDue: Double? , totalCommissionDiscount:Double?) {
        self.total = total
        self.totalVat = totalVat
        self.totalTax = totalTax
        self.totalAmountDue = totalAmountDue
        self.totalCommissionDiscount = totalCommissionDiscount
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decodeIfPresent(Double.self, forKey: .total) ?? 0.0
        self.totalVat = try container.decodeIfPresent(Double.self, forKey: .totalVat) ?? 0.0
        self.totalTax = try container.decodeIfPresent(Double.self, forKey: .totalTax) ?? 0.0
        self.totalAmountDue = try container.decodeIfPresent(Double.self, forKey: .totalAmountDue) ?? 0.0
        self.totalCommissionDiscount = try container.decodeIfPresent(Double.self, forKey: .totalCommissionDiscount) ?? 0.0
        
    }

    var totalFormatted: String { String(format: "%.2f", total ?? 0) }
    var totalVatFormatted: String { String(format: "%.2f", totalVat ?? 0) }
    var totalTaxFormatted: String { String(format: "%.2f", totalTax ?? 0) }
    var totalAmountDueFormatted: String { String(format: "%.2f", totalAmountDue ?? 0) }
    var totalCommissionDiscountFormatted: String { String(format: "%.2f", totalCommissionDiscount ?? 0) }

    
}

// MARK: - Waiting Settlements Response
struct WaitingSettlementsResponse: Codable {
    let settlements: [WaitingSettlementItem]?
    let summary: WaitingSettlementSummary?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.settlements = try container.decodeIfPresent([WaitingSettlementItem].self, forKey: .settlements) ?? []
        self.summary = try container.decodeIfPresent(WaitingSettlementSummary.self, forKey: .summary)
    }
}

// MARK: - Settlement List Item (New/Ended)
struct SettlementListItem: Codable, Identifiable {
    let id: Int?
    let dateFormatted: String?
    let totalAmountDue: String?
    let statusName: String?
    let statusId: Int?
    let settlementNum: String?

    init(id: Int?, dateFormatted: String?, totalAmountDue: String?, statusName: String?, statusId: Int?, settlementNum: String?) {
        self.id = id; self.dateFormatted = dateFormatted; self.totalAmountDue = totalAmountDue
        self.statusName = statusName; self.statusId = statusId; self.settlementNum = settlementNum
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.dateFormatted = try container.decodeIfPresent(String.self, forKey: .dateFormatted) ?? ""
        if let totalAmountDueDouble = try? container.decode(Double.self, forKey: .totalAmountDue) {
            self.totalAmountDue = String(format: "%.2f", totalAmountDueDouble)
        } else {
            self.totalAmountDue = try container.decodeIfPresent(String.self, forKey: .totalAmountDue) ?? "0"
        }
        self.statusName = try container.decodeIfPresent(String.self, forKey: .statusName) ?? ""
        self.statusId = try container.decodeIfPresent(Int.self, forKey: .statusId)
        self.settlementNum = try container.decodeIfPresent(String.self, forKey: .settlementNum)
    }
}

// MARK: - Settlement Details Data
struct SettlementDetailsData: Codable {
    let id: Int?
    let totalOrders: Double?
    let totalVat: Double?
    let totalTax: Double?
    let totalAmountDue: Double?
    let totalCommissionDiscount: Double?
    let statusName: String?
    let statusId: Int?
    let transferImage: String?
    let rejectionReason: String?
    let iban: String?
    let accountName: String?
    let accountNumber: String?
    let bankName: String?
    let dateFormatted: String?
    let orders: [WaitingSettlementItem]?

    enum CodingKeys: String, CodingKey {
        case id, statusName, statusId, transferImage, rejectionReason
        case iban, accountName, accountNumber, bankName
        case totalOrders = "price"
        case totalVat = "vat"
        case totalTax = "tax"
        case totalAmountDue = "amountDue"
        case totalCommissionDiscount = "commissionDiscount"
        case dateFormatted = "since"
        case orders = "settlements"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.totalOrders = try container.decodeIfPresent(Double.self, forKey: .totalOrders) ?? 0.0
        self.totalVat = try container.decodeIfPresent(Double.self, forKey: .totalVat) ?? 0.0
        self.totalTax = try container.decodeIfPresent(Double.self, forKey: .totalTax) ?? 0.0
        self.totalAmountDue = try container.decodeIfPresent(Double.self, forKey: .totalAmountDue) ?? 0.0
        self.totalCommissionDiscount = try container.decodeIfPresent(Double.self, forKey: .totalCommissionDiscount) ?? 0.0
        self.statusName = try container.decodeIfPresent(String.self, forKey: .statusName) ?? ""
        self.statusId = try container.decodeIfPresent(Int.self, forKey: .statusId)
        self.transferImage = try container.decodeIfPresent(String.self, forKey: .transferImage)
        self.rejectionReason = try container.decodeIfPresent(String.self, forKey: .rejectionReason)
        self.iban = try container.decodeIfPresent(String.self, forKey: .iban) ?? ""
        self.accountName = try container.decodeIfPresent(String.self, forKey: .accountName) ?? ""
        self.accountNumber = try container.decodeIfPresent(String.self, forKey: .accountNumber) ?? ""
        self.bankName = try container.decodeIfPresent(String.self, forKey: .bankName) ?? ""
        self.dateFormatted = try container.decodeIfPresent(String.self, forKey: .dateFormatted) ?? ""
        self.orders = try container.decodeIfPresent([WaitingSettlementItem].self, forKey: .orders) ?? []
    }
    var totalOrdersFormatted: String { String(format: "%.2f", totalOrders ?? 0) }
    var totalVatFormatted: String { String(format: "%.2f", totalVat ?? 0) }
    var totalTaxFormatted: String { String(format: "%.2f", totalTax ?? 0) }
    var totalAmountDueFormatted: String { String(format: "%.2f", totalAmountDue ?? 0) }
    var totalCommissionDiscountFormatted: String { String(format: "%.2f", totalCommissionDiscount ?? 0) }
}
