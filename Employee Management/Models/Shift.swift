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
    var clockInTime: Date?
    var clockOutTime: Date?
}
