//
//  SettingsView.swift
//  RentNow
//

import SwiftUI
import UIKit

struct SettingsView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: SettingsViewModel

    private var notificationBinding: Binding<Bool> {
        Binding(
            get: { viewModel.notificationsEnabled },
            set: { newValue in
                viewModel.notificationsEnabled = newValue
                viewModel.toggleNotification()
            }
        )
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {
                MainGradientView()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsMenuItemView(
                            icon: "user",
                            title: "Edit Profile".localized,
                            onTap: { coordinator.showEditProfile() }
                        )

                        SettingsMenuItemView(
                            icon: "smart-phone-01",
                            title: "Change phone number".localized,
                            onTap: { coordinator.showChangePhone() }
                        )

                        SettingsMenuItemView(
                            icon: "circle-lock-02",
                            title: "Change password".localized,
                            onTap: { coordinator.showChangePassword() }
                        )

                        SettingsNotificationRow(isOn: notificationBinding)

                        SettingsMenuItemView(
                            icon: "language-circle",
                            title: "Language".localized,
                            onTap: {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )

                        SettingsDeleteAccountRow(
                            onTap: {
                                coordinator.showDeleteAccountConfirmation {
                                    viewModel.deleteAccount()
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
        .navigationTitle("Settings".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}


