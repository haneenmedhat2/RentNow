//
//  MyAdDetailsImageOverlayButtonsView.swift
//  RentNow
//

import SwiftUI

struct MyAdDetailsImageOverlayButtonsView: View {

    let canEdit: Bool
    let canDelete: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()

                if canEdit {
                    Button {
                        onEdit()
                    } label: {
                        Image("editAds")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }

                if canDelete {
                    Button {
                        onDelete()
                    } label: {
                        Image("deleteAds")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 60)
            Spacer()
        }
    }
}

#Preview {
    MyAdDetailsImageOverlayButtonsView(
        canEdit: true,
        canDelete: true,
        onEdit: {},
        onDelete: {}
    )
}
