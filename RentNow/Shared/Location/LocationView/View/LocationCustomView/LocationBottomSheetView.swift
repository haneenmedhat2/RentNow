//
//  LocationBottomSheetView.swift
//  Holool
//
//  Created by Elshamy on 23/11/2025.
//

import SwiftUI
import CoreLocation

struct LocationBottomSheetView: View {
    
    var currentAddress: String?
    var onConfirmTapped: (() -> Void)?
    
    var body: some View {
        ZStack {
            Spacer()
            VStack(alignment: .leading ,spacing: 8) {
                
                // Drag Indicator
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Selected Location Label
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Current location :".localized)
                       .expoSystemFont(size:FontSize.normal , weight: .medium)
                        .padding(.horizontal, 16)
                    
                    // Address Details
                    HStack(spacing: 8) {
                        
                        Image("location")
                            .foregroundColor(.gray)
                           .expoSystemFont(size: 20)
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            if let address = currentAddress {
                                Text(address)
                                   .expoSystemFont(size:FontSize.normal )
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.trailing)
                            } else {
                                Text("Try collect location ...".localized)
                                   .expoSystemFont(size:FontSize.normal )
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal, 16)
                }
                
                
                // Confirm Button
                
                MainButton(title: "Confirm".localized) {
                    onConfirmTapped?()
                }
                .padding(.bottom , 16)
                
            }
            
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.9))
                    
            )
            
          
        }
    
    }
}

#Preview {
    VStack {
        Spacer()
        LocationBottomSheetView(
            currentAddress: "123 Main Street, City, Country",
            onConfirmTapped: {
                print("Confirmed")
            }
        )
    }
}
