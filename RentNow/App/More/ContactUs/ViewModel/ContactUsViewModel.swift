//
//  ContactUsViewModel.swift
//  RentNow
//

import Foundation
import Combine
@MainActor
class ContactUsViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var message: String = ""
    @Published var messageError: String? = nil
    @Published var contactInfo: ContactInfoData? = nil

    // MARK: - Visitor Properties
    @Published var fullName: String = ""
    @Published var fullNameError: String? = nil
    @Published var phoneNumber: String = ""
    @Published var phoneError: String? = nil
    @Published var hasEditedPhone: Bool = false
    @Published var countryCode: Country? = nil
    @Published var countriesArray: [Country] = []

    var isVisitor: Bool {
        UserDefaults.isVisitor
    }

    // MARK: - Callbacks
    var onSuccess: (() -> Void)?

    override init(responseHandler: any ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        if UserDefaults.isVisitor {
            getCountries()
        }
    }

    // MARK: - API Calls
    func fetchContactInfo() async {
        let endpoint = MoreEndpoint.getContactInfo()
        do {
            let response = try await request(endpoint)
            contactInfo = response
        } catch {
            showError(error.localizedDescription)
        }
    }

    func getCountries() {
        Task {
            let endPoint = AuthEndpoint.registrationFormData()
            do {
                let response = try await requestFullResponse(endPoint)
                guard let data = response.data else { return }
                await MainActor.run {
                    self.countriesArray = data.toCountries()
                    if let defaultCountry = self.countriesArray.first(where: { $0.key == "+966" }) ?? self.countriesArray.first {
                        self.countryCode = defaultCountry
                    }
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
        }
    }

    func submitMessage() {
        var hasError = false

        // Validate visitor fields synchronously
        if isVisitor {
            if fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                fullNameError = "This field is required".localized
                hasError = true
            } else {
                fullNameError = nil
            }

            if phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                hasEditedPhone = true
                phoneError = "This field is required".localized
                hasError = true
            } else {
                phoneError = nil
            }
        }

        // Validate message for all users
        do {
            let _ = try GeneralValidationService.validate(message: message)
            messageError = nil
        } catch {
            messageError = error.localizedDescription
            hasError = true
        }

        if hasError { return }

        Task {
            showIndicator()
            let endpoint: Endpoint<BaseResponse<Int>>
            if isVisitor {
                let countryCodeKey = PhoneTextView.getCountryCodeOrDefault(countryCode)
                endpoint = MoreEndpoint.submitContactUs(
                    message: message,
                    name: fullName,
                    phone: phoneNumber,
                    countryCode: countryCodeKey
                )
            } else {
                endpoint = MoreEndpoint.submitContactUs(message: message)
            }
            do {
                let _ = try await request(endpoint)
                onSuccess?()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
