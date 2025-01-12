//
//  CalendarService.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 12/01/2025.
//

import Foundation
import Combine

class CalendarService: ObservableObject {
    private let calendar = Calendar.current
    
    /// Generate all days in a grid, including placeholders
    func generateDaysInGrid(for selectedDate: Date) -> [Date?] {
        var days: [Date?] = []
        let firstDayOfMonth = startOfMonth(for: selectedDate)
        
        // Adjust the weekday calculation to start on Monday
        var firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - calendar.firstWeekday
        if firstWeekday < 0 {
            firstWeekday += 7
        }
        
        // Add leading placeholders
        for _ in 0..<firstWeekday {
            days.append(nil)
        }
        
        // Add actual days in the month
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        // Add trailing placeholders to complete a 6x7 (42 days) grid
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
    
    /// Get the start of the month for a given date
    func startOfMonth(for date: Date) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    }
    
    /// Get weekday symbols starting from Monday
    func weekdaySymbols() -> [String] {
        var symbols = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        if firstWeekdayIndex > 0 {
            symbols = Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
        }
        return symbols
    }
    
    /// Check if two dates are the same
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
    
    /// Format a date to a short day string
    func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
