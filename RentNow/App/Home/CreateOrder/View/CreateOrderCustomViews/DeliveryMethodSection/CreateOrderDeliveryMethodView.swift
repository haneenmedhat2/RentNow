//
//  CreateOrderDeliveryMethodView.swift
//  RentNow
//

import SwiftUI

struct CreateOrderDeliveryMethodView: View {
    @Binding var deliveryMethod: DeliveryMethod
    let isDeliveryEnabled: Bool
    let deliveryAddress: String?
    let error: String?
    var onSelectLocation: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Delivery method".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            VStack(spacing: 8) {
                // Pickup from location
                Button {
                    deliveryMethod = .pickupFromLocation
                } label: {
                    HStack(spacing: 12) {
                        RadioButton(isSelected: deliveryMethod == .pickupFromLocation)

                        Text("Pickup from location".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black)

                        Spacer()
                    }
                    .padding(12)
                    .glassyBackground(cornerRadius: 10)
                }

                // Delivery option
                if isDeliveryEnabled {
                    Button {
                        deliveryMethod = .delivery
                    } label: {
                        HStack(spacing: 12) {
                            RadioButton(isSelected: deliveryMethod == .delivery)

                            Text("Delivery".localized)
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(.black)

                            Spacer()
                        }
                        .padding(12)
                        .glassyBackground(cornerRadius: 10)
                    }
                }
            }

            // Delivery location selection
            if deliveryMethod == .delivery {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Delivery location".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.black)

                    Button {
                        onSelectLocation()
                    } label: {
                        HStack(spacing: 8) {
                       

                            Text(deliveryAddress ?? "Select delivery location".localized)
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(deliveryAddress != nil ? .black : .gray.opacity(0.6))

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
    CreateOrderDeliveryMethodView(
        deliveryMethod: .constant(.pickupFromLocation),
        isDeliveryEnabled: true,
        deliveryAddress: nil,
        error: nil,
        onSelectLocation: {}
    )
    .background(LinearGradient.mainGradient.ignoresSafeArea())
}
