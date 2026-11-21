//
//  AppSegmentedControl.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//

import SwiftUI

struct AppSegmentedControl: View {
    let options: [SegmentOption]
    @Binding var selectedValue: PricePolicy
    
    var selectedIndex: Int {
        options.firstIndex(where: { $0.value.rawValue == selectedValue.rawValue }) ?? 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            ForEach(options.indices, id: \.self) { index in
                SegmentButton(
                    title: options[index].title,
                    isSelected: options[index].value.rawValue == selectedValue.rawValue
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedValue = PricePolicy(rawValue: options[index].value.rawValue) ?? selectedValue
                    }
                }
            }
          Spacer()
        }
        .padding([.trailing , .leading] ,16)
        
    
    }
}

