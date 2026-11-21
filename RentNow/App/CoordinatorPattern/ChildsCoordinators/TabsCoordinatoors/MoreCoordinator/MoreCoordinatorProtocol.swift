//
//  MoreCoordinatorProtocol.swift
//  RentNow
//
//  Created by Elshamy on 11/02/2026.
//

import Foundation

protocol MoreCoordinatorProtocol {
    func showProfile()
    func showSettings()
    func showMyAds()
    func showCustomerOrders()
    func showMyRatings()
    func showFinancialTransactions()
    func showAboutUs()
    func showContactUs()
    func showHowItWorks()
    func showTermsAndConditions()
    func showCancellationTerms()
    func showComplaintsAndSuggestions()
    func showReports()
    func showPackages()
    func showLogoutConfirmation()
    func showLogin()
    func showEditProfile()
    func showChangePhone()
    func showChangePhoneNewNumber()
    func showChangePhoneCode(phoneCode: String, newPhoneNumber: String)
    func popToSettings()
    func showChangePassword()
    func showLanguage()
    func showDeleteAccountConfirmation(onConfirm: @escaping () -> Void)
    func showMyAdDetails(adId: Int, filterType: MyAdFilterType)
    func showCustomerOrderDetails(orderId: Int)
    func showDeleteAdSheet(onConfirm: @escaping () -> Void)
    func showEditAd(details: MyAdDetailsData)
    func popToMyAds()
    func showAllRatings(advertisementId: Int)
    func showCreateComplaint()
    func showComplaintDetails(complaintId: Int)
    func showReportDetails(reportId: Int)
    func showBankAccountForm()
    func showSettlementDetails(settlementId: Int)
    func showMyWallet()
    func showWalletRechargeSheet(onConfirm: @escaping (Double, Int, MoyasarPaymentMethod) -> Void)
    func showWalletWithdrawSheet(balance: Double, onConfirm: @escaping (Double, String, String, String, String) -> Void)
    func showPayment(session: PaymentSession, onResult: @escaping (PaymentResult) -> Void)
}
