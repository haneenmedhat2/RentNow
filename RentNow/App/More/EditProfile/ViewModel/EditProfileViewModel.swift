//
//  EditProfileViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class EditProfileViewModel: BaseViewModel {

    // MARK: - Form Fields
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var selectedCountry: EditProfileCountry?
    @Published var selectedCity: EditProfileCity?
    @Published var imageData: Data?
    @Published var mediaItems: [MediaItem] = []
    @Published var currentImageUrl: String?

    // MARK: - Data
    @Published var countries: [EditProfileCountry] = []
    @Published var filteredCities: [EditProfileCity] = []

    private var pendingCityName: String?

    // MARK: - Errors
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var countryError: String = ""
    @Published var cityError: String = ""

    // MARK: - Init
    override init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
    }

    // MARK: - Country Change Handler
    func onCountryChanged() {
        selectedCity = nil
        filteredCities = []
        cityError = ""
        guard let countryId = selectedCountry?.id else { return }
        fetchCities(countryId: countryId)
    }

    // MARK: - Fetch Cities for Country
    private func fetchCities(countryId: Int) {
        Task {
            do {
                let cities = try await request(AuthEndpoint.getCities(countryId: countryId))
                self.filteredCities = (cities ?? []).map { city in
                    EditProfileCity(id: city.id, name: city.name)
                }
                // Auto-select city if we have a pending name from initial load
                if let pending = pendingCityName {
                    self.selectedCity = self.filteredCities.first { $0.name == pending }
                    self.pendingCityName = nil
                }
            } catch {
                showError(error.localizedDescription)
            }
        }
    }

    // MARK: - Fetch Profile Edit Data
    func fetchProfileEditData() {
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.getProfileEditData()
            do {
                let data = try await request(endpoint)
                if let data {
                    self.countries = data.countries ?? []

                    if let userInfo = data.userInfo {
                        self.name = userInfo.name ?? ""
                        let rawEmail = userInfo.email ?? ""
                        self.email = rawEmail.hasSuffix("@rentnow.com") ? "" : rawEmail
                        self.currentImageUrl = userInfo.image

                        // Pre-select country and fetch cities
                        if let countryName = userInfo.countryName, !countryName.isEmpty {
                            self.selectedCountry = self.countries.first { $0.name == countryName }
                        }

                        // Store pending city name and fetch cities from API
                        if let country = self.selectedCountry {
                            self.pendingCityName = userInfo.cityName
                            self.fetchCities(countryId: country.id)
                        }
                    }
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    // MARK: - Validate
    private func validate() -> Bool {
        var isValid = true

        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nameError = "Full Name is required".localized
            isValid = false
        } else {
            nameError = nil
        }

        emailError = nil
        countryError = ""
        cityError = ""

        if selectedCountry == nil {
            countryError = "Country is required".localized
            isValid = false
        }

        if selectedCity == nil {
            cityError = "City is required".localized
            isValid = false
        }

        return isValid
    }

    // MARK: - Update Profile
    func updateProfile() {
        guard validate() else { return }

        Task {
            showIndicator()
            let endpoint = MoreEndpoint.updateProfile(
                email: email,
                userName: name,
                cityId: selectedCity?.id ?? 0,
                countryId: selectedCountry?.id ?? 0,
                imageData: imageData
            )
            do {
                let data = try await request(endpoint)
                if let data {
                    // Update UserDefaults
                    var user = UserDefaults.user ?? User()
                    user.fullName = data.fullName
                    user.email = data.email
                    user.profilePicture = data.profilePicture
                    user.cityId = data.cityId
                    user.cityName = data.cityName
                    UserDefaults.user = user

                    showSuccess("Profile updated successfully".localized)
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
