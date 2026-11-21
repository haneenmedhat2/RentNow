//
//  ForgetPasswordButton.swift
//  Holool
//
//  Created by Elshamy on 04/11/2025.
//

import SwiftUI

struct VisitorButton: View {
    var title: String
    var action: () -> Void
     
    var body: some View {
   
            Button(action: action){
                Text(title)
                   .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundStyle(.textSecondary)
                    .underline(true , color: .textSecondary)
            }
       
        .padding(.horizontal , 16)
    }
}

#Preview {
    VisitorButton(title: "done", action: {})
}
