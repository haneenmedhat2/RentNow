//
//  CreateOrderReturnPickupMethodView.swift
//  RentNow
//

import SwiftUI

struct CreateOrderReturnPickupMethodView: View {
    @Binding var returnPickupMethod: DeliveryMethod
    let returnPickupAddress: String?
    let error: String?
    var onSelectLocation: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Return method to lessor".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            VStack(spacing: 8) {
                Button {
                    returnPickupMethod = .pickupFromLocation
                } label: {
                    HStack(spacing: 12) {
                        RadioButton(isSelected: returnPickupMethod == .pickupFromLocation)

                        Text("Return to lessor".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black)

                        Spacer()
                    }
                    .padding(12)
                    .glassyBackground(cornerRadius: 10)
                }

                Button {
                    returnPickupMethod = .delivery
                } label: {
                    HStack(spacing: 12) {
                        RadioButton(isSelected: returnPickupMethod == .delivery)

                        Text("Delivery".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black)

                        Spacer()
                    }
                    .padding(12)
                    .glassyBackground(cornerRadius: 10)
                }
            }

            if returnPickupMethod == .delivery {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Return pickup location".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.black)

                    Button {
                        onSelectLocation()
                    } label: {
                        HStack(spacing: 8) {
                            Text(returnPickupAddress ?? "Select return pickup location".localized)
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(returnPickupAddress != nil ? .black : .gray.opacity(0.6))

                            Spacer()

                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        .padding()
                        .glassyBackground(cornerRadius: 12)
                    }

                    if let error = error {
                        Text(error)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(.red)
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    CreateOrderReturnPickupMethodView(
        returnPickupMethod: .constant(.pickupFromLocation),
        returnPickupAddress: nil,
        error: nil,
        onSelectLocation: {}
    )
    .background(LinearGradient.mainGradient.ignoresSafeArea())
}
