//
//  LoginHeaderView.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//



import SwiftUI

struct VerificationHeaderView: View {


    var body: some View {
        HStack() {
            // MARK: -Texts
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Text("verification_code_title".localized)
                        .expoSystemFont(size: 20, weight: .bold)
                        .foregroundColor(.black)
                    Text("✅")
                        .font(.system(size: 20))
                }

                Text("verification_code_subtitle".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(Color.black.opacity(0.6))
            }



            Spacer()


        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)

    }

}

#Preview {
    VerificationHeaderView()
}
