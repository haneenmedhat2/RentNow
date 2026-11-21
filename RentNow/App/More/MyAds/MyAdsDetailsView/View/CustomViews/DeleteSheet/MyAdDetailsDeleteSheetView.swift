//
//  MyAdDetailsDeleteSheetView.swift
//  RentNow
//

import SwiftUI

struct MyAdDetailsDeleteSheetView: View {
    var onConfirm: () -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            MainGradientView()
            VStack(spacing: 24) {
                // Header
                HStack {
                    Spacer()

                    Button {
                        onClose()
                    } label: {
                        Image("closeButton")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Red circle icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 80, height: 80)
                    Image(systemName: "nosign")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }

                // Title & Subtitle
                VStack(spacing: 8) {
                    Text("Delete Ad".localized)
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                        .foregroundColor(.black)

                    Text("Please note that this cannot be undone".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Buttons
                HStack(spacing: 12) {
                    OutlineButton(title: "cancel".localized, action: {
                        onClose()
                    })

                    MainButton(title: "Confirm Delete".localized, backgroundColor: .red) {
                        onConfirm()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .logViewAppearance()
    }
}

#Preview {
    MyAdDetailsDeleteSheetView(
        onConfirm: {},
        onClose: {}
    )
}
