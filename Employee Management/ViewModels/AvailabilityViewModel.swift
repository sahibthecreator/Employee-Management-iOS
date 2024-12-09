//
//  AvailabilityViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 27/11/2024.
//

import Foundation

class AvailabilityViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedDayAvailability: Availability?
    @Published var daysInMonth: [Int?] = []
    @Published var currentMonth: String = ""
    @Published var currentYear: Int = 0

    private let calendar = Calendar.current
    public var availabilityData: [Date: Availability] = [:]

    var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1 // Adjust to zero-based index
        return Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
    }

    init() {
        updateCalendar(for: Date())
    }

    func loadInitialData() {
        // Mock availability data
        availabilityData = [
            Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 26))!: Availability(timeRange: "10:00-13:00"),
            Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 28))!: Availability(timeRange: "08:00-12:00"),
        ]
        updateAvailability()
    }

    func goBack() {
        // Handle back navigation
    }

    func previousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) else { return }
        updateCalendar(for: newDate)
    }

    func nextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) else { return }
        updateCalendar(for: newDate)
    }

    func selectDate(_ day: Int?) {
        guard let day = day else { return }
        if let newDate = calendar.date(from: DateComponents(year: currentYear, month: calendar.component(.month, from: selectedDate), day: day)) {
            selectedDate = newDate
            updateAvailability()
        }
    }

    func isSelected(day: Int?) -> Bool {
        guard let day = day else { return false }
        return calendar.component(.day, from: selectedDate) == day
    }

    private func updateCalendar(for date: Date) {
        selectedDate = date
        currentMonth = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
        currentYear = calendar.component(.year, from: date)
        daysInMonth = generateDays(for: date)
    }

    private func generateDays(for date: Date) -> [Int?] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstDay) - calendar.firstWeekday
        let emptyDays = (firstWeekday + 7) % 7
        return Array(repeating: nil, count: emptyDays) + Array(range)
    }

    private func updateAvailability() {
        selectedDayAvailability = availabilityData[selectedDate]
    }

    var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: selectedDate)
    }
    
    func saveAvailability(to newAvailability: String) {
        availabilityData[selectedDate] = Availability(timeRange: newAvailability)
        updateAvailability()
    }
}

struct Availability {
    let timeRange: String
}
