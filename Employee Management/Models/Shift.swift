//
//  Shift.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct ShiftDTO: Identifiable, Decodable {
    @DocumentID var id: String?
    var eventId: String
    var startTime: Date
    var endTime: Date
    var assignedUserIds: [String]
    var assignedUsers: [AssignedUser]
    var event: EventDTO?
    var teammates: [String]? = []
}

struct AssignedUser: Codable {
    var userId: String
    var role: String
    var fullName: String?
    var clockInTime: Date?
    var clockOutTime: Date?
    
    
    var initials: String {
        let nameComponents = fullName?.split(separator: " ") ?? []
        return nameComponents
            .compactMap { $0.first }
            .prefix(2)
            .map { String($0) }
            .joined()
            .uppercased()
    }
}
