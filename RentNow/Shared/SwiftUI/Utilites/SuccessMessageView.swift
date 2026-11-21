//
//  SuccessMessageView.swift
//  Nebealk
//
//  Created by Mohamed Elmemy on 10/08/2024.
//

import SwiftUI

struct SuccessMessageView: View {
    @EnvironmentObject var successMessageManager: SuccessMessageManager

    var body: some View {
        if successMessageManager.showMessage, let message = successMessageManager.successMessage {
            VStack {
                Text(message)
                    .padding()
                    .background(Color.main)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.slide)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                successMessageManager.showMessage = false
                                successMessageManager.successMessage = nil
                            }
                        }
                    }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}


#Preview {
    SuccessMessageView()
}
