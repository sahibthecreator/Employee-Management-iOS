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


class AvailabilityViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedDayAvailability: Availability?
    @Published var daysInGrid: [Date?] = []
    @Published var currentMonth: String = ""
    @Published var currentYear: Int = 0
    public var availabilityData: [Date: Availability] = [:]
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let calendarService = CalendarService()
    
    private let calendar = Calendar.current
    private var db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
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
                        
                        // manually parse the date as Timestamp and convert it to Date
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
    
    func saveAvailabilityForDateRange(endDate: Date) {
        guard let userId = userId else { return }
        
        let range = generateDateRange(from: selectedDate, to: endDate)
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
        daysInGrid = calendarService.generateDaysInGrid(for: selectedDate)
    }
    
    func previousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) else { return }
        updateCalendar(for: newDate)
    }
    
    func nextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) else { return }
        updateCalendar(for: newDate)
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        updateAvailability()
    }
    
    func date(for day: Int?) -> Date? {
        guard let day = day else { return nil }
        return calendar.date(from: DateComponents(year: currentYear, month: calendar.component(.month, from: selectedDate), day: day))
    }
    
    private func updateAvailability() {
        selectedDayAvailability = availabilityData[selectedDate]
    }
    
    var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: selectedDate)
    }
}
