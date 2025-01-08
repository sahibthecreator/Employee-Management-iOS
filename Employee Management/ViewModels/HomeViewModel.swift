//
//  HomeViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 07/01/2025.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var shifts: [ShiftDTO] = []
    @Published var events: [EventDTO] = []  // Upcoming events
    @Published var shiftEvents: [String: EventDTO] = [:]  // Shift-related events
    @Published var isLoadingShifts: Bool = false
    @Published var isLoadingEvents: Bool = false
    @Published var errorMessage: String? = nil
    
//    private let employeeId = "2dc142cb-c95d-4ab5-a258-1d04c2d6c244"
    
    // MARK: - Parallel Loading of Shifts and Events
    func loadShiftsAndEvents() async {
        errorMessage = nil
        isLoadingShifts = true
        isLoadingEvents = true
        
        await withTaskGroup(of: Void.self) { group in
            // Load Shifts
            group.addTask { await self.loadShifts() }
            
            // Load Events (Upcoming)
            group.addTask { await self.loadUpcomingEvents() }
        }
    }
    
    private func loadShifts() async {
        defer { isLoadingShifts = false }  // Stop loading indicator when complete
        
        do {
            let shiftResponse: ShiftResponseDTO = try await APIClient.shared.requestAsync(
                endpoint: "shifts?employeeId=\(employeeId)",
                responseType: ShiftResponseDTO.self
            )
            self.shifts = shiftResponse.data
            
            // Fetch shift-related events in parallel
            await withTaskGroup(of: Void.self) { group in
                for shift in shiftResponse.data {
                    group.addTask {
                        await self.loadEventForShift(shift.id)
                    }
                }
            }
            
        } catch let error as APIError {
            print(error)
            handleAPIError(error, forShifts: true)
        } catch {
            errorMessage = "Failed to load shifts."
        }
    }
    
    // MARK: - Load Upcoming Events
    private func loadUpcomingEvents() async {
        defer { isLoadingEvents = false }  // Stop loading indicator when complete
        
        do {
            let today = DateFormatter.iso8601Zulu.string(from: Date())
            let response: EventResponseDTO = try await APIClient.shared.requestAsync(
                endpoint: "events?startDate=\(today)",
                responseType: EventResponseDTO.self
            )
           
            self.events = response.data.filter { $0.shiftIDs == nil }  // Filter only null shiftIDs to display only unassigned events
            print(response.data)
        } catch let error as APIError {
            print(error)
            handleAPIError(error, forShifts: false)
        } catch {
            errorMessage = "Failed to load events."
        }
    }
    
    // MARK: - Load Single Event for Shift
    private func loadEventForShift(_ shiftId: String) async {
        do {
            if shiftEvents[shiftId] == nil {
                let event: EventDTO = try await APIClient.shared.requestAsync(
                    endpoint: "events/\(shiftId)",
                    responseType: EventDTO.self
                )
                shiftEvents[shiftId] = event
            }
        } catch {
            print("Failed to fetch event for shift \(shiftId)")
        }
    }
    
    // MARK: - Handle API Errors
    private func handleAPIError(_ error: APIError, forShifts: Bool) {
        switch error {
        case .serverError(400):
            errorMessage = "Bad request. Please check your input."
        case .serverError(401):
            errorMessage = "Unauthorized. Please log in again."
        case .serverError(404):
            errorMessage = forShifts ? "No shifts found." : "No events found."
        default:
            errorMessage = "Failed to load data."
        }
        
        if forShifts {
            isLoadingShifts = false
        } else {
            isLoadingEvents = false
        }
    }
}


