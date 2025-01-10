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
    
    func role(for userId: String?) -> String {
        guard let userId = userId else { return "Unknown Role" }
        return assignedUsers.first(where: { $0.userId == userId })?.role ?? "Unknown Role"
    }
    
    func assignedUser(for userId: String?) -> AssignedUser? {
        guard let userId = userId else { return nil }
        return assignedUsers.first(where: { $0.userId == userId })
    }
}

struct AssignedUser: Codable {
    var userId: String
    var role: String
    var fullName: String?
    var clockInTime: Date?
    var clockOutTime: Date?
    var completedTasks: [Int]?
    
    
    var initials: String {
        let nameComponents = fullName?.split(separator: " ") ?? []
        return nameComponents
            .compactMap { $0.first }
            .prefix(2)
            .map { String($0) }
            .joined()
            .uppercased()
    }
    
    init(userId: String, role: String, clockInTime: Date? = nil, clockOutTime: Date? = nil, completedTasks: [Int] = []) {
        self.userId = userId
        self.role = role
        self.clockInTime = clockInTime
        self.clockOutTime = clockOutTime
        self.completedTasks = completedTasks
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "userId": userId,
            "role": role,
            "completedTasks": completedTasks ?? []
        ]

        if let clockInTime = clockInTime {
            dictionary["clockInTime"] = clockInTime
        }

        if let clockOutTime = clockOutTime {
            dictionary["clockOutTime"] = clockOutTime
        }

        return dictionary
    }
    
    static func fromFirestore(_ data: [String: Any]) -> AssignedUser? {
        guard let userId = data["userId"] as? String,
              let role = data["role"] as? String else {
            return nil
        }
        
        return AssignedUser(
            userId: userId,
            role: role,
            clockInTime: (data["clockInTime"] as? Timestamp)?.dateValue(),
            clockOutTime: (data["clockOutTime"] as? Timestamp)?.dateValue(),
            completedTasks: data["completedTasks"] as? [Int] ?? []
        )
    }
}
