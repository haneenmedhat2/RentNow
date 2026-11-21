//
//  MoreEndpoint.swift
//  RentNow
//

import Foundation
import Alamofire

enum MoreEndpoint {

    static func changeLanguage(language: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "More/ChangeLanguage",
            body: ["language": language],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getProfileEditData() -> Endpoint<BaseResponse<EditProfileData>> {
        return .init(
            method: .get,
            path: "More/GetProfileEditData",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }
    
    static func getProfileInfo() -> Endpoint<BaseResponse<ProfileInfoData>> {
        return .init(
            method: .get,
            path: "More/GetProfileInfo",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func updateProfile(
        email: String,
        userName: String,
        cityId: Int,
        countryId: Int,
        imageData: Data?
    ) -> Endpoint<BaseResponse<UpdateProfileData>> {
        let bodyParams: APIParameters = [
//            "Email": email,
            "UserName": userName,
            "CityId": cityId,
            "CountryId": countryId
        ]

        var uploads: [UploadData]? = nil
        if let data = imageData {
            uploads = [UploadData(key: "Image", data: data, mimeType: .jpeg)]
        }

        return .init(
            method: .put,
            path: "More/UpdateProfile",
            body: bodyParams,
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            uploads: uploads,
            encoding: .formData
        )
    }
    
    static func validatePassword(password: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "More/ValidatePassword",
            body: [
                "password": password
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func requestChangePhone(phoneCode: String, newPhoneNumber: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "More/RequestChangePhoneNumber",
            body: [
                "phoneCode": phoneCode,
                "newPhoneNumber": newPhoneNumber
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func confirmChangePhone(phoneCode: String, newPhoneNumber: String, code: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "More/ConfirmChangePhoneNumber",
            body: [
                "phoneCode": phoneCode,
                "newPhoneNumber": newPhoneNumber,
                "code": code
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func resendChangePhoneCode(phoneCode: String, newPhoneNumber: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "More/ResendChangePhoneCode",
            body: [
                "phoneCode": phoneCode,
                "newPhoneNumber": newPhoneNumber
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func changePassword(phoneNumber: String, oldPassword: String, newPassword: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "More/ChangePassword",
            body: [
                "phoneNumber": phoneNumber,
                "oldPassword": oldPassword,
                "newPassword": newPassword
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func toggleNotification(isEnabled: Bool) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "More/ToggleNotification",
            body: ["isEnabled": isEnabled],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func removeAccount() -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .delete,
            path: "More/RemoveAccount",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func logout() -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .delete,
            path: "Auth/Logout",
            body: [
                "deviceId": UserDefaults.pushNotificationToken,
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getMyRates() -> Endpoint<BaseResponse<[MyRateItem]>> {
        return .init(
            method: .get,
            path: "More/GetMyRates",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getMyAds(status: String) -> Endpoint<BaseResponse<[MyAdItem]>> {
        return .init(
            method: .get,
            path: "Advertisement/GetMyAds",
            queries: ["status": status],
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            
            
        )
    }

    static func getMyCarOrders(filter: String) -> Endpoint<BaseResponse<[CustomerOrderItem]>> {
        return .init(
            method: .get,
            path: "Order/GetMyCarOrders",
            queries: ["filter": filter],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getMyAdDetails(id: Int) -> Endpoint<BaseResponse<MyAdDetailsData>> {
        return .init(
            method: .get,
            path: "Advertisement/GetMyAdDetails/\(id)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func toggleAdAvailability(id: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Advertisement/ToggleAvailability/\(id)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func deleteAd(id: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .delete,
            path: "Advertisement/Delete/\(id)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getOrderDetails(orderId: Int) -> Endpoint<BaseResponse<OrderDetailsData>> {
        return .init(
            method: .get,
            path: "Order/GetOrderDetails/\(orderId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func markPreparedByProvider(orderId: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Order/MarkPreparedByProvider/\(orderId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func confirmHandoverByProvider(orderId: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Order/ConfirmHandoverByProvider/\(orderId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func confirmReturnByProvider(orderId: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Order/ConfirmReturnByProvider/\(orderId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }
    
    static func getAboutUs() -> Endpoint<BaseResponse<AboutUsData>> {
        return .init(
            method: .get,
            path: "More/AboutUs",
        )
    }

    static func getTermsAndConditions() -> Endpoint<BaseResponse<TermsAndConditionsData>> {
        return .init(
            method: .get,
            path: "More/TermsAndConditions",
        )
    }

    static func getCancellationTerms() -> Endpoint<BaseResponse<CancellationTermsData>> {
        return .init(
            method: .get,
            path: "More/ConditionsForCancellationAndDelay",
        )
    }

    static func getHowItWorks() -> Endpoint<BaseResponse<HowItWorksData>> {
        return .init(
            method: .get,
            path: "More/HowItWorks",
        )
    }

    static func getContactInfo() -> Endpoint<BaseResponse<ContactInfoData>> {
        return .init(
            method: .get,
            path: "More/ContactInfo",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func submitContactUs(message: String, name: String? = nil, phone: String? = nil, countryCode: String? = nil) -> Endpoint<BaseResponse<Int>> {
        var body: [String: Any] = ["message": message]
        if let name = name { body["fullName"] = name }
        if let phone = phone { body["phoneNumber"] = phone }
        if let countryCode = countryCode { body["phoneCode"] = countryCode }
        return .init(
            method: .post,
            path: "More/CreateContactUs",
            body: body,
            headerType:  UserDefaults.accessToken != nil ? .authorized(token: UserDefaults.accessToken ?? "") : .unauthorized

        )
    }

    static func getAllComplaints() -> Endpoint<BaseResponse<[ComplaintItem]>> {
        return .init(
            method: .get,
            path: "More/GetAllComplaints",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getComplaintById(id: Int) -> Endpoint<BaseResponse<ComplaintDetailData>> {
        return .init(
            method: .get,
            path: "More/GetComplaintById/\(id)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func createComplaint(title: String, message: String, image: UploadData?) -> Endpoint<BaseResponse<Int>> {
        let bodyParams: APIParameters = [
            "Title": title,
            "Message": message
        ]

        var uploads: [UploadData]? = nil
        if let image = image {
            uploads = [image]
        }

        return .init(
            method: .post,
            path: "More/CreateComplaint",
            body: bodyParams,
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            uploads: uploads,
            encoding: .formData
        )
    }

    static func editAd(
        id: Int,
        description: String,
        safetyInstructions: String?,
        pricePerDay: Double,
        insuranceValue: Double,
        isDeliveryEnabled: Bool,
        minKilometersUsage: String?,
        maxKilometersUsage: String?,
        extraKilometerPrice: String?,
        additionalFeatureIds: [Int],
        images: [UploadData]
    ) -> Endpoint<BaseResponse<EditAdResponseData>> {
        var bodyParams: APIParameters = [
            "Id": id,
            "Description": description,
            "PricePerDay": pricePerDay,
            "InsuranceValue": insuranceValue,
            "IsDeliveryToRenterLocationEnabled": isDeliveryEnabled
        ]

        if let safetyInstructions = safetyInstructions, !safetyInstructions.isEmpty {
            bodyParams["SafetyInstructions"] = safetyInstructions
        }

        if let minKm = minKilometersUsage, !minKm.isEmpty {
            bodyParams["MinKilometersUsage"] = minKm
        }

        if let maxKm = maxKilometersUsage, !maxKm.isEmpty {
            bodyParams["MaxKilometersUsage"] = maxKm
        }

        if let extraKmPrice = extraKilometerPrice, !extraKmPrice.isEmpty {
            bodyParams["ExtraKilometerPrice"] = extraKmPrice
        }

        for (index, featureId) in additionalFeatureIds.enumerated() {
            bodyParams["AdditionalFeatureIds[\(index)]"] = featureId
        }

        for index in 0..<images.count {
            bodyParams["Images[\(index)].IsMainImage"] = (index == 0)
        }

        return .init(
            method: .put,
            path: "Advertisement/Edit",
            body: bodyParams,
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            uploads: images.isEmpty ? nil : images,
            encoding: .formData
        )
    }

    static func getAllReportIncidents() -> Endpoint<BaseResponse<[ReportItem]>> {
        return .init(
            method: .get,
            path: "Order/GetAllReportIncident",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getReportIncidentDetails(reportId: Int) -> Endpoint<BaseResponse<ReportDetailData>> {
        return .init(
            method: .get,
            path: "Order/GetReportIncidentDetails/\(reportId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    // MARK: - Wallet
    static func getWalletAmount() -> Endpoint<BaseResponse<Double>> {
        return .init(
            method: .get,
            path: "More/GetWalletAmount",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func chargeWallet(amount: Double, paymentMethod: Int = 1) -> Endpoint<BaseResponse<PayOrderData>> {
        return .init(
            method: .post,
            path: "More/ChargeWallet",
            queries: ["checkout": "sdk"],
            body: ["amount": amount, "paymentMethod": paymentMethod],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func createWalletWithdrawRequest(
        amount: Double,
        iban: String,
        accountName: String,
        accountNumber: String,
        bankName: String
    ) -> Endpoint<BaseResponse<Int>> {
        return .init(
            method: .post,
            path: "More/CreateWalletWithdrawRequest",
            body: [
                "amount": amount,
                "iban": iban,
                "accountName": accountName,
                "accountNumber": accountNumber,
                "bankName": bankName
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }
}
