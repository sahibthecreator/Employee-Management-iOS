//
//  ShiftCardViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 10/01/2025.
//

import Foundation


class ShiftCardViewModel: ObservableObject {
    @Published var state: OngoingShiftState = .needToClockIn
    
    let shift: ShiftDTO
    private let userId: String
    
    init(shift: ShiftDTO, userId: String) {
        self.shift = shift
        self.userId = userId
        self.updateState()
    }
    
    // Determine the current state of the shift for the user
    private func updateState() {
        if let assignedUser = shift.assignedUser(for: userId) {
            if assignedUser.clockInTime == nil {
                state = .needToClockIn
            } else if assignedUser.clockOutTime == nil {
                state = .clockedIn
            }
        }
    }
    
    // Actions
//    func clockIn(completion: @escaping () -> Void) {
//        guard let assignedUser = shift.assignedUser(for: userId) else { return }
//        // Simulate clock-in logic
//        let clockInTime = Date()
//        assignedUser.clockInTime = clockInTime
//        updateState()
//        completion()
//    }
//    
//    func clockOut(completion: @escaping () -> Void) {
//        guard let assignedUser = shift.assignedUser(for: userId) else { return }
//        // Simulate clock-out logic
//        let clockOutTime = Date()
//        assignedUser.clockOutTime = clockOutTime
//        updateState()
//        completion()
//    }
}
