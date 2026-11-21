//
//  FilterSelectionRowView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct FilterSelectionRowView: View {
    let mainTitle:String
    let title: String
    let selectAllTitle: String
    let selectedCount: Int
    let totalCount: Int
    var onRowTap: () -> Void
    var onSelectAllTap: () -> Void

    var body: some View {
        VStack(alignment: .leading , spacing: 16) {
         
            Text(mainTitle.localized)
            
                .expoSystemFont(size: FontSize.normal, weight: .regular)
            
            Button {
                onRowTap()
            } label: {
                HStack {
                    // Title on the trailing side (right in LTR, left in RTL)
                    Text(title)
                        .expoSystemFont(size: FontSize.large, weight: .medium)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Select all link on the leading side
                    if selectedCount < totalCount {
                        Button {
                            onSelectAllTap()
                        } label: {
                            Text(selectAllTitle)
                                .expoSystemFont(size: FontSize.normal, weight: .medium)
                                .foregroundColor(.mainColor)
                        }
                    } else {
                        Text("all_selected".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(.vertical, 16)

    }
}

