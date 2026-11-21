import Foundation

// Standalone fixture checks: bash Tests/run-payment-contract-tests.sh
// Only this localization shim is needed to compile the app's models outside UIKit.
extension String {
    var localized: String { self }
}

@main
struct PaymentsContractTests {
    static func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
        try JSONDecoder().decode(type, from: Data(json.utf8))
    }

    static func main() throws {
        let suiteName = "rentnow.payment-attempt-test." + UUID().uuidString
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let attempt = MoyasarAttemptStore(attemptId: "ABC-123", defaults: defaults)
        let reopened = MoyasarAttemptStore(attemptId: "abc-123", defaults: defaults)
        let other = MoyasarAttemptStore(attemptId: "other", defaults: defaults)
        precondition(!attempt.hasSubmitted && !reopened.hasSubmitted)
        attempt.markSubmitted()
        precondition(reopened.hasSubmitted && !other.hasSubmitted)
        reopened.clear()
        precondition(!attempt.hasSubmitted)
        // Markers persisted by older versions must still be treated as ambiguous submissions.
        defaults.set(true, forKey: "moyasar.pending.abc-123")
        precondition(attempt.hasSubmitted)
        // Regression: the booking picker returns AM/PM text, not an API time.
        for (time, expected) in [
            ("12:06 PM", "12:06:00"), ("12:06 AM", "00:06:00"),
            ("01:06 PM", "13:06:00"), ("11:59 PM", "23:59:00"),
            ("09:05 AM", "09:05:00"), ("00:06", "00:06:00"), ("13:06", "13:06:00")
        ] {
            let dates = BookingDateFormatter.dateTimes(from: "2026-10-11", to: "2026-10-12", time: time)
            precondition(dates?.from == "2026-10-11T\(expected)")
            precondition(dates?.to == "2026-10-12T\(expected)")
        }
        precondition(BookingDateFormatter.dateTimes(from: "2026-10-11", to: "2026-10-11", time: "12:06 PM") != nil)
        precondition(BookingDateFormatter.dateTimes(from: "2026-10-12", to: "2026-10-11", time: "12:06 PM") == nil)
        precondition(BookingDateFormatter.dateTimes(from: "2026-02-30", to: "2026-03-01", time: "12:06 PM") == nil)
        for time in ["", "25:00", "13:00 PM", "12:60 PM"] {
            precondition(BookingDateFormatter.dateTimes(from: "2026-10-11", to: "2026-10-12", time: time) == nil)
        }

        let lookupMethods = try decode([OrderPaymentMethod].self, #"[{"value":"1","text":"أونلاين","disabled":false},{"value":"4","text":"تابي","disabled":true},{"value":"3","text":"Package"},{"value":"invalid","text":"Invalid"},{"value":null}]"#)
        let lookupOptions = OrderPaymentOption.selectableOptions(lookupMethods.compactMap(\.paymentOption))
        precondition(lookupOptions.compactMap(\.id) == [1, 4])
        precondition(lookupOptions.first?.name == "أونلاين")
        precondition(OrderPaymentOption.validSelection(1, in: lookupOptions) == 1)
        precondition(OrderPaymentOption.validSelection(4, in: lookupOptions) == nil)
        precondition(OrderPaymentOption.validSelection(3, in: lookupOptions) == nil)

        let summaryResponse = try decode(BaseResponse<OrderPaymentSummary>.self, #"""
        {
          "data": {
            "appFeesAmount": 75, "currency": "SAR", "deliveryCost": 0,
            "discountAmount": null, "featuresCost": 0, "insuranceValue": 300, "numberOfDays": 1,
            "paymentMethods": [
              {"disabled": false, "group": null, "selected": false, "text": "أونلاين", "value": "1"},
              {"disabled": false, "group": null, "selected": false, "text": "تابي", "value": "4"},
              {"disabled": false, "group": null, "selected": false, "text": "تمارا", "value": "2"}
            ],
            "paymentOptions": [
              {"amount": 961.25, "currency": "SAR", "id": 1, "instalmentAmount": null, "instalmentsCount": null, "isAvailable": true, "name": "أونلاين", "provider": "moyasar", "rejectionReason": null, "unavailableReason": null, "unavailableReasonKey": null},
              {"amount": 961.25, "currency": "SAR", "id": 4, "instalmentAmount": 240.31, "instalmentsCount": 4, "isAvailable": true, "name": "تابي", "provider": "tabby", "rejectionReason": null, "unavailableReason": null, "unavailableReasonKey": null},
              {"amount": 961.25, "currency": "SAR", "id": 2, "instalmentAmount": 320.42000000000002, "instalmentsCount": 3, "isAvailable": true, "name": "تمارا", "provider": "tamara", "rejectionReason": null, "unavailableReason": null, "unavailableReasonKey": null}
            ],
            "pricePerDay": 500, "rentalCost": 500, "returnPickupCost": 0,
            "totalPrice": 961.25, "totalPriceBeforeVat": 575, "vatPercentege": 15, "vatValue": 86.25
          },
          "isSuccess": true, "key": "success", "message": "OrderPaymentSummaryCalculatedSuccessfully",
          "statusCode": 200, "traceId": "4000071a-0000-b200-b63f-84710c7967bb"
        }
        """#)
        precondition(summaryResponse.isSuccess == true && summaryResponse.statusCode == 200)
        precondition(summaryResponse.traceId == "4000071a-0000-b200-b63f-84710c7967bb")
        let actualSummary = summaryResponse.data!
        precondition(actualSummary.total == 961.25 && actualSummary.totalBeforeVat == 575)
        precondition(actualSummary.vatValue == 86.25 && actualSummary.vatPercentege == 15)
        precondition(actualSummary.pricePerDay == 500 && actualSummary.rentalCost == 500 && actualSummary.numberOfDays == 1)
        precondition(actualSummary.appFeesAmount == 75 && actualSummary.insuranceValue == 300)
        precondition(actualSummary.deliveryCost == 0 && actualSummary.returnPickupCost == 0 && actualSummary.featuresCost == 0)
        precondition(actualSummary.discountAmount == nil && actualSummary.currency == "SAR")
        precondition(actualSummary.paymentMethods?.compactMap(\.value) == ["1", "4", "2"])
        let actualOptions = actualSummary.paymentOptions!
        precondition(actualOptions.compactMap(\.provider) == [.moyasar, .tabby, .tamara])
        precondition(actualOptions.allSatisfy { $0.amount == 961.25 && $0.currency == "SAR" && $0.isAvailable == true })
        precondition(actualOptions[0].instalmentAmount == nil && actualOptions[0].instalmentsCount == nil)
        precondition(actualOptions[1].instalmentAmount == 240.31 && actualOptions[1].instalmentsCount == 4)
        precondition(abs((actualOptions[2].instalmentAmount ?? 0) - 320.42) < 0.000001 && actualOptions[2].instalmentsCount == 3)
        let legacyOnlySummary = try decode(OrderPaymentSummary.self, #"{"paymentMethods":[{"value":"4","text":"Tabby"}]}"#)
        precondition(legacyOnlySummary.paymentMethods?.count == 1)
        precondition(OrderPaymentOption.selectableOptions(legacyOnlySummary.paymentOptions).isEmpty)

        // GetOrderPageData/51: integer prices decode as Double; nullable fields stay safe.
        let bookingPage = try decode(BaseResponse<OrderPageData>.self, #"""
        {
          "data": {
            "adDetails": {
              "city": "الرياض", "fuel": "Electric", "fuelName": "كهرباء",
              "geoAddress": "الورود, الرياض, محافظة الرياض, منطقة الرياض, 12215, السعودية",
              "id": 51, "isDeliveryToRenterLocationEnabled": true,
              "isReceivedFromRenterLocationEnabled": false,
              "latitude": 24.724942578678249, "longitude": 46.673991121351719,
              "mainImage": "https://dashboard.rentnow-app.com/Uploads/Images/Advertisements/52d45b9a4f97410caeecb16faf410c72.jpeg",
              "name": "تويوتا كورولا", "pricePerDay": 500
            },
            "additionalFeatures": [], "appFees": 15, "insuranceValue": 300,
            "cancellationAndDelayTerms": "يُفضّل طلب الإلغاء أو التعديل قبل تأكيد الحجز من الإدارة. بعد الموافقة، تُطبَّق سياسات الإلغاء والتأخير المعروضة في التطبيق وأي رسوم مستحقة وفق الشروط المعتمدة.\n",
            "paymentMethods": [
              {"disabled": false, "group": null, "selected": false, "text": "أونلاين", "value": "1"},
              {"disabled": false, "group": null, "selected": false, "text": "تابي", "value": "4"},
              {"disabled": false, "group": null, "selected": false, "text": "تمارا", "value": "2"}
            ],
            "paymentOptions": [
              {"amount": null, "currency": "SAR", "id": 1, "instalmentAmount": null, "instalmentsCount": null, "isAvailable": true, "name": "أونلاين", "provider": "moyasar", "rejectionReason": null, "unavailableReason": null, "unavailableReasonKey": null},
              {"amount": null, "currency": "SAR", "id": 4, "instalmentAmount": null, "instalmentsCount": null, "isAvailable": true, "name": "تابي", "provider": "tabby", "rejectionReason": null, "unavailableReason": null, "unavailableReasonKey": null},
              {"amount": null, "currency": "SAR", "id": 2, "instalmentAmount": null, "instalmentsCount": null, "isAvailable": true, "name": "تمارا", "provider": "tamara", "rejectionReason": null, "unavailableReason": null, "unavailableReasonKey": null}
            ],
            "rentalPolicy": {"extraKilometerPrice": 50, "insuranceValue": 300, "maxKilometesUsage": 900, "minKilometesUsage": 200},
            "userPackage": null
          },
          "isSuccess": true, "key": "success", "message": "تم تحميل بيانات صفحة الطلب بنجاح",
          "statusCode": 200, "traceId": "40002bff-0000-ce00-b63f-84710c7967bb"
        }
        """#)
        precondition(bookingPage.isSuccess == true && bookingPage.statusCode == 200)
        precondition(bookingPage.traceId == "40002bff-0000-ce00-b63f-84710c7967bb")
        let bookingData = bookingPage.data!
        precondition(bookingData.adDetails?.id == 51 && bookingData.adDetails?.pricePerDay == 500)
        precondition(bookingData.adDetails?.fuel == "Electric" && bookingData.adDetails?.fuelName == "كهرباء")
        precondition(bookingData.adDetails?.geoAddress == "الورود, الرياض, محافظة الرياض, منطقة الرياض, 12215, السعودية")
        precondition(bookingData.adDetails?.isDeliveryToRenterLocationEnabled == true)
        precondition(bookingData.adDetails?.isReceivedFromRenterLocationEnabled == false)
        precondition(bookingData.paymentMethods?.compactMap(\.value) == ["1", "4", "2"])
        precondition(bookingData.paymentMethods?.first?.group == nil)
        precondition(bookingData.paymentOptions?.compactMap(\.provider) == [.moyasar, .tabby, .tamara])
        precondition(bookingData.paymentOptions?.allSatisfy { $0.isAvailable == true && $0.amount == nil && $0.instalmentAmount == nil && $0.instalmentsCount == nil && $0.rejectionReason == nil } == true)
        precondition(bookingData.additionalFeatures?.isEmpty == true && bookingData.userPackage == nil)
        precondition(bookingData.appFees == 15 && bookingData.insuranceValue == 300)
        precondition(bookingData.rentalPolicy?.minKilometesUsage == 200 && bookingData.rentalPolicy?.maxKilometesUsage == 900)
        precondition(bookingData.rentalPolicy?.extraKilometerPrice == 50 && bookingData.rentalPolicy?.insuranceValue == 300)
        let booking = OrderBookingRequest(
            advertisementId: 12, dateFrom: "2026-10-08T10:30:00", dateTo: "2026-10-10T10:30:00",
            additionalFeatureIds: [2, 7], paymentMethod: 4, deliveryMethod: 2,
            deliveryLatitude: 24.7, deliveryLongitude: 46.6, deliveryAirportId: 8,
            deliveryNotes: "عند المدخل", returnPickupMethod: 2,
            returnPickupLatitude: 24.8, returnPickupLongitude: 46.7, returnPickupAirportId: 9,
            returnPickupNotes: "Call on arrival"
        )
        let body = booking.parameters.compactMapValues { $0 }
        precondition(body["DateFrom"] as? String == "2026-10-08T10:30:00")
        precondition(body["DateTo"] as? String == "2026-10-10T10:30:00")
        precondition(body["PaymentMethod"] as? Int == 4)
        precondition(body["DeliveryMethod"] as? Int == 2)
        precondition(body["ReturnPickupMethod"] as? Int == 2)
        precondition(body["startTime"] == nil && body["StartTime"] == nil)
        precondition(body["DeliveryNotes"] as? String == "عند المدخل")
        precondition(body["ReturnPickupNotes"] as? String == "Call on arrival")
        precondition(body["AdditionalFeatureIds"] as? [Int] == [2, 7])
        precondition(body["DeliveryAirportId"] as? Int == 8 && body["ReturnPickupAirportId"] as? Int == 9)
        precondition(!body.keys.contains(where: { $0.lowercased().contains("amount") || $0.lowercased().contains("price") }))
        _ = try JSONSerialization.data(withJSONObject: body)
        func pickupRequest() -> OrderBookingRequest {
            OrderBookingRequest(
                advertisementId: 1, dateFrom: "2026-12-15T10:00:00", dateTo: "2026-12-17T10:00:00",
                additionalFeatureIds: [], paymentMethod: 4, deliveryMethod: 1,
                deliveryLatitude: nil, deliveryLongitude: nil, deliveryAirportId: nil, deliveryNotes: nil,
                returnPickupMethod: 1, returnPickupLatitude: nil, returnPickupLongitude: nil,
                returnPickupAirportId: nil, returnPickupNotes: nil
            )
        }
        let pickupBody = pickupRequest().parameters.compactMapValues { $0 }
        let encodedPickup = try JSONSerialization.data(withJSONObject: pickupBody)
        let wireBody = try JSONSerialization.jsonObject(with: encodedPickup) as! [String: Any]
        precondition(wireBody["AdvertisementId"] as? Int == 1)
        precondition(wireBody["DateFrom"] as? String == "2026-12-15T10:00:00")
        precondition(wireBody["DateTo"] as? String == "2026-12-17T10:00:00")
        precondition(wireBody["AdditionalFeatureIds"] as? [Int] == [])
        precondition(wireBody["PaymentMethod"] as? Int == 4 && wireBody["DeliveryMethod"] as? Int == 1)
        for key in ["DeliveryLatitude", "DeliveryLongitude", "DeliveryAirportId"] {
            precondition(wireBody[key] is NSNull)
        }


        let refusal = "نأسف، تابي غير قادرة على الموافقة على هذه العملية. الرجاء استخدام طريقة دفع أخرى."
        for reason in ["not_available", "InstallmentAmountTooLow", "InstallmentAmountTooHigh"] {
            let data = try JSONSerialization.data(withJSONObject: ["paymentOptions": [
                ["id": 4, "provider": "tabby", "isAvailable": false, "rejectionReason": reason, "unavailableReason": refusal],
                ["id": 1, "provider": "moyasar", "isAvailable": true],
                ["id": 3, "isAvailable": true], ["id": 99, "isAvailable": true]
            ]])
            let summary = try JSONDecoder().decode(OrderPaymentSummary.self, from: data)
            let options = OrderPaymentOption.selectableOptions(summary.paymentOptions)
            precondition(summary.paymentOptions?.first?.rejectionReason == reason)
            precondition(options.first?.unavailableReason == refusal)
            precondition(options.map(\.id) == [4, 1])
            precondition(OrderPaymentOption.validSelection(4, in: options) == nil)
            precondition(OrderPaymentOption.validSelection(1, in: options) == 1)
        }
        let page = try decode(OrderPageData.self, #"{"paymentMethods":[{"value":"1","text":"Electronic payment"}],"paymentOptions":[{"id":4,"provider":"tabby","name":"Tabby","isAvailable":true,"amount":null,"currency":"SAR","instalmentsCount":null,"instalmentAmount":null}]}"#)
        precondition(page.paymentOptions?.first?.provider == .tabby)
        precondition(page.paymentOptions?.first?.amount == nil)
        precondition(page.paymentOptions?.first?.instalmentAmount == nil)

        let summary = try decode(OrderPaymentSummary.self, #"{"totalPrice":1150,"currency":"SAR","paymentMethods":[{"value":"4","text":"Tabby"}],"paymentOptions":[{"id":4,"provider":"tabby","isAvailable":true,"amount":1150,"instalmentsCount":4,"instalmentAmount":287.5},{"id":2,"provider":"tamara","isAvailable":false,"unavailableReasonKey":"InstallmentAmountTooHigh","unavailableReason":"Amount exceeds the limit"}]}"#)
        precondition(summary.total == 1150 && summary.currency == "SAR")
        precondition(summary.paymentOptions?.first?.instalmentAmount == 287.5)
        precondition(summary.paymentOptions?.last?.isAvailable == false)
        precondition(summary.paymentOptions?.last?.unavailableReason == "Amount exceeds the limit")

        let choices = OrderPaymentOption.selectableOptions(summary.paymentOptions)
        precondition(choices.map(\.id) == [4, 2])
        precondition(choices.first?.instalmentAmount == 287.5)
        precondition(OrderPaymentOption.validSelection(4, in: choices) == 4)
        precondition(OrderPaymentOption.validSelection(2, in: choices) == nil)
        precondition(OrderPaymentOption.validSelection(1, in: choices) == nil)
        precondition(OrderPaymentOption.validSelection(nil, in: choices) == nil)
        let emptyChoices = OrderPaymentOption.selectableOptions([])
        precondition(emptyChoices.isEmpty, "An empty server list must not restore legacy methods")
        precondition(OrderPaymentOption.selectableOptions(nil).isEmpty)
        let duplicates = try decode([OrderPaymentOption].self, #"[{"id":4,"isAvailable":true},{"id":4,"isAvailable":true},{"id":3,"isAvailable":true},{}]"#)
        precondition(OrderPaymentOption.selectableOptions(duplicates).count == 1)
        let changed = try decode(OrderPaymentSummary.self, #"{"paymentOptions":[{"id":4,"isAvailable":false,"unavailableReason":"Amount too high"}]}"#)
        let changedChoices = OrderPaymentOption.selectableOptions(changed.paymentOptions)
        precondition(OrderPaymentOption.validSelection(4, in: changedChoices) == nil)
        precondition(changedChoices.first?.unavailableReason == "Amount too high")
        let explicitEmptyPage = try decode(OrderPageData.self, #"{"paymentOptions":[]}"#)
        precondition(explicitEmptyPage.paymentOptions?.isEmpty == true)
        let unknownAvailability = try decode(OrderPaymentOption.self, #"{"id":4,"name":"Tabby"}"#)
        let unknownChoices = OrderPaymentOption.selectableOptions([unknownAvailability])
        precondition(unknownChoices.first?.isAvailable == nil)
        precondition(OrderPaymentOption.validSelection(4, in: unknownChoices) == nil)
        let legacyOnlyPage = try decode(OrderPageData.self, #"{"paymentMethods":[{"value":"4","text":"Tabby"}]}"#)
        precondition(OrderPaymentOption.selectableOptions(legacyOnlyPage.paymentOptions).isEmpty)

        let tabby = try decode(PayOrderData.self, #"{"provider":"tabby","paymentMethodId":4,"transactionId":"812","paymentUrl":null,"amount":1150,"currency":"SAR","expiresAt":"2026-10-01T13:45:00Z","paymentStatus":"Pending","tabby":{"status":"created","paymentId":"p1","sessionId":"s1","webUrl":"https://checkout.tabby.ai/session"},"tamara":null}"#)
        precondition(tabby.provider == .tabby && tabby.paymentMethodId == 4)
        precondition(tabby.transactionId == "812" && tabby.paymentUrl == nil)
        precondition(tabby.paymentStatus == .pending && tabby.tabby?.status == "created")
        precondition(tabby.tabby?.webUrl == "https://checkout.tabby.ai/session")
        precondition(tabby.expiresAt == "2026-10-01T13:45:00Z" && tabby.tamara == nil)

        // PayOrder/173 response: preserve nulls and use the nested checkout URL.
        let payOrderResponse = try decode(BaseResponse<PayOrderData>.self, #"""
        {
          "data": {
            "amount": 961.25, "currency": "SAR",
            "expiresAt": "2026-10-10T18:43:21.744984Z",
            "isPackagePayment": false,
            "message": "أكمل عملية الدفع لدى مزود التقسيط",
            "paymentMethodId": 4, "paymentStatus": "Pending",
            "paymentStatusText": "بانتظار الدفع", "paymentUrl": null,
            "provider": "tabby",
            "tabby": {
              "paymentId": "01a12704-fde8-8e25-831b-8f8d67a7bf5b",
              "rejectionMessage": null, "rejectionReason": null,
              "sessionId": "01a12704-fde8-864e-8c1a-269064be906f",
              "status": "created",
              "webUrl": "https://checkout.tabby.sa/?apiKey=pk_test_fixture&lang=ara&merchantCode=rentnow&product=installments&sessionId=01a12704-fde8-864e-8c1a-269064be906f"
            },
            "tamara": null, "transactionId": "43"
          },
          "isSuccess": true, "key": "success",
          "message": "أكمل عملية الدفع لدى مزود التقسيط",
          "statusCode": 200, "traceId": "4000602c-0002-cc00-b63f-84710c7967bb"
        }
        """#)
        let payOrder = payOrderResponse.data!
        precondition(payOrderResponse.isSuccess == true && payOrderResponse.statusCode == 200)
        precondition(payOrderResponse.key == .success && payOrderResponse.traceId == "4000602c-0002-cc00-b63f-84710c7967bb")
        precondition(payOrder.amount == 961.25 && payOrder.currency == "SAR")
        precondition(payOrder.expiresAt == "2026-10-10T18:43:21.744984Z")
        precondition(payOrder.isPackagePayment == false && payOrder.paymentMethodId == 4)
        precondition(payOrder.message == payOrderResponse.message)
        precondition(payOrder.paymentStatus == .pending && payOrder.paymentStatusText == "بانتظار الدفع")
        precondition(payOrder.paymentUrl == nil && payOrder.tamara == nil)
        precondition(payOrder.provider == .tabby && payOrder.transactionId == "43")
        precondition(payOrder.tabby?.paymentId == "01a12704-fde8-8e25-831b-8f8d67a7bf5b")
        precondition(payOrder.tabby?.sessionId == "01a12704-fde8-864e-8c1a-269064be906f")
        precondition(payOrder.tabby?.status == "created")
        precondition(payOrder.tabby?.rejectionMessage == nil && payOrder.tabby?.rejectionReason == nil)
        let checkoutSession = PaymentSession(tabbyPayment: payOrder, orderId: 173)
        precondition(checkoutSession?.paymentURL?.absoluteString == payOrder.tabby?.webUrl)
        precondition(checkoutSession?.transactionId == "43" && checkoutSession?.orderId == 173)

        let rejection = try decode(BaseResponse<PayOrderData>.self, #"{"isSuccess":true,"statusCode":200,"key":"success","message":"","traceId":"trace-1","data":{"provider":"tabby","transactionId":812,"paymentStatus":"Rejected","message":"Please use another payment method","tabby":{"status":"rejected","rejectionReason":"not_available","rejectionMessage":"Provider rejection text","webUrl":null}}}"#)
        precondition(rejection.isSuccess == true && rejection.statusCode == 200)
        precondition(rejection.traceId == "trace-1" && rejection.key == .success)
        precondition(rejection.data?.transactionId == "812")
        precondition(rejection.data?.paymentStatus == .rejected)
        precondition(rejection.data?.message == "Please use another payment method")
        precondition(rejection.data?.tabby?.webUrl == nil)
        precondition(rejection.data?.tabby?.rejectionMessage == "Provider rejection text")

        let tamara = try decode(PayOrderData.self, #"{"provider":"tamara","transactionId":"813","paymentStatus":"Pending","tamara":{"isEligible":true,"checkoutUrl":"https://checkout.tamara.co/session","orderId":"o1","checkoutId":"c1","successUrl":"https://example.com/Payment/Success?transactionId=813","failureUrl":"https://example.com/Payment/Failed?transactionId=813","cancelUrl":"https://example.com/Payment/Failed?transactionId=813&cancelled=true"}}"#)
        precondition(tamara.tamara?.isEligible == true && tamara.tabby == nil)
        precondition(tamara.tamara?.checkoutId == "c1")
        precondition(tamara.tamara?.cancelUrl == "https://example.com/Payment/Failed?transactionId=813&cancelled=true")
        let ineligible = try decode(PayOrderData.self, #"{"provider":"tamara","paymentStatus":"Rejected","tamara":{"isEligible":false,"checkoutUrl":null,"rejectionMessage":"Not eligible"}}"#)
        precondition(ineligible.tamara?.isEligible == false && ineligible.tamara?.checkoutUrl == nil)
        precondition(PaymentSession(tamaraPayment: ineligible, orderId: 120) == nil)
        let tamaraSession = PaymentSession(tamaraPayment: tamara, orderId: 120)!
        precondition(tamaraSession.provider == .tamara && !tamaraSession.isTabby)
        precondition(tamaraSession.kind == .order && tamaraSession.orderId == 120)
        precondition(tamaraSession.transactionId == "813")
        precondition(tamaraSession.paymentURL?.absoluteString == tamara.tamara?.checkoutUrl)
        precondition(tamaraSession.tamara == tamara.tamara)
        precondition(PaymentSession(tamaraPayment: tamara, orderId: 0) == nil)

        // Wallet charges reuse provider payloads without inventing a rental order ID.
        let walletTabby = PaymentSession(tabbyPayment: payOrder, kind: .wallet)!
        let walletTamara = PaymentSession(tamaraPayment: tamara, kind: .wallet)!
        precondition(walletTabby.kind == .wallet && walletTabby.orderId == nil)
        precondition(walletTamara.kind == .wallet && walletTamara.orderId == nil)
        precondition(walletTamara.tamara == tamara.tamara)
        precondition(PaymentSession(tamaraPayment: ineligible, kind: .wallet) == nil)
        precondition(PaymentSession(tabbyPayment: payOrder, orderId: 173, kind: .wallet) == nil)
        precondition(PaymentSession(tamaraPayment: tamara, kind: .order) == nil)
        let walletMoyasarPayment = try decode(PayOrderData.self, #"{"transactionId":"901","provider":"moyasar","moyasarPaymentAttemptId":"c1d4141d-620d-4ac1-83a0-f20a468819e2","amount":100,"currency":"SAR","paymentStatus":"Pending"}"#)
        let walletMoyasar = PaymentSession(moyasarPayment: walletMoyasarPayment, kind: .wallet)!
        for wallet in [walletTabby, walletTamara, walletMoyasar] {
            let json = "{\"transactionId\":\"\(wallet.transactionId)\",\"provider\":\"\(wallet.provider.rawValue)\",\"target\":\"Wallet\",\"paymentStatus\":\"Paid\"}"
            let status = try decode(OrderPaymentStatusData.self, json)
            precondition(wallet.matches(status))
            for invalid in [json.replacingOccurrences(of: "Wallet", with: "Order"),
                            json.replacingOccurrences(of: wallet.transactionId, with: "other-transaction"),
                            json.replacingOccurrences(of: wallet.provider.rawValue, with: "unknown")] {
                let mismatched = try decode(OrderPaymentStatusData.self, invalid)
                precondition(!wallet.matches(mismatched))
            }
        }
        let eligibility = try decode(BaseResponse<InstallmentEligibilityData>.self, """
        {"key":"success","isSuccess":true,"statusCode":200,"data":{"amount":100,"currency":"SAR","options":[
        {"id":4,"provider":"tabby","name":"تابي","isAvailable":false,"unavailableReasonKey":"TabbyRejected","unavailableReason":"\(refusal)","rejectionReason":"not_available","amount":100,"currency":"SAR","instalmentsCount":null,"instalmentAmount":null},
        {"id":2,"provider":"tamara","isAvailable":true,"instalmentsCount":3,"instalmentAmount":33.33}
        ]}}
        """)
        precondition(eligibility.data?.amount == 100 && eligibility.data?.currency == "SAR")
        precondition(eligibility.data?.options.first?.unavailableReason == refusal)
        precondition(OrderPaymentOption.validSelection(4, in: eligibility.data!.options) == nil)
        precondition(OrderPaymentOption.validSelection(2, in: eligibility.data!.options) == 2)
        let chargeError = try decode(BaseResponse<PayOrderData>.self, #"{"key":"error","isSuccess":false,"statusCode":400,"data":null,"message":"Provider rejected"}"#)
        precondition(chargeError.data == nil && chargeError.key == .error && chargeError.message == "Provider rejected")

        // Package initiation keeps legacy fields and decodes the shared provider payload.
        for payment in [payOrder, tamara] {
            var object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(payment)) as! [String: Any]
            object["subscriptionRequestId"] = 21
            object["paymentUrlExpiry"] = "2026-10-12T15:00:00Z"
            let response = try JSONDecoder().decode(SubscribeResponse.self, from: JSONSerialization.data(withJSONObject: object))
            precondition(response.subscriptionRequestId == 21)
            precondition(response.paymentUrlExpiry == "2026-10-12T15:00:00Z")
            let session = payment.provider == .tabby
                ? PaymentSession(tabbyPayment: response.payment, kind: .package)!
                : PaymentSession(tamaraPayment: response.payment, kind: .package)!
            precondition(session.kind == .package && session.orderId == nil)
            let statusJSON = "{\"transactionId\":\"\(session.transactionId)\",\"provider\":\"\(session.provider.rawValue)\",\"target\":\"Package\",\"paymentStatus\":\"Paid\"}"
            let paid = try decode(OrderPaymentStatusData.self, statusJSON)
            precondition(session.matches(paid))
            for invalid in [statusJSON.replacingOccurrences(of: "Package", with: "Wallet"),
                            statusJSON.replacingOccurrences(of: session.transactionId, with: "wrong-id"),
                            statusJSON.replacingOccurrences(of: session.provider.rawValue, with: "unknown")] {
                let status = try decode(OrderPaymentStatusData.self, invalid)
                precondition(!session.matches(status))
            }
        }
        let packageMoyasar = try decode(SubscribeResponse.self, #"{"subscriptionRequestId":22,"transactionId":900,"paymentUrl":null,"provider":"moyasar","moyasarPaymentAttemptId":"c1d4141d-620d-4ac1-83a0-f20a468819e2","amount":100,"currency":"SAR","paymentStatus":"Pending"}"#)
        precondition(packageMoyasar.transactionId == "900")
        let packageMoyasarSession = PaymentSession(moyasarPayment: packageMoyasar.payment, kind: .package)!
        let packageMoyasarStatus = try decode(OrderPaymentStatusData.self, #"{"transactionId":900,"provider":"moyasar","target":"Package","paymentStatus":"Paid"}"#)
        precondition(packageMoyasarSession.matches(packageMoyasarStatus))
        precondition(PaymentSession(tamaraPayment: ineligible, kind: .package) == nil)
        precondition(PaymentSession(tabbyPayment: payOrder, orderId: 173, kind: .package) == nil)
        let subscriptionRequestOnly = try decode(SubscribeResponse.self, #"{"subscriptionRequestId":23}"#)
        precondition(subscriptionRequestOnly.payment.paymentStatus != .paid)
        precondition(PaymentSession(moyasarPayment: subscriptionRequestOnly.payment, kind: .package) == nil)

        // Invalid or incomplete backend sessions must never reach the SDK.
        let tamaraJSON = try JSONEncoder().encode(tamara)
        let tamaraFixture = try JSONSerialization.jsonObject(with: tamaraJSON) as! [String: Any]
        var sandboxFixture = tamaraFixture
        var sandboxData = sandboxFixture["tamara"] as! [String: Any]
        sandboxData["checkoutUrl"] = "https://checkout-sandbox.tamara.co/checkout/session"
        sandboxFixture["tamara"] = sandboxData
        let sandboxPayment = try JSONDecoder().decode(PayOrderData.self, from: JSONSerialization.data(withJSONObject: sandboxFixture))
        precondition(PaymentSession(tamaraPayment: sandboxPayment, orderId: 120) != nil)
        for (key, value) in [("provider", "tabby"), ("transactionId", "  ")] {
            var fixture = tamaraFixture
            fixture[key] = value
            let payment = try JSONDecoder().decode(PayOrderData.self, from: JSONSerialization.data(withJSONObject: fixture))
            precondition(PaymentSession(tamaraPayment: payment, orderId: 120) == nil)
        }
        for (key, value) in [
            ("isEligible", false as Any),
            ("checkoutUrl", "https://checkout.tamara.co.evil.com/session"),
            ("checkoutUrl", "http://checkout.tamara.co/session"),
            ("checkoutUrl", "https://user:password@checkout.tamara.co/session"),
            ("checkoutUrl", "https://checkout.tamara.co:123/session"),
            ("successUrl", NSNull()),
            ("successUrl", ""),
            ("failureUrl", "not a URL"),
            ("cancelUrl", "http://example.com/cancel"),
            ("cancelUrl", tamara.tamara!.failureUrl!),
            ("orderId", ""),
            ("checkoutId", NSNull())
        ] {
            var fixture = tamaraFixture
            var providerData = fixture["tamara"] as! [String: Any]
            providerData[key] = value
            fixture["tamara"] = providerData
            let payment = try JSONDecoder().decode(PayOrderData.self, from: JSONSerialization.data(withJSONObject: fixture))
            precondition(PaymentSession(tamaraPayment: payment, orderId: 120) == nil)
        }
        for state in ["Paid", "Rejected", "Cancelled", "Expired", "NeedsReview", "Refunded", "Unknown"] {
            var fixture = tamaraFixture
            fixture["paymentStatus"] = state
            let payment = try JSONDecoder().decode(PayOrderData.self, from: JSONSerialization.data(withJSONObject: fixture))
            precondition(PaymentSession(tamaraPayment: payment, orderId: 120) == nil)
        }
        let tamaraStatus = try decode(OrderPaymentStatusData.self, #"{"transactionId":813,"provider":"tamara","target":"Order","orderId":120,"paymentStatus":"Paid"}"#)
        precondition(tamaraSession.matches(tamaraStatus))
        for json in [
            #"{"transactionId":813,"provider":"tabby","orderId":120,"paymentStatus":"Paid"}"#,
            #"{"transactionId":814,"provider":"tamara","orderId":120,"paymentStatus":"Paid"}"#,
            #"{"transactionId":813,"provider":"tamara","orderId":121,"paymentStatus":"Paid"}"#,
            #"{"transactionId":813,"provider":"tamara","target":"Wallet","targetId":120,"paymentStatus":"Paid"}"#,
            #"{"transactionId":813,"provider":"tamara","orderId":120,"targetId":121,"paymentStatus":"Paid"}"#,
            #"{"transactionId":813,"provider":"tamara","paymentStatus":"Paid"}"#
        ] {
            let status = try decode(OrderPaymentStatusData.self, json)
            precondition(!tamaraSession.matches(status))
        }

        let details = try decode(OrderDetailsData.self, #"{"paymentInfo":{"paymentMethod":"Tabby","paymentMethodId":4,"paymentProvider":"tabby","finalTotal":1150,"currency":"SAR","paymentStatus":"Pending","paymentStatusText":"Awaiting payment","lastPaymentTransactionId":812,"paymentRejectionReason":null,"canChangePaymentMethod":true,"total":1150}}"#)
        precondition(details.paymentInfo?.lastPaymentTransactionId == "812")
        precondition(details.paymentInfo?.canChangePaymentMethod == true)
        precondition(details.paymentInfo?.finalTotal == 1150)
        precondition(details.paymentInfo?.paymentStatusText == "Awaiting payment")

        let states: [(String, OrderPaymentStatus)] = [
            ("Unpaid", .unpaid), ("Pending", .pending), ("Paid", .paid),
            ("Rejected", .rejected), ("Cancelled", .cancelled), ("Expired", .expired),
            ("NeedsReview", .needsReview), ("Refunded", .refunded),
            ("paid", .paid), ("Canceled", .cancelled), ("FutureState", .unknown)
        ]
        for (value, expected) in states {
            let result = try decode(OrderPaymentStatusData.self, "{\"transactionId\":812,\"status\":\"Paid\",\"paymentStatus\":\"\(value)\",\"provider\":\"tabby\",\"target\":\"Order\",\"targetId\":120,\"orderId\":120}")
            precondition(result.transactionId == "812" && result.paymentStatus == expected)
            precondition(result.targetId == 120 && result.orderId == 120)
        }
        let future = try decode(OrderPaymentStatusData.self, #"{"provider":"future-provider","transactionId":"814"}"#)
        precondition(future.provider == .unknown && future.paymentStatus == nil)
        precondition(future.transactionId == "814")

        // Old Moyasar / package payloads and absent new fields must still decode.
        let legacy = try decode(BaseResponse<PayOrderData>.self, #"{"key":"success","message":"OK","data":{"paymentUrl":"https://checkout.moyasar.com/invoices/1","transactionId":"811"}}"#)
        precondition(legacy.data?.paymentUrl == "https://checkout.moyasar.com/invoices/1")
        precondition(legacy.data?.provider == nil && legacy.isSuccess == nil)
        // Hosted URL responses can decode, but cannot launch Moyasar checkout.
        precondition(PaymentSession(moyasarPayment: legacy.data!, kind: .wallet) == nil)
        let hostedMoyasar = try decode(PayOrderData.self, #"{"provider":"moyasar","paymentStatus":"Pending","transactionId":"811","paymentUrl":"https://checkout.moyasar.com/invoices/1"}"#)
        precondition(PaymentSession(moyasarPayment: hostedMoyasar, kind: .package) == nil)
        let package = try decode(PayOrderData.self, #"{"isPackagePayment":true}"#)
        precondition(package.isPackagePayment == true && package.paymentUrl == nil)
        let oldPage = try decode(OrderPageData.self, "{}")
        let oldSummary = try decode(OrderPaymentSummary.self, #"{"totalPrice":100}"#)
        precondition(oldPage.paymentOptions == nil)
        precondition(oldSummary.total == 100 && oldSummary.paymentOptions == nil)
        let missing = try decode(OrderPaymentStatusData.self, #"{"transactionId":null}"#)
        precondition(missing.transactionId == nil && missing.paymentStatus == nil)
        let failure = try decode(BaseResponse<PayOrderData>.self, #"{"isSuccess":false,"statusCode":400,"key":"fail","message":"Selected method is unavailable","data":null,"traceId":"failure-1"}"#)
        precondition(failure.isSuccess == false && failure.data == nil)
        precondition(failure.message == "Selected method is unavailable")

        // Invalid ID types must not silently become a usable transaction.
        for invalidID in ["true", "{}", "1.5"] {
            do {
                _ = try decode(OrderPaymentStatusData.self, "{\"transactionId\":\(invalidID)}")
                preconditionFailure("Accepted malformed transaction ID: \(invalidID)")
            } catch is DecodingError { }
        }
        // Checkout must use the backend-created Tabby session and reject other hosts/states.
        func checkout(_ url: String, provider: String = "tabby", state: String = "Pending", transaction: String = "812") throws -> PaymentSession? {
            let json = try JSONSerialization.data(withJSONObject: [
                "provider": provider, "transactionId": transaction, "paymentStatus": state,
                "tabby": ["status": "created", "webUrl": url]
            ])
            let payment = try JSONDecoder().decode(PayOrderData.self, from: json)
            return PaymentSession(tabbyPayment: payment, orderId: 120)
        }
        let session = try checkout("https://checkout.tabby.sa/session/123")!
        precondition(session.transactionId == "812" && session.orderId == 120)
        precondition(session.isTabby && session.kind == .order)
        let globalSession = try checkout("https://checkout.tabby.ai/session/123")
        precondition(globalSession != nil)
        for invalidURL in ["http://checkout.tabby.sa/123", "https://checkout.tabby.sa.evil.com/123", "https://evil.com/checkout.tabby.sa", "https://user:pass@checkout.tabby.sa/123", "https://checkout.tabby.sa:123/123", "not a URL"] {
            let invalid = try checkout(invalidURL)
            precondition(invalid == nil)
        }
        for state in ["Paid", "Rejected", "Cancelled", "Expired", "NeedsReview", "Refunded", "Unknown"] {
            let invalid = try checkout("https://checkout.tabby.sa/123", state: state)
            precondition(invalid == nil)
        }
        let wrongProvider = try checkout("https://checkout.tabby.sa/123", provider: "tamara")
        let emptyID = try checkout("https://checkout.tabby.sa/123", transaction: "  ")
        precondition(wrongProvider == nil && emptyID == nil)
        let matched = try decode(OrderPaymentStatusData.self, #"{"transactionId":812,"provider":"tabby","target":"Order","orderId":120,"paymentStatus":"Paid"}"#)
        precondition(session.matches(matched))
        for json in [
            #"{"transactionId":813,"provider":"tabby","orderId":120,"paymentStatus":"Paid"}"#,
            #"{"transactionId":812,"provider":"tabby","orderId":121,"paymentStatus":"Paid"}"#,
            #"{"transactionId":812,"provider":"tamara","orderId":120,"paymentStatus":"Paid"}"#,
            #"{"transactionId":812,"provider":"tabby","target":"Package","orderId":120,"paymentStatus":"Paid"}"#,
            #"{"transactionId":812,"provider":"tabby","orderId":120,"targetId":121,"paymentStatus":"Paid"}"#,
            #"{"transactionId":812,"provider":"tabby","paymentStatus":"Paid"}"#
        ] {
            let mismatched = try decode(OrderPaymentStatusData.self, json)
            precondition(!session.matches(mismatched))
        }
        let sdkResponse = try decode(PayOrderData.self, #"{"transactionId":"111","moyasarPaymentAttemptId":"c1d4141d-620d-4ac1-83a0-f20a468819e2","provider":"moyasar","amount":584.85000000000002,"currency":"SAR","paymentStatus":"Pending","paymentUrl":null}"#)
        let sdkSession = PaymentSession(moyasarPayment: sdkResponse, kind: .order, orderId: 185)!
        precondition(sdkSession.paymentURL == nil && sdkSession.moyasar?.amountHalalas == 58485)
        precondition(sdkSession.moyasar?.method == .card)
        let preferenceSuite = "rentnow.payment-tests.\(UUID().uuidString)"
        let preferenceDefaults = UserDefaults(suiteName: preferenceSuite)!
        defer { preferenceDefaults.removePersistentDomain(forName: preferenceSuite) }
        precondition(MoyasarPaymentPreference.get(orderId: 185, userId: "user-a", defaults: preferenceDefaults) == .card)
        MoyasarPaymentPreference.set(.applePay, orderId: 185, userId: "user-a", defaults: preferenceDefaults)
        precondition(MoyasarPaymentPreference.get(orderId: 185, userId: "user-a", defaults: preferenceDefaults) == .applePay)
        precondition(MoyasarPaymentPreference.get(orderId: 186, userId: "user-a", defaults: preferenceDefaults) == .card)
        precondition(MoyasarPaymentPreference.get(orderId: 185, userId: "user-b", defaults: preferenceDefaults) == .card)
        for kind in [PaymentKind.order, .exceededKilometers, .wallet, .package] {
            let id = kind == .order || kind == .exceededKilometers ? 185 : nil
            for method in [MoyasarPaymentMethod.card, .applePay] {
                let nativeSession = PaymentSession(moyasarPayment: sdkResponse, kind: kind, orderId: id, method: method)!
                precondition(nativeSession.moyasar?.method == method)
                precondition(nativeSession.paymentURL == nil)
                precondition(nativeSession.transactionId == "111" && nativeSession.kind == kind)
                precondition(nativeSession.orderId == id)
            }
        }
        precondition(sdkSession.moyasar?.attemptId == "c1d4141d-620d-4ac1-83a0-f20a468819e2")
        let sdkStatus = try decode(OrderPaymentStatusData.self, #"{"transactionId":111,"provider":"moyasar","target":"Order","targetId":185,"orderId":185,"paymentStatus":"Paid"}"#)
        precondition(sdkSession.matches(sdkStatus))
        let wrongTarget = try decode(OrderPaymentStatusData.self, #"{"transactionId":111,"provider":"moyasar","target":"Order","targetId":186,"paymentStatus":"Paid"}"#)
        precondition(!sdkSession.matches(wrongTarget))
        let kmSession = PaymentSession(moyasarPayment: sdkResponse, kind: .exceededKilometers, orderId: 185)!
        let kmStatus = try decode(OrderPaymentStatusData.self, #"{"transactionId":111,"provider":"moyasar","target":"ExceededKilometers","targetId":185,"paymentStatus":"Paid"}"#)
        precondition(kmSession.matches(kmStatus))
        precondition(MoyasarSDKPayment.halalas(Decimal(string: "584.85")!) == 58485)
        precondition(MoyasarSDKPayment.halalas(Decimal(string: "0.50")!) == nil)
        let subscription = try decode(SubscribeResponse.self, #"{"subscriptionRequestId":45,"transactionId":"112","moyasarPaymentAttemptId":"8e0a3b6f-0f0e-4f43-9b0a-2c1f5f1d7a90","provider":"moyasar","amount":299.00,"currency":"SAR","paymentStatus":"Pending","paymentUrl":null}"#)
        precondition(PaymentSession(moyasarPayment: subscription.payment, kind: .package)?.moyasar?.amountHalalas == 29900)
        let walletSession = PaymentSession(moyasarPayment: sdkResponse, kind: .wallet)!
        // The wallet SDK response has no hosted URL; it must still open native checkout.
        let walletResponse116 = try decode(BaseResponse<PayOrderData>.self, #"""
        {"data":{"amount":30,"currency":"SAR","expiresAt":"2026-11-06T10:46:57.1894599Z","isPackagePayment":false,"message":"Please complete payment","moyasarPaymentAttemptId":"16da2baa-2199-4237-b178-3f216e4aff35","paymentMethodId":null,"paymentStatus":"Pending","paymentStatusText":null,"paymentUrl":null,"provider":"moyasar","tabby":null,"tamara":null,"transactionId":"116"},"isSuccess":true,"key":"success","message":"يرجى إكمال عملية الدفع","statusCode":200}
        """#)
        let walletSession116 = PaymentSession(moyasarPayment: walletResponse116.data!, kind: .wallet)
        precondition(walletSession116?.paymentURL == nil && walletSession116?.transactionId == "116")
        precondition(walletSession116?.moyasar?.attemptId == "16da2baa-2199-4237-b178-3f216e4aff35")
        precondition(walletSession116?.moyasar?.amountHalalas == 3000)
        let walletResponse119 = try decode(PayOrderData.self, #"{"transactionId":"119","moyasarPaymentAttemptId":"6170f2d5-0f07-42b7-97b9-f524242bce8f","provider":"moyasar","amount":10,"currency":"SAR","paymentStatus":"Pending","paymentUrl":null}"#)
        let walletSession119 = PaymentSession(moyasarPayment: walletResponse119, kind: .wallet)!
        let walletPending119 = try decode(OrderPaymentStatusData.self, #"{"transactionId":119,"provider":"moyasar","target":"Wallet","targetId":0,"orderId":null,"paymentStatus":"Pending","status":"Initiated"}"#)
        precondition(walletSession119.matches(walletPending119))
        precondition(walletPending119.paymentStatus == .pending)
        let walletStatus = try decode(OrderPaymentStatusData.self, #"{"transactionId":111,"provider":"moyasar","target":"Wallet","paymentStatus":"Pending"}"#)
        let unrelatedStatus = try decode(OrderPaymentStatusData.self, #"{"transactionId":111,"provider":"moyasar","target":"Package","paymentStatus":"Paid"}"#)
        precondition(walletSession.matches(walletStatus) && !walletSession.matches(unrelatedStatus))
        for invalid in [
            #"{"transactionId":"111","moyasarPaymentAttemptId":"bad","provider":"moyasar","amount":584.85,"currency":"SAR","paymentStatus":"Pending"}"#,
            #"{"transactionId":"111","moyasarPaymentAttemptId":"c1d4141d-620d-4ac1-83a0-f20a468819e2","provider":"moyasar","amount":584.85,"currency":"USD","paymentStatus":"Pending"}"#,
            #"{"transactionId":"111","moyasarPaymentAttemptId":"c1d4141d-620d-4ac1-83a0-f20a468819e2","provider":"moyasar","amount":584.85,"currency":"SAR","paymentStatus":"Paid"}"#
        ] {
            let invalidPayment = try decode(PayOrderData.self, invalid)
            precondition(PaymentSession(moyasarPayment: invalidPayment, kind: .wallet) == nil)
        }
        print("Payment contract, Moyasar SDK, Tabby, and Tamara session fixtures passed")
    }
}
