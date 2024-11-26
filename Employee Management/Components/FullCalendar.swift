//
//  FullCalendar.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 26/11/2024.
//

import Foundation
import SwiftUI

struct FullCalendar: View {
    @Binding var selectedDate: Date
    let onSelectWeek: (Date) -> Void

    // Calculate the start of the month
    private var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
    }

    // Generate all days in the grid, including leading/trailing placeholders
    private var daysInGrid: [Date?] {
        var days: [Date?] = []

        let firstDayOfMonth = startOfMonth
        let firstWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth) - 1 // Adjusted for 0-based index

        // Add leading placeholders
        for _ in 0..<firstWeekday {
            days.append(nil)
        }

        // Add actual days in the month
        let range = Calendar.current.range(of: .day, in: .month, for: startOfMonth)!
        for day in range {
            if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }

        // Add trailing placeholders to make the grid a complete 6x7 (42 days)
        while days.count % 7 != 0 {
            days.append(nil)
        }

        return days
    }

    var body: some View {
        VStack {
            // Header: Month and Year
            HStack {
                Button(action: {
                    moveMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.secondary)
                        .padding()
                }
                Spacer()
                Text("\(monthYearString(from: startOfMonth))")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    moveMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.secondary)
                        .padding()
                }
            }

            // Weekday Headers
            HStack {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }

            // Dates Grid
            VStack {
                ForEach(daysInGrid.chunked(into: 7), id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Button(action: {
                                if let date = date {
                                    selectWeek(for: date)
                                }
                            }) {
                                if let date = date {
                                    Text(dayString(from: date))
                                        .font(.body)
                                        .foregroundColor(isSameDate(date, selectedDate) ? .white : .black)
                                        .frame(width: 40, height: 40)
                                        .background(
                                            isSameDate(date, selectedDate) ? AppColors.secondary : Color.clear
                                        )
                                        .clipShape(Circle())
                                } else {
                                    // Placeholder for empty days
                                    Text("")
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .disabled(date == nil)
                        }
                    }
                }
            }
        }
        .padding()
    }

    // Helper: Move the selected month
    private func moveMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: startOfMonth) {
            selectedDate = newDate
        }
    }

    // Helper: Select a week
    private func selectWeek(for date: Date) {
        let startOfWeek = Calendar.current.startOfWeek(for: date)
        onSelectWeek(startOfWeek)
    }

    // Helper: Format day as a string
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    // Helper: Format month and year as a string
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    // Helper: Check if two dates are the same
    private func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

// Helper: Chunk an array into smaller arrays of a fixed size
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
