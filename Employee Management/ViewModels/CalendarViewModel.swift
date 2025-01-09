//
//  CalendarViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CalendarViewModel: ObservableObject {
    @Published var selectedTab: Int = 0  // 0: My Schedule, 1: Upcoming Events
    @Published var currentWeek: Date = Date()  // Start of the current week
    @Published var isFullMonthView: Bool = false
    @Published var shifts: [ShiftDTO] = []
    @Published var events: [EventDTO] = []
    
    @Published var isShiftsLoading: Bool = false
    @Published var shiftErrorMessage: String?
    
    @Published var isEventsLoading: Bool = false
    @Published var eventErrorMessage: String?

    private var userService = UserService()
    private var db = Firestore.firestore()
    
    init() {
        fetchContent(for: currentWeek)
    }

    // Fetch shifts and events based on the current date range
    func fetchContent(for startDate: Date) {
        isShiftsLoading = true
        shiftErrorMessage = nil
        
        let range = dateRange(for: startDate)
        
        if(selectedTab == 0) {
            fetchShifts(in: range)
        }
        else {
            fetchUnassignedEvents(in: range)
        }
    }

    private func fetchShifts(in range: ClosedRange<Date>) {
        db.collection("shifts")
          .whereField("startTime", isGreaterThanOrEqualTo: Timestamp(date: range.lowerBound))
          .whereField("startTime", isLessThanOrEqualTo: Timestamp(date: range.upperBound))
          .getDocuments { [weak self] snapshot, error in
              DispatchQueue.main.async {
                  if let error = error {
                      self?.shiftErrorMessage = "Failed to fetch shifts: \(error.localizedDescription)"
                      return
                  }
                  
                  let fetchedShifts = snapshot?.documents.compactMap { doc in
                      try? doc.data(as: ShiftDTO.self)
                  } ?? []
                  
                  self?.shifts = fetchedShifts
                  
                  // Fetch event details for each shift
                  for (index, shift) in fetchedShifts.enumerated() {
                      self?.fetchEventDetails(for: shift, at: index)
                      self?.fetchTeammates(for: shift, at: index)
                  }
                  self?.isShiftsLoading = false
              }
          }
    }
    
    private func fetchEventDetails(for shift: ShiftDTO, at index: Int) {
        db.collection("events").document(shift.eventId).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                guard let event = try? document?.data(as: EventDTO.self) else {
                    return
                }
                
                self?.shifts[index].event = event
            }
        }
    }
    
    private func fetchTeammates(for shift: ShiftDTO, at index: Int) {
        var updatedAssignedUsers = shift.assignedUsers
        let dispatchGroup = DispatchGroup()

        for (i, user) in updatedAssignedUsers.enumerated() {
            dispatchGroup.enter()
            
            // Use getCurrentUser to handle caching and fresh fetch logic
            if user.userId == Auth.auth().currentUser?.uid {
                userService.getCurrentUser { [weak self] cachedUser in
                    if let cachedUser = cachedUser {
                        updatedAssignedUsers[i].fullName = cachedUser.fullName
                    }
                    dispatchGroup.leave()
                }
            } else {
                // Fetch other users by ID
                userService.getUserById(userId: user.userId) { [weak self] fetchedUser in
                    if let fetchedUser = fetchedUser {
                        updatedAssignedUsers[i].fullName = fetchedUser.fullName
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.shifts[index].assignedUsers = updatedAssignedUsers
        }
    }

    private func fetchUnassignedEvents(in range: ClosedRange<Date>) {
        isEventsLoading = true
        
        db.collection("events")
          .whereField("startTime", isGreaterThanOrEqualTo: Timestamp(date: range.lowerBound))
          .whereField("startTime", isLessThanOrEqualTo: Timestamp(date: range.upperBound))
          .whereField("shiftsAssigned", isEqualTo: false)  // only unassigned events
          .getDocuments { [weak self] snapshot, error in
              DispatchQueue.main.async {
                  self?.isEventsLoading = false
                  if let error = error {
                      self?.eventErrorMessage = "Failed to fetch events: \(error.localizedDescription)"
                      print(error)
                      return
                  }
                  
                  self?.events = snapshot?.documents.compactMap { doc in
                      try? doc.data(as: EventDTO.self)
                  } ?? []
              }
          }
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

    // Helper: Calculate the date range for a week or full month
    private func dateRange(for startDate: Date) -> ClosedRange<Date> {
        let calendar = Calendar.current
        
        if isFullMonthView {
            let startOfMonth = calendar.dateInterval(of: .month, for: startDate)!.start
            let endOfMonth = calendar.dateInterval(of: .month, for: startDate)!.end.addingTimeInterval(-1)
            return startOfMonth...endOfMonth
        } else {
            let startOfWeek = calendar.startOfWeek(for: startDate)
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            return startOfWeek...endOfWeek
        }
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
