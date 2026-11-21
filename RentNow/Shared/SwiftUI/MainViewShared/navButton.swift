//
//  navButton.swift
//  Holool
//
//  Created by Elshamy on 10/11/2025.
//

import SwiftUI

struct BackButtonView: View {
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(imageName)
                    .resizable()
                    .frame(width: 15, height: 20)
                  
              
            }
        }
    }
}
