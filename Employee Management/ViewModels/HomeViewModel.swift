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
    @Published var events: [String: EventDTO] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let employeeId = "2dc142cb-c95d-4ab5-a258-1d04c2d6c244"
    
    // MARK: - Load Shifts
    func loadShifts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let shiftResponse: ShiftResponseDTO = try await APIClient.shared.requestAsync(
                endpoint: "shifts?employeeId=\(employeeId)",
                responseType: ShiftResponseDTO.self
            )
            self.shifts = shiftResponse.data
            
            // Fetch event details for each shift
            for shift in shiftResponse.data {
                if events[shift.id] == nil {
                    let event = try await fetchEvent(for: shift.id)
                    events[shift.id] = event
                }
            }
            print(shifts)
            print(events[shifts[0].id])
        } catch let error as APIError {
            handleAPIError(error)
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
        
        isLoading = false
    }
    
    private func fetchEvent(for shiftId: String) async throws -> EventDTO {
        let response: EventDTO = try await APIClient.shared.requestAsync(
            endpoint: "events/\(shiftId)",
            responseType: EventDTO.self
        )
        return response
    }
    
    private func handleAPIError(_ error: APIError) {
        switch error {
        case .serverError(400):
            errorMessage = "Bad request. Please check your input."
        case .serverError(401):
            errorMessage = "Unauthorized. Please log in again."
        case .serverError(404):
            errorMessage = "No shifts found."
        default:
            errorMessage = "Failed to load data."
        }
    }
}

