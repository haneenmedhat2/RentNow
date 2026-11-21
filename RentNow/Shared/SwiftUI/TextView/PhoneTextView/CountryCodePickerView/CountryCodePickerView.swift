//
//  CountryCodeView.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//
import SwiftUI

struct CountryCodePickerView: View {
    @Binding var selectedCountry: Country?
    let countries: [Country]
    
    var body: some View {
        Menu {
            ForEach(countries, id: \.id) { country in
                Button(action: {
                    selectedCountry = country
                }) {
                    HStack {
                        CountryFlagView(imagePath: country.image)
                            .frame(width: 24, height: 16)
                            .cornerRadius(2)
                        
                        Text(country.key ?? "")
                            .foregroundColor(.black)
                        
                        if country.id == selectedCountry?.id {
                           
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                CountryFlagView(imagePath: selectedCountry?.image)
                    .frame(width: 24, height: 16)
                    .cornerRadius(2)
                
                Text(selectedCountry?.key ?? "")
                    .foregroundStyle(.secondaryDarkFont)
                   .expoSystemFont(size:FontSize.normal , weight: .regular)
                

            }

        }
        .onAppear {
            updateSelectionIfNeeded()
        }
    }
    
    private func updateSelectionIfNeeded() {
        if selectedCountry == nil, let first = countries.first {
            selectedCountry = first
        }
        
        for country in countries {
            if country.id == selectedCountry?.id {
                selectedCountry?.isSelected = true
            }
        }
    }
}
