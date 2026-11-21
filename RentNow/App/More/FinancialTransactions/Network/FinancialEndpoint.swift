//
//  FinancialEndpoint.swift
//  RentNow
//

import Foundation
import Alamofire

enum FinancialEndpoint {

    static func getWaitingSettlements() -> Endpoint<BaseResponse<WaitingSettlementsResponse>> {
        return .init(
            method: .get,
            path: "Financial/allWaitingSettlements",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func requestSettlement(
        iban: String,
        accountName: String,
        accountNumber: String,
        bankName: String
    ) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Financial/RequestSettlement",
            body: [
                "Iban": iban,
                "AccountName": accountName,
                "AccountNumber": accountNumber,
                "BankName": bankName
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getAllSettlements(status: String) -> Endpoint<BaseResponse<[SettlementListItem]>> {
        return .init(
            method: .get,
            path: "Financial/GetAllSettlements",
            queries: ["status": status],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getSettlementDetails(id: Int) -> Endpoint<BaseResponse<SettlementDetailsData>> {
        return .init(
            method: .get,
            path: "Financial/GetSettlementDetails/\(id)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }
}
