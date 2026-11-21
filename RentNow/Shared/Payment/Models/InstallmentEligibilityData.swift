import Foundation

/// Payment/CheckInstallmentEligibility: options are scoped to the submitted amount.
struct InstallmentEligibilityData: Decodable {
    let amount: Double
    let currency: String
    let options: [OrderPaymentOption]
}
