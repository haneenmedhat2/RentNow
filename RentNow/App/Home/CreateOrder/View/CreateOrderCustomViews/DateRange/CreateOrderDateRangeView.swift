//
//  CreateOrderDateRangeView.swift
//  RentNow
//

import SwiftUI

struct CreateOrderDateRangeView: View {
    let title: String
    @Binding var dateFrom: String
    @Binding var dateTo: String
    let formattedRange: String
    @Binding var error: String?

    @State private var showPicker: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
               
            }

            VStack(spacing: 0) {
                Button(action: {
                    showPicker = true
                }) {
                    HStack(spacing: 8) {
                       
                        Text(formattedRange.isEmpty ? "Select date".localized : formattedRange)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(formattedRange.isEmpty ? Color.gray.opacity(0.6) : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image("calendar-02")
                            .frame(width: 20, height: 20)
                            .scaledToFit()
  
                    }
                    .padding()
                    .glassyBackground(cornerRadius: 12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                        (error != nil) ? Color.red : Color.clear,
                        lineWidth: 0.7
                    ))
                }
                .buttonStyle(PlainButtonStyle())

                if let errorText = error {
                    HStack {
                        Text(errorText)
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
            DateRangePickerSheet(
                initialFrom: dateFrom,
                initialTo: dateTo,
                onDone: { from, to in
                    dateFrom = from
                    dateTo = to
                    showPicker = false
                },
                onCancel: {
                    showPicker = false
                }
            )
            .presentationDetents([.height(480)])
        }
    }
}

// MARK: - DateRangePickerSheet

struct DateRangePickerSheet: View {
    let initialFrom: String
    let initialTo: String
    var onDone: (String, String) -> Void
    var onCancel: () -> Void

    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var displayedMonth: Date = Date()

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    private let today: Date = {
        Calendar.current.startOfDay(for: Date())
    }()

    init(initialFrom: String, initialTo: String, onDone: @escaping (String, String) -> Void, onCancel: @escaping () -> Void) {
        self.initialFrom = initialFrom
        self.initialTo = initialTo
        self.onDone = onDone
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onCancel) {
                    Text("Cancel".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.red)
                }

                Spacer()

                Text("Select date".localized)
                    .expoSystemFont(size: FontSize.large, weight: .semiBold)

                Spacer()

                Button(action: {
                    guard let start = startDate else { return }
                    let end = endDate ?? start
                    onDone(dateFormatter.string(from: start), dateFormatter.string(from: end))
                }) {
                    Text("Done".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(startDate != nil ? .mainColor : .gray)
                }
                .disabled(startDate == nil)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // Month navigation
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.mainColor)
                        .font(.system(size: 16, weight: .semibold))
                }

                Spacer()

                Text(monthYearString(for: displayedMonth))
                    .expoSystemFont(size: FontSize.large, weight: .semiBold)

                Spacer()

                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.mainColor)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            // Weekday headers
            let weekdaySymbols = calendar.shortWeekdaySymbols
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 4)

            // Calendar grid
            let days = daysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 4) {
                ForEach(days, id: \.id) { dayItem in
                    if dayItem.date == nil {
                        Text("")
                            .frame(height: 40)
                    } else {
                        let date = dayItem.date!
                        let isPast = date < today
                        let isStart = startDate != nil && calendar.isDate(date, inSameDayAs: startDate!)
                        let isEnd = endDate != nil && calendar.isDate(date, inSameDayAs: endDate!)
                        let isInRange = isDateInRange(date)
                        let isToday = calendar.isDate(date, inSameDayAs: today)

                        Button(action: {
                            if !isPast { selectDate(date) }
                        }) {
                            ZStack {
                                // Range background
                                if isInRange && !isStart && !isEnd {
                                    Rectangle()
                                        .fill(Color.mainColor.opacity(0.12))
                                        .frame(height: 40)
                                }

                                // Start/end range connector
                                if isStart && endDate != nil {
                                    HStack(spacing: 0) {
                                        Color.clear.frame(width: 20)
                                        Color.mainColor.opacity(0.12)
                                    }
                                    .frame(height: 40)
                                }
                                if isEnd && startDate != nil {
                                    HStack(spacing: 0) {
                                        Color.mainColor.opacity(0.12)
                                        Color.clear.frame(width: 20)
                                    }
                                    .frame(height: 40)
                                }

                                // Circle for selected dates
                                if isStart || isEnd {
                                    Circle()
                                        .fill(Color.mainColor)
                                        .frame(width: 36, height: 36)
                                }

                                Text("\(calendar.component(.day, from: date))")
                                    .expoSystemFont(size: FontSize.normal, weight: (isStart || isEnd) ? .semiBold : .regular)
                                    .foregroundColor(
                                        isPast ? .gray.opacity(0.35) :
                                        (isStart || isEnd) ? .white :
                                        isToday ? .mainColor : .primary
                                    )
                            }
                        }
                        .disabled(isPast)
                        .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 8)

            Spacer()
        }
        .onAppear {
            if !initialFrom.isEmpty, let d = dateFormatter.date(from: initialFrom) {
                startDate = calendar.startOfDay(for: d)
                displayedMonth = d
            }
            if !initialTo.isEmpty, let d = dateFormatter.date(from: initialTo) {
                endDate = calendar.startOfDay(for: d)
            }
        }
        .logViewAppearance(viewName: "DateRangePickerSheet")
    }

    // MARK: - Helpers

    private func selectDate(_ date: Date) {
        let day = calendar.startOfDay(for: date)
        if startDate == nil || (startDate != nil && endDate != nil) {
            // First selection or reset
            startDate = day
            endDate = nil
        } else if let start = startDate {
            if day < start {
                startDate = day
                endDate = nil
            } else if calendar.isDate(day, inSameDayAs: start) {
                endDate = nil
            } else {
                endDate = day
            }
        }
    }

    private func isDateInRange(_ date: Date) -> Bool {
        guard let start = startDate, let end = endDate else { return false }
        return date > start && date < end
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }

    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func daysInMonth() -> [DayItem] {
        var items: [DayItem] = []

        let components = calendar.dateComponents([.year, .month], from: displayedMonth)
        guard let firstOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
            return items
        }

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        // Add empty cells for days before the 1st
        for i in 0..<(firstWeekday - 1) {
            items.append(DayItem(id: "empty-\(i)", date: nil))
        }

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                items.append(DayItem(id: "day-\(day)", date: calendar.startOfDay(for: date)))
            }
        }

        return items
    }
}

private struct DayItem: Identifiable {
    let id: String
    let date: Date?
}

#Preview {
    CreateOrderDateRangeView(
        title: "تاريخ الإيجار",
        dateFrom: .constant("2026-07-28"),
        dateTo: .constant("2026-07-31"),
        formattedRange: "٢٨ يوليو - ٣١ يوليو",
        error: .constant(nil)
    )
    .background(LinearGradient.mainGradient.ignoresSafeArea())
}
