//
//  AvailabilityViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 27/11/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

//class AvailabilityViewModel: ObservableObject {
//    @Published var selectedDate: Date = Date()
//    @Published var selectedDayAvailability: Availability?
//    @Published var daysInMonth: [Int?] = []
//    @Published var currentMonth: String = ""
//    @Published var currentYear: Int = 0
//
//    private let calendar = Calendar.current
//    public var availabilityData: [Date: Availability] = [:]
//
//    var weekdaySymbols: [String] {
//        let symbols = calendar.shortWeekdaySymbols
//        let firstWeekdayIndex = calendar.firstWeekday - 1 // Adjust to zero-based index
//        return Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
//    }
//
//    init() {
//        updateCalendar(for: Date())
//    }
//
//    func loadInitialData() {
//        // Mock availability data
//        availabilityData = [
//            Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 26))!: Availability(timeRange: "10:00-13:00"),
//            Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 28))!: Availability(timeRange: "08:00-12:00"),
//        ]
//        updateAvailability()
//    }
//
//    func goBack() {
//        // Handle back navigation
//    }
//
//    func previousMonth() {
//        guard let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) else { return }
//        updateCalendar(for: newDate)
//    }
//
//    func nextMonth() {
//        guard let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) else { return }
//        updateCalendar(for: newDate)
//    }
//
//    func selectDate(_ day: Int?) {
//        guard let day = day else { return }
//        if let newDate = calendar.date(from: DateComponents(year: currentYear, month: calendar.component(.month, from: selectedDate), day: day)) {
//            selectedDate = newDate
//            updateAvailability()
//        }
//    }
//
//    func isSelected(day: Int?) -> Bool {
//        guard let day = day else { return false }
//        return calendar.component(.day, from: selectedDate) == day
//    }
//
//    private func updateCalendar(for date: Date) {
//        selectedDate = date
//        currentMonth = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
//        currentYear = calendar.component(.year, from: date)
//        daysInMonth = generateDays(for: date)
//    }
//
//    private func generateDays(for date: Date) -> [Int?] {
//        guard let range = calendar.range(of: .day, in: .month, for: date),
//              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else { return [] }
//
//        let firstWeekday = calendar.component(.weekday, from: firstDay) - calendar.firstWeekday
//        let emptyDays = (firstWeekday + 7) % 7
//        return Array(repeating: nil, count: emptyDays) + Array(range)
//    }
//
//    private func updateAvailability() {
//        selectedDayAvailability = availabilityData[selectedDate]
//    }
//
//    var formattedSelectedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .full
//        return formatter.string(from: selectedDate)
//    }
//    
//    func saveAvailability(to newAvailability: String) {
//        availabilityData[selectedDate] = Availability(timeRange: newAvailability)
//        updateAvailability()
//    }
//}
//
//struct Availability {
//    let timeRange: String
//}


class AvailabilityViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedDayAvailability: Availability?
    @Published var daysInMonth: [Int?] = []
    @Published var currentMonth: String = ""
    @Published var currentYear: Int = 0
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let calendar = Calendar.current
    private var db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    public var availabilityData: [Date: Availability] = [:]
    
    var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        return Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
    }

    init() {
        updateCalendar(for: Date())
    }

    func loadInitialData() {
        guard let userId = userId else { return }
        isLoading = true
        errorMessage = nil
        
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)!.start
        let endOfMonth = calendar.dateInterval(of: .month, for: selectedDate)!.end
        
        db.collection("availability")
            .document(userId)
            .collection("dates")
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfMonth))
            .whereField("date", isLessThanOrEqualTo: Timestamp(date: endOfMonth))
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = "Failed to load availability: \(error.localizedDescription)"
                        return
                    }
                    guard let documents = snapshot?.documents else { return }
                    
                    self?.availabilityData = documents.compactMap { doc -> (Date, Availability)? in
                        let data = doc.data()
                        
                        // Manually parse the date as Timestamp and convert it to Date
                        guard let timestamp = data["date"] as? Timestamp else {
                            print("Failed to parse timestamp")
                            return nil
                        }
                        
                        let availability = Availability(
                            id: doc.documentID,
                            date: timestamp,
                            timeRange: data["timeRange"] as? String ?? "",
                            status: data["status"] as? String ?? "available",
                            startTime: data["startTime"] as? String,
                            endTime: data["endTime"] as? String
                        )
                        
                        print("success")
                        return (timestamp.dateValue(), availability)
                    }
                    .reduce(into: [Date: Availability]()) { (result, tuple) in
                        result[tuple.0] = tuple.1
                    }
                    
                    self?.updateAvailability()
                }
            }
    }
    
    func saveAvailability(to newAvailability: String, startTime: String? = nil, endTime: String? = nil) {
        guard let userId = userId else { return }
        let formattedDate = calendar.startOfDay(for: selectedDate)
        
        let availability = Availability(
            date: Timestamp(date: formattedDate),
            timeRange: newAvailability,
            status: startTime == nil ? "unavailable" : "partial",
            startTime: startTime,
            endTime: endTime
        )
        
        db.collection("availability")
            .document(userId)
            .collection("dates")
            .document(formattedDate.toFirestoreString())
            .setData(availability.toDictionary()) { [weak self] error in
                if let error = error {
                    print("Error saving availability: \(error.localizedDescription)")
                    return
                }
                self?.availabilityData[formattedDate] = availability
                self?.updateAvailability()
            }
    }
    
    func deleteAvailability() {
        guard let userId = userId else { return }
        let formattedDate = calendar.startOfDay(for: selectedDate)
        
        db.collection("availability")
            .document(userId)
            .collection("dates")
            .document(formattedDate.toFirestoreString())
            .delete { [weak self] error in
                if let error = error {
                    print("Failed to delete availability: \(error.localizedDescription)")
                    return
                }
                self?.availabilityData.removeValue(forKey: formattedDate)
                self?.updateAvailability()
            }
    }
    
    func saveAvailabilityForDateRange(startDate: Date, endDate: Date) {
        guard let userId = userId else { return }
        
        let range = generateDateRange(from: startDate, to: endDate)
        let batch = db.batch()
        
        for date in range {
            let formattedDate = calendar.startOfDay(for: date)
            let availability = Availability(
                date: Timestamp(date: formattedDate),
                timeRange: "Unavailable Entire Day",
                status: "unavailable",
                startTime: nil,
                endTime: nil
            )
            
            let docRef = db.collection("availability")
                .document(userId)
                .collection("dates")
                .document(formattedDate.toFirestoreString())
            
            batch.setData(availability.toDictionary(), forDocument: docRef)
        }
        
        batch.commit { error in
            if let error = error {
                print("Failed to save availability for multiple days: \(error.localizedDescription)")
                return
            }
            print("Successfully saved availability for multiple days")
            self.loadInitialData()
        }
    }

    private func generateDateRange(from start: Date, to end: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = start
        while currentDate <= end {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
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

    private func updateAvailability() {
        selectedDayAvailability = availabilityData[selectedDate]
    }
    
    func isSelected(day: Int?) -> Bool {
        guard let day = day else { return false }
        return calendar.component(.day, from: selectedDate) == day
    }
    
    func date(for day: Int?) -> Date? {
        guard let day = day else { return nil }
        return calendar.date(from: DateComponents(year: currentYear, month: calendar.component(.month, from: selectedDate), day: day))
    }

    
    var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: selectedDate)
    }
}


// Date Extension for Firestore-friendly format
extension Date {
    func toFirestoreString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
