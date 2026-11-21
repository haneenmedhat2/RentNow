//
//  ReportDetailContentCardView.swift
//  RentNow
//

import SwiftUI

struct ReportDetailContentCardView: View {

    let detail: ReportDetailData
    let incidentTime: String
    let pdfFileName: String?
    var onPDFTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Incident Date
            infoRow(
                label: "Incident Date".localized,
                value: detail.incidentDateFormatted ?? ""
            )

            // Incident Time
            if !incidentTime.isEmpty {
                infoRow(
                    label: "Incident Time".localized,
                    value: incidentTime
                )
            }

            // Incident Location
            if let location = detail.geoAddress, !location.isEmpty {
                infoRow(
                    label: "Incident Location".localized,
                    value: location
                )
            }

            // Issuing Authority
            if let authority = detail.incidentReportIssuer, !authority.isEmpty {
                infoRow(
                    label: "Issuing Authority".localized,
                    value: authority
                )
            }

            // PDF Section
            if let fileName = pdfFileName, !fileName.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("The Report".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.subtitleTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        onPDFTap?()
                    } label: {
                        HStack(spacing: 6) {
                            
                         

                                Image("PDF")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                            
                            
                            Text(fileName)
                                .expoSystemFont(size: FontSize.normal, weight: .bold)
                                .foregroundColor(.darkTextColor)
                                .lineLimit(1)

                        
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.24))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }

    // MARK: - Helpers
    private func infoRow(label: String, value: String) -> some View {
        HStack(spacing: 6) {
           
            Text(label)
                .expoSystemFont(size: FontSize.normal, weight: .bold)
                .foregroundColor(.subtitleTextColor)
            Spacer()
            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .bold)
                .foregroundColor(.darkTextColor)
           
        }
    }
}
