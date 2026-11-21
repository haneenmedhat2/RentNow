//
//  MoreCoordinator.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI
import CoreLocation

extension Notification.Name {
    static let myAdsNeedRefresh = Notification.Name("myAdsNeedRefresh")
}

// MARK: - More Routes
enum MoreRoute: Hashable {
    case more
    case profile
    case settings
    case language
    case aboutUs
    case contactUs
    case termsAndConditions
    case privacyPolicy
    case myAds
    case customerOrders
    case myRatings
    case financialTransactions
    case myWallet
    case bankAccountForm
    case settlementDetails(settlementId: Int)
    case howItWorks
    case cancellationTerms
    case complaintsAndSuggestions
    case reports
    case reportDetails(reportId: Int)
    case editProfile
    case changePhone
    case changePhoneNewNumber
    case changePhoneCode(phoneCode: String, newPhoneNumber: String)
    case changePassword
    case deleteAccount
    case myAdDetails(adId: Int, filterType: MyAdFilterType)
    case customerOrderDetails(orderId: Int)
    case editAd(adId: Int)
    case allRatings(advertisementId: Int)
    case createComplaint
    case complaintDetails(complaintId: Int)
}

// MARK: - More Coordinator
@MainActor
final class MoreCoordinator: BaseCoordinator<MoreRoute>, MoreCoordinatorProtocol {

    // MARK: - Callbacks
    var onLogout: (() -> Void)?

    // MARK: - Pending Edit Data
    private var detailsForEdit: MyAdDetailsData?

    // MARK: - ViewModels
    private lazy var moreViewModel = MoreViewModel()
    private lazy var myAdsViewModel = MyAdsViewModel()
    private lazy var financialTransactionsViewModel = FinancialTransactionsViewModel()
    private lazy var reportsViewModel = ReportsViewModel()
    override init() {
        super.init()
    }

    // MARK: - View Builder
    @ViewBuilder
    func buildMoreFlow() -> some View {
        NavigationStack(path: bindingPath) {
            makeView(for: .more)
                .navigationDestination(for: MoreRoute.self) { route in
                    self.makeView(for: route)
                }
        }
        .withCoordinatorPresentation(self)
    }

    @ViewBuilder
    private func makeView(for route: MoreRoute) -> some View {
        switch route {
        case .more:
            MoreView(coordinator: self, viewModel: moreViewModel)

        case .profile:
            PersonalProfileView(viewModel: PersonalProfileViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .settings:
            SettingsView(coordinator: self, viewModel: SettingsViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .language:
            PlaceholderView(title: "Language".localized)
                .toolbar(.hidden, for: .tabBar)

        case .aboutUs:
            InfoContentView(viewModel: InfoContentViewModel(type: .aboutUs))
                .toolbar(.hidden, for: .tabBar)

        case .contactUs:
            ContactUsView(coordinator: self, viewModel: makeContactUsViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .termsAndConditions:
            InfoContentView(viewModel: InfoContentViewModel(type: .termsAndConditions))
                .toolbar(.hidden, for: .tabBar)

        case .privacyPolicy:
            PlaceholderView(title: "Privacy Policy".localized)
                .toolbar(.hidden, for: .tabBar)

        case .myAds:
            MyAdsView(coordinator: self, viewModel: myAdsViewModel)
                .toolbar(.hidden, for: .tabBar)

        case .customerOrders:
            CustomerOrdersView(coordinator: self, viewModel: CustomerOrdersViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .myRatings:
            MyRatingsView(viewModel: MyRatingsViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .financialTransactions:
            FinancialTransactionsView(coordinator: self, viewModel: financialTransactionsViewModel)
                .toolbar(.hidden, for: .tabBar)

        case .myWallet:
            MyWalletView(coordinator: self, viewModel: MyWalletViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .bankAccountForm:
            BankAccountFormView(coordinator: self, viewModel: makeBankAccountFormViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .settlementDetails(let settlementId):
            SettlementDetailsView(coordinator: self, viewModel: SettlementDetailsViewModel(settlementId: settlementId))
                .toolbar(.hidden, for: .tabBar)

        case .howItWorks:
            InfoContentView(viewModel: InfoContentViewModel(type: .howItWorks))
                .toolbar(.hidden, for: .tabBar)

        case .cancellationTerms:
            InfoContentView(viewModel: InfoContentViewModel(type: .cancellationTerms))
                .toolbar(.hidden, for: .tabBar)

        case .complaintsAndSuggestions:
            ComplaintsView(coordinator: self, viewModel: ComplaintsViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .createComplaint:
            CreateComplaintView(coordinator: self, viewModel: makeCreateComplaintViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .reports:
            ReportsView(coordinator: self, viewModel: reportsViewModel)
                .toolbar(.hidden, for: .tabBar)

        case .reportDetails(let reportId):
            ReportDetailView(coordinator: self, viewModel: ReportDetailViewModel(reportId: reportId))
                .toolbar(.hidden, for: .tabBar)

        case .editProfile:
            EditProfileView(viewModel: EditProfileViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .changePhone:
            ChangePhonePasswordView(coordinator: self, viewModel: ChangePhonePasswordViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .changePhoneNewNumber:
            ChangePhoneNumberView(coordinator: self, viewModel: ChangePhoneNumberViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .changePhoneCode(let phoneCode, let newPhoneNumber):
            ChangePhoneCodeView(coordinator: self, viewModel: ChangePhoneCodeViewModel(phoneCode: phoneCode, newPhoneNumber: newPhoneNumber))
                .toolbar(.hidden, for: .tabBar)

        case .changePassword:
            ChangePasswordView(coordinator: self, viewModel: ChangePasswordViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .deleteAccount:
            EmptyView()

        case .myAdDetails(let adId, let filterType):
            MyAdDetailsView(coordinator: self, viewModel: MyAdDetailsViewModel(adId: adId, filterType: filterType))
                .toolbar(.hidden, for: .tabBar)

        case .customerOrderDetails(let orderId):
            CustomerOrderDetailsView(viewModel: CustomerOrderDetailsViewModel(orderId: orderId))
                .toolbar(.hidden, for: .tabBar)

        case .editAd:
            if let details = detailsForEdit {
                EditAdView(coordinator: self, viewModel: EditAdViewModel(details: details))
                    .toolbar(.hidden, for: .tabBar)
            }

        case .allRatings(let advertisementId):
            AllRatingsView(viewModel: AllRatingsViewModel(advertisementId: advertisementId))
                .toolbar(.hidden, for: .tabBar)

        case .complaintDetails(let complaintId):
            ComplaintDetailView(coordinator: self, viewModel: ComplaintDetailViewModel(complaintId: complaintId))
                .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: - Logout
    func showLogoutConfirmation() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        let confirmView = LogoutConfirmationView(
            onConfirm: { [weak self] in
                self?.dismiss()
                self?.moreViewModel.performLogout()
            },
            onCancel: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsPopup(confirmView)
    }

    // MARK: - Login
    func showLogin() {
        onLogout?()
    }

    // MARK: - Visitor Login Required
    private func showLoginRequired() {
        let alertView = LoginRequiredPopupView(
            onLogin: { [weak self] in
                self?.dismiss()
                self?.onLogout?()
            },
            onCancel: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsPopup(alertView)
    }

    // MARK: - Navigation Methods
    func showProfile() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.profile)
    }

    func showSettings() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.settings)
    }

    func showLanguage() {
        push(.language)
    }

    func showAboutUs() {
        push(.aboutUs)
    }

    func showContactUs() {
        push(.contactUs)
    }

    func showTermsAndConditions() {
        push(.termsAndConditions)
    }

    func showPrivacyPolicy() {
        push(.privacyPolicy)
    }

    func showMyAds() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.myAds)
    }

    func showCustomerOrders() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.customerOrders)
    }

    func showMyRatings() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.myRatings)
    }

    func showFinancialTransactions() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.financialTransactions)
    }

    func showMyWallet() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.myWallet)
    }

    func showWalletRechargeSheet(onConfirm: @escaping (Double, Int, MoyasarPaymentMethod) -> Void) {
        let sheetView = WalletRechargeSheetView(
            onClose: { [weak self] in
                self?.dismiss()
            },
            onConfirm: { [weak self] amount, method, moyasarMethod in
                self?.dismissSheet {
                    onConfirm(amount, method, moyasarMethod)
                }
            }
        )
        presentAsSheet(sheetView, detentHeight: 640)
    }

    func showPayment(
        session: PaymentSession,
        onResult: @escaping (PaymentResult) -> Void
    ) {
        presentPayment(session: session, onResult: onResult)
    }

    func showWalletWithdrawSheet(
        balance: Double,
        onConfirm: @escaping (Double, String, String, String, String) -> Void
    ) {
        let sheetView = WalletWithdrawSheetView(
            balance: balance,
            onClose: { [weak self] in
                self?.dismiss()
            },
            onConfirm: { [weak self] amount, iban, accountName, accountNumber, bankName in
                self?.dismiss()
                onConfirm(amount, iban, accountName, accountNumber, bankName)
            }
        )
        presentAsSheet(sheetView, detentHeight: 640)
    }

    func showBankAccountForm() {
        push(.bankAccountForm)
    }

    func showSettlementDetails(settlementId: Int) {
        push(.settlementDetails(settlementId: settlementId))
    }

    func showHowItWorks() {
        push(.howItWorks)
    }

    func showCancellationTerms() {
        push(.cancellationTerms)
    }

    func showComplaintsAndSuggestions() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.complaintsAndSuggestions)
    }

    func showReports() {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.reports)
    }

    func showPackages() {
        // Navigate to packages - reuse existing route or add new one
    }

    // MARK: - Settings Navigation
    func showEditProfile() {
        push(.editProfile)
    }

    func showChangePhone() {
        push(.changePhone)
    }

    func showChangePhoneNewNumber() {
        push(.changePhoneNewNumber)
    }

    func showChangePhoneCode(phoneCode: String, newPhoneNumber: String) {
        push(.changePhoneCode(phoneCode: phoneCode, newPhoneNumber: newPhoneNumber))
    }

    func popToSettings() {
        popToRoot()
        push(.settings)
    }

    func popToMyAds() {
        path = [.myAds]
        NotificationCenter.default.post(name: .myAdsNeedRefresh, object: nil)
    }

    func showChangePassword() {
        push(.changePassword)
    }

    func showMyAdDetails(adId: Int, filterType: MyAdFilterType) {
        push(.myAdDetails(adId: adId, filterType: filterType))
    }

    func showCustomerOrderDetails(orderId: Int) {
        push(.customerOrderDetails(orderId: orderId))
    }

    func showEditAd(details: MyAdDetailsData) {
        detailsForEdit = details
        push(.editAd(adId: details.id ?? 0))
    }

    func showAllRatings(advertisementId: Int) {
        push(.allRatings(advertisementId: advertisementId))
    }

    func showCreateComplaint() {
        push(.createComplaint)
    }

    func showComplaintDetails(complaintId: Int) {
        push(.complaintDetails(complaintId: complaintId))
    }

    func showReportDetails(reportId: Int) {
        push(.reportDetails(reportId: reportId))
    }

    // MARK: - Create Complaint
    private func makeCreateComplaintViewModel() -> CreateComplaintViewModel {
        let viewModel = CreateComplaintViewModel()
        viewModel.onSuccess = { [weak self] in
            let successView = SuccessView(
                title: "Complaint sent successfully".localized,
                subtitle: "Your complaint has been sent successfully".localized,
                onDismiss: { [weak self] in
                    self?.dismiss()
                    self?.pop()
                }
            )
            self?.presentAsPopup(successView)
        }
        return viewModel
    }

    // MARK: - Contact Us
    private func makeContactUsViewModel() -> ContactUsViewModel {
        let viewModel = ContactUsViewModel()
        viewModel.onSuccess = { [weak self] in
            let successView = SuccessView(
                title: "Message sent successfully".localized,
                subtitle: "Your message has been sent successfully".localized,
                onDismiss: { [weak self] in
                    self?.dismiss()
                    self?.pop()
                }
            )
            self?.presentAsPopup(successView)
        }
        return viewModel
    }

    // MARK: - Bank Account Form
    private func makeBankAccountFormViewModel() -> BankAccountFormViewModel {
        let viewModel = BankAccountFormViewModel()
        viewModel.onSuccess = { [weak self] in
            self?.pop()
            self?.financialTransactionsViewModel.switchToNewTab()
        }
        return viewModel
    }

    func showDeleteAdSheet(onConfirm: @escaping () -> Void) {
        let deleteView = MyAdDetailsDeleteSheetView(
            onConfirm: { [weak self] in
                self?.dismiss()
                onConfirm()
            },
            onClose: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsSheet(deleteView, detentHeight: 400)
    }

    func showDeleteAccountConfirmation(onConfirm: @escaping () -> Void) {
        let confirmView = DeleteAccountConfirmationView(
            onConfirm: { [weak self] in
                self?.dismiss()
                onConfirm()
            },
            onCancel: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsPopup(confirmView)
    }
}

// MARK: - Delete Account Confirmation View
struct DeleteAccountConfirmationView: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.minus")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)

            Text("Delete Account".localized)
                .font(.title3)
                .fontWeight(.semibold)

            Text("If you confirm, all your data will be deleted".localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button { onCancel() } label: {
                    Text("Go Back".localized)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }
                Button { onConfirm() } label: {
                    Text("Confirm Delete".localized)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal, 32)
        .logViewAppearance(viewName: "DeleteAccountConfirmationView")
    }
}
