//
//  PersonalProfileCardView.swift
//  RentNow
//

import SwiftUI

struct PersonalProfileCardView: View {
    let profile: ProfileInfoData

    private let dashedStroke = StrokeStyle(lineWidth: 1, dash: [5, 3])
    private let borderColor = Color.secondaryDarkFont.opacity(0.4)

    var body: some View {
        VStack(spacing: 0) {
            // Profile Picture Row
            VStack {
                HStack {
                    Text("Profile Picture".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.text)
                    
                    Spacer()
                }
               
                HStack {
                    RemoteImageView(url: profile.image)
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)


            // Detail Rows
            ProfileDetailRow(label: "Full Name".localized, value: profile.name ?? "")
            ProfileDetailRow(label: "Phone Number".localized, value: profile.phoneNumber ?? "")
//            if !(profile.email ?? "").hasSuffix("@rentnow.com") {
//                ProfileDetailRow(label: "Email".localized, value: profile.email ?? "")
//            }
            ProfileDetailRow(label: "Country".localized, value: profile.countryName ?? "")
            ProfileDetailRow(label: "City".localized, value: profile.cityName ?? "")
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: dashedStroke)
                .foregroundColor(borderColor)
        )
    }
}

// MARK: - Dashed Divider
struct DashedDivider: View {
    var color: Color = .secondaryDarkFont.opacity(0.4)

    var body: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
            .foregroundColor(color)
            .frame(height: 1)
            .padding(.horizontal, 16)
    }
}

private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

// MARK: - Profile Detail Row
struct ProfileDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.text)

            Spacer()

            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

