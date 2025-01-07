//
//  HomeViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var shifts: [ShiftDTO] = []
    @Published var events: [String: EventDTO] = [:]  // Cache for events
    @Published var unassignedEvents: [EventDTO] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var eventsIsLoading: Bool = false
    @Published var eventsErrorMessage: String?
    
    private var db = Firestore.firestore()
    private var userService = UserService()
    
    init() {
        fetchShifts { [weak self] in
            self?.fetchUpcomingEvents()
        }
    }
    
    func fetchShifts(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        errorMessage = nil
        
        db.collection("shifts")
          .whereField("assignedUserIds", arrayContains: userId)
          .order(by: "startTime")
          .getDocuments { [weak self] snapshot, error in
              DispatchQueue.main.async {
                  if let error = error {
                      self?.errorMessage = "Failed to fetch shifts: \(error.localizedDescription)"
                      completion()  // Continue to fetch events even if shifts fail
                      return
                  }
                  
                  guard let documents = snapshot?.documents else {
                      self?.errorMessage = "No shifts found."
                      completion()
                      return
                  }
                  
                  let fetchedShifts = documents.compactMap { try? $0.data(as: ShiftDTO.self) }
                  self?.shifts = fetchedShifts
                  
                  for (index, shift) in fetchedShifts.enumerated() {
                      self?.fetchEventForShift(shift, at: index)
                      self?.fetchTeammates(for: shift, at: index)
                  }
                  self?.isLoading = false
                  completion()  // to trigger event fetching after completion
              }
          }
    }
    
    func fetchUpcomingEvents() {
        eventsIsLoading = true
        eventsErrorMessage = nil
        
        db.collection("events")
          .whereField("startTime", isGreaterThan: Timestamp(date: Date()))
          .order(by: "startTime")
          .getDocuments { [weak self] snapshot, error in
              DispatchQueue.main.async {
                  self?.eventsIsLoading = false
                  
                  if let error = error {
                      self?.eventsErrorMessage = "Failed to fetch events: \(error.localizedDescription)"
                      return
                  }
                  
                  guard let documents = snapshot?.documents else {
                      print("No upcoming events found.")
                      return
                  }
                  
                  let allEvents = documents.compactMap { try? $0.data(as: EventDTO.self) }
                  self?.filterUnassignedEvents(allEvents: allEvents)
              }
          }
    }
    
    private func filterUnassignedEvents(allEvents: [EventDTO]) {
        let assignedEventIds = Set(self.shifts.map { $0.eventId })
        self.unassignedEvents = allEvents.filter { event in
            !assignedEventIds.contains(event.id ?? "")
        }
    }
    
    private func fetchEventForShift(_ shift: ShiftDTO, at index: Int) {
        if let cachedEvent = events[shift.eventId] {
            // Use cache if available
            shifts[index].event = cachedEvent
        } else {
            db.collection("events").document(shift.eventId).getDocument { [weak self] document, error in
                if let event = try? document?.data(as: EventDTO.self) {
                    DispatchQueue.main.async {
                        self?.events[shift.eventId] = event
                        self?.shifts[index].event = event
                    }
                }
            }
        }
    }
    
    private func fetchTeammates(for shift: ShiftDTO, at index: Int) {
        let teammateIds = shift.assignedUserIds

        var fetchedTeammates: [String] = []

        let dispatchGroup = DispatchGroup()

        for userId in teammateIds {
            dispatchGroup.enter()
            userService.getUserById(userId: userId) { [weak self] user in
                if let fullName = user?.fullName {
                    fetchedTeammates.append(fullName)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.shifts[index].teammates = fetchedTeammates
        }
    }
}
