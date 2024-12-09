//
//  CalendarViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var selectedTab: Int = 0 // 0: My Schedule, 1: Upcoming Events
    @Published var currentWeek: Date = Date() // Start of the current week
    @Published var isFullMonthView: Bool = false // Toggle for full month calendar
    @Published var shifts: [Shift] = []
    @Published var events: [Event] = []

    init() {
        fetchContent(for: currentWeek)
    }

    // Fetch data based on the current week's date range
    func fetchContent(for startDate: Date) {
        let range = dateRange(for: startDate)
        shifts = dummyShifts.filter { range.contains($0.date) }
        events = dummyEvents.filter { range.contains($0.date) }
    }

    // Navigate to the previous week
    func previousWeek() {
        currentWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeek)!
        fetchContent(for: currentWeek)
    }

    // Navigate to the next week
    func nextWeek() {
        currentWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeek)!
        fetchContent(for: currentWeek)
    }

    // Select a specific week from the full month view
    func selectWeek(startingFrom date: Date) {
        currentWeek = date
        isFullMonthView = false
        fetchContent(for: currentWeek)
    }

    // Helper: Calculate the date range for a week
    private func dateRange(for startDate: Date) -> ClosedRange<Date> {
        let startOfWeek = Calendar.current.startOfWeek(for: startDate)
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        return startOfWeek...endOfWeek
    }
}

// Extension for Calendar to calculate the start of a week
extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        guard let startOfWeek = self.date(from: self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
            fatalError("Failed to calculate the start of the week for \(date). Check your calendar settings.")
        }
        return startOfWeek
    }
}

// Data Models
struct Shift {
    let title: String
    let location: String
    let date: Date
    let time: String
    let role: String
    let teammates: [String]
    let isDraft: Bool?
    let employees: [Employee]
}

struct Event {
    let title: String
    let location: String
    let date: Date
    let time: String
    let isDraft: Bool?
}
