//
//  AppDatePickerField.swift
//  Holool
//
//  Created by Elshamy on 14/12/2025.
//

import SwiftUI

enum DatePickerMode {
    case date           // yyyy-MM-dd
    case time           // HH:mm
    case dateAndTime    // yyyy-MM-dd HH:mm

    var datePickerStyle: DatePickerComponents {
        switch self {
        case .date:
            return [.date]
        case .time:
            return [.hourAndMinute]
        case .dateAndTime:
            return [.date, .hourAndMinute]
        }
    }

    var dateFormat: String {
        switch self {
        case .date:
            return "yyyy-MM-dd"
        case .time:
            return "hh:mm a"
        case .dateAndTime:
            return "yyyy-MM-dd hh:mm a"
        }
    }
}

struct AppDatePickerField: View {
    var title: String
    var image: String
    var placeHolder: String
    var mode: DatePickerMode = .date
    var maximumDate: Date? = nil
    @Binding var text: String
    @Binding var textError: String?

    @State private var selectedDate: Date = Date()
    @State private var showPicker: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
               .expoSystemFont(size:FontSize.normal , weight: .medium)

            VStack(spacing: 0) {
                Button(action: {
                    // Parse existing text to date if available
                    if !text.isEmpty {
                        if let date = parseDate(from: text) {
                            selectedDate = date
                        }
                    }
                    showPicker = true
                }) {
                    HStack(spacing: 8) {
                      

                        Text(text.isEmpty ? placeHolder : text)
                           .expoSystemFont(size:FontSize.normal , weight: .regular)
                            .foregroundColor(text.isEmpty ? Color.gray.opacity(0.6) : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        if image != "" {
                            Image(image)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                        }

//                        Image(systemName: getIconName())
//                            .foregroundColor(.gray)
//                           .expoSystemFont(size:FontSize.large)
                    }
                    .padding()
                    .glassyBackground(cornerRadius: 12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                        (textError != nil) ? Color.red : Color.clear,
                        lineWidth: 0.7
                    ))
                }
                .buttonStyle(PlainButtonStyle())

                if textError != nil {
                    HStack {
                        Text(textError ?? "")
                           .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.red)
                            .padding(8)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $showPicker) {
            DatePickerSheet(
                selectedDate: $selectedDate,
                mode: mode,
                maximumDate: maximumDate,
                onDone: { date in
                    selectedDate = date
                    text = formatDate(date)
                    showPicker = false
                },
                onCancel: {
                    showPicker = false
                }
            )
            .presentationDetents([.height(400)])
        }
    }

    private func getIconName() -> String {
        switch mode {
        case .date:
            return "calendar"
        case .time:
            return "clock"
        case .dateAndTime:
            return "calendar.badge.clock"
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = mode.dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }

    private func parseDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = mode.dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: string)
    }
}

// MARK: - DatePickerSheet
struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    let mode: DatePickerMode
    var maximumDate: Date? = nil
    let onDone: (Date) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onCancel) {
                    Text("Cancel".localized)
                       .expoSystemFont(size:FontSize.large, weight: .regular)
                        .foregroundColor(.red)
                }

                Spacer()

                Text(getTitleForMode())
                   .expoSystemFont(size:FontSize.large, weight: .medium)

                Spacer()

                Button(action: {
                    onDone(selectedDate)
                }) {
                    Text("Done".localized)
                       .expoSystemFont(size:FontSize.large, weight: .medium)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))

            Divider()

            // Date Picker
            if let maxDate = maximumDate {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: ...maxDate,
                    displayedComponents: mode.datePickerStyle
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ar"))
                .padding()
            } else {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: mode.datePickerStyle
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ar"))
                .padding()
            }

            Spacer()
        }
        .background(Color(UIColor.systemBackground))
    }

    private func getTitleForMode() -> String {
        switch mode {
        case .date:
            return "Select date".localized
        case .time:
            return "Select time".localized
        case .dateAndTime:
            return "Select date and time".localized
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        AppDatePickerField(
            title: "تاريخ بداية الإيجار",
            image: "",
            placeHolder: "اختر التاريخ",
            mode: .date,
            text: .constant(""),
            textError: .constant(nil)
        )

        AppDatePickerField(
            title: "وقت البداية",
            image: "",
            placeHolder: "اختر الوقت",
            mode: .time,
            text: .constant(""),
            textError: .constant(nil)
        )

        AppDatePickerField(
            title: "التاريخ والوقت",
            image: "",
            placeHolder: "اختر التاريخ والوقت",
            mode: .dateAndTime,
            text: .constant(""),
            textError: .constant(nil)
        )
    }
    .background(
        LinearGradient.mainGradient.ignoresSafeArea()
    )
}
