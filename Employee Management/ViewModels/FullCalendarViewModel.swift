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
    let calendarService: CalendarService
    let onSelectWeek: (Date) -> Void

    init(selectedDate: Date, onSelectWeek: @escaping (Date) -> Void) {
        self.selectedDate = selectedDate
        self.onSelectWeek = onSelectWeek
        self.calendarService = CalendarService()
        self.daysInGrid = calendarService.generateDaysInGrid(for: selectedDate)
    }

    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
    }

    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: startOfMonth)
    }

    func moveMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: startOfMonth) {
            selectedDate = newDate
            daysInGrid = calendarService.generateDaysInGrid(for: selectedDate)
        }
    }

    func selectDate(_ date: Date) {
        let startOfWeek = Calendar.current.startOfWeek(for: date)
        onSelectWeek(startOfWeek)
    }
}
