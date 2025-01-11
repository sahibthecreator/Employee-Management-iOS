//
//  FullCalendarViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 11/01/2025.
//

import Foundation

class FullCalendarViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var daysInGrid: [Date?] = []
    let onSelectWeek: (Date) -> Void

    init(selectedDate: Date, onSelectWeek: @escaping (Date) -> Void) {
        self.selectedDate = selectedDate
        self.onSelectWeek = onSelectWeek
        generateDaysInGrid()
    }

    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
    }

    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: startOfMonth)
    }

    func generateDaysInGrid() {
        var days: [Date?] = []
        let firstDayOfMonth = startOfMonth
        
        // Adjust the weekday calculation to start on Monday
        var firstWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth) - Calendar.current.firstWeekday
        if firstWeekday < 0 {
            firstWeekday += 7
        }
        
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
        
        // Add trailing placeholders to complete a 6x7 (42 days) grid
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        daysInGrid = days
    }

    func moveMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: startOfMonth) {
            selectedDate = newDate
            generateDaysInGrid()
        }
    }

    func selectDate(_ date: Date) {
        let startOfWeek = Calendar.current.startOfWeek(for: date)
        onSelectWeek(startOfWeek)
    }

    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    func weekdaySymbols() -> [String] {
        var symbols = Calendar.current.shortWeekdaySymbols
        let firstWeekdayIndex = Calendar.current.firstWeekday - 1
        if firstWeekdayIndex > 0 {
            symbols = Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
        }
        return symbols
    }
}
