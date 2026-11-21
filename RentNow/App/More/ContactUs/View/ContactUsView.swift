//
//  ContactUsView.swift
//  RentNow
//

import SwiftUI

struct ContactUsView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ContactUsViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true, disableScroll: true) {
            VStack(spacing: 0) {
                // Visitor: show name and phone fields
                if viewModel.isVisitor {
                    AppTextView(
                        title: "Full Name".localized,
                        image: "",
                        placeHolder: "Full Name".localized,
                        text: $viewModel.fullName,
                        textError: $viewModel.fullNameError
                    )
                    .padding(.top, 16)

                    PhoneTextView(
                        phone: $viewModel.phoneNumber,
                        phoneError: $viewModel.phoneError,
                        hasEditedPhone: $viewModel.hasEditedPhone,
                        countryCode: $viewModel.countryCode,
                        countries: viewModel.countriesArray
                    )
                    .padding(.top, 8)
                }

                AppTextEditor(
                    title: "Message Text".localized,
                    placeHolder: "Enter message text".localized,
                    text: $viewModel.message,
                    textError: $viewModel.messageError
                )
                .padding(.top, 16)

                MainButton(title: "Confirm Send".localized) {
                    viewModel.submitMessage()
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)

                Spacer()

                // Contact section
                VStack(spacing: 16) {
                    Text("You can contact us through".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.text)

                    HStack(spacing: 24) {
                        ContactIconButton(imageName: "emailicon") {
                            openEmail()
                        }
                        ContactIconButton(imageName: "call") {
                            openPhone()
                        }
                        ContactIconButton(imageName: "whats") {
                            openWhatsApp()
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Contact Us".localized)
        .task {
            await viewModel.fetchContactInfo()
        }
    }

    // MARK: - Actions
    private func openEmail() {
        let email = viewModel.contactInfo?.email ?? ""
        guard !email.isEmpty, let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }

    private func openPhone() {
        let phone = viewModel.contactInfo?.phoneNumber ?? ""
        guard !phone.isEmpty, let url = URL(string: "tel:\(phone)") else { return }
        UIApplication.shared.open(url)
    }

    private func openWhatsApp() {
        let whatsApp = viewModel.contactInfo?.whatsAppNumber ?? ""
        guard !whatsApp.isEmpty, let url = URL(string: "https://wa.me/\(whatsApp)") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Contact Icon Button
struct ContactIconButton: View {
    var imageName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.mainColor)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color(red: 234/255, green: 249/255, blue: 255/255))
                )
        }
    }
}

#Preview {
    ContactUsView(coordinator: MoreCoordinator(), viewModel: ContactUsViewModel())
}
