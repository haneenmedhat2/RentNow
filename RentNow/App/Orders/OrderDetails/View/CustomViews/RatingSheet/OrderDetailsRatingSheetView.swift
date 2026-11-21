//
//  OrderDetailsRatingSheetView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsRatingSheetView: View {
    @State var selectedRating: Int = 0
    @State var showError: Bool = false
    var onSubmit: (Int) -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            MainGradientView()
            VStack(spacing: 24) {
            // Header
            HStack {

                Button {
                    onClose()
                } label: {
                    Image("closeButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                }

                Text("Rate Car".localized)
                    .expoSystemFont(size: FontSize.large, weight: .semiBold)

                Spacer()


            }

            .padding(.horizontal, 24)
            .padding(.top, 20)

            // Stars
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { index in
                    Button {
                        selectedRating = index
                    } label: {
                        Image(systemName: index <= selectedRating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(index <= selectedRating ? .yellow : .gray)
                    }
                }
            }

            Spacer()

            if showError {
                Text("Please select a rating".localized)
                    .expoSystemFont(size: FontSize.small, weight: .medium)
                    .foregroundColor(.red)
            }

            // Confirm Button
            MainButton(title: "Confirm".localized) {
                if selectedRating == 0 {
                    showError = true
                } else {
                    showError = false
                    onSubmit(selectedRating)
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
    OrderDetailsRatingSheetView(
        onSubmit: { _ in },
        onClose: {}
    )
}
