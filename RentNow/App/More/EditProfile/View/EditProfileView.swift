//
//  EditProfileView.swift
//  RentNow
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: EditProfileViewModel

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            BaseView(viewModel: viewModel, showMainBackground: false) {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Profile Image
                            EditProfileImageView(
                                mediaItems: $viewModel.mediaItems,
                                imageData: $viewModel.imageData,
                                currentImageUrl: viewModel.currentImageUrl
                            )
                            .padding(.top, 16)

                            // Full Name
                            AppTextView(
                                title: "Full Name".localized,
                                image: "",
                                placeHolder: "Full Name".localized,
                                isRequired: true,
                                text: $viewModel.name,
                                textError: $viewModel.nameError
                            )

                            // Email
//                            AppTextView(
//                                title: "Email".localized,
//                                image: "",
//                                placeHolder: "Email".localized,
//                                keyboardType: .emailAddress,
//                                text: $viewModel.email,
//                                textError: $viewModel.emailError
//                            )

                            // Country
                            AppPickerField(
                                title: "Country".localized,
                                items: viewModel.countries,
                                selectedItem: $viewModel.selectedCountry,
                                errorMessage: viewModel.countryError,
                                isRequired: true
                            )

                            // City
                            AppPickerField(
                                title: "City".localized,
                                items: viewModel.filteredCities,
                                selectedItem: $viewModel.selectedCity,
                                errorMessage: viewModel.cityError,
                                isRequired: true
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 100)
                    }

                    Spacer()

                    // Confirm Button
                    MainButton(title: "Confirm".localized) {
                        viewModel.updateProfile()
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Edit Personal Profile".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.fetchProfileEditData()
        }
        .onChange(of: viewModel.selectedCountry) { _ in
            viewModel.onCountryChanged()
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(viewModel: EditProfileViewModel())
    }
}
