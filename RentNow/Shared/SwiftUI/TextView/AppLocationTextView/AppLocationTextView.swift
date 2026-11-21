//
//  AppLocationTextView.swift
//  Holool
//
//  Created by Elshamy on 01/12/2025.
//


//
//  AppLocationTextView.swift
//  Holool
//
//  Created by Elshamy on [Current Date]
//

import SwiftUI
import CoreLocation

struct AppLocationTextView: View {
    // MARK: - Properties
    var title: String
    var image: String
    var placeHolder: String
    @Binding var address: String?
    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var addressError: String?
    
    // Callback for navigation
    var onTap: (() -> Void)?
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
               .expoSystemFont(size:FontSize.normal , weight: .medium)
            
            VStack(spacing: 0) {
                Button(action: {
                
                    onTap?()
                }) {
                    HStack(spacing: 8) {
                        Image(image)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .scaledToFit()
                        
                        Text((address?.isEmpty ?? true) ? placeHolder : (address ?? "Location".localized))
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor((address?.isEmpty ?? true) ? Color.gray.opacity(0.6) : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                
                    }
                    .padding()
                    .glassyBackground(cornerRadius: 12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                        (addressError != nil) ? Color.red : Color.clear,
                        lineWidth: 0.7
                    ))
                }
                .buttonStyle(PlainButtonStyle())

                if addressError != nil {
                    HStack {
                        Text(addressError ?? "")
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(.red)
                            .padding(8)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    AppLocationTextView(
        title: "Location",
        image: "markerSelectLocation",
        placeHolder: "Choose your location",
        address: .constant(""),
        coordinate: .constant(nil),
        addressError: .constant(nil),
        onTap: {
            print("Location picker tapped")
        }
    )
}

