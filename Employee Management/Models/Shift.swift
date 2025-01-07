//
//  Shift.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 29/12/2024.
//

import Foundation

struct ShiftDTO: Decodable, Identifiable {
    let id: String
    let startTime: Date
    let endTime: Date
    let employeeId: String
    let shiftType: Int
    let status: Int
    let clockInTime: Date?
    let clockOutTime: Date?
    let shiftHours: Int?
    let roleID: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "shiftId"
        case startTime
        case endTime
        case employeeId
        case shiftType
        case status
        case clockInTime
        case clockOutTime
        case shiftHours
        case roleID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.employeeId = try container.decode(String.self, forKey: .employeeId)
        self.shiftType = try container.decode(Int.self, forKey: .shiftType)
        self.status = try container.decode(Int.self, forKey: .status)
        self.shiftHours = try container.decodeIfPresent(Int.self, forKey: .shiftHours)
        self.roleID = try container.decode(Int.self, forKey: .roleID)
        
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        
        self.startTime = DateFormatter.iso8601.date(from: startTimeString) ?? Date()
        self.endTime = DateFormatter.iso8601.date(from: endTimeString) ?? Date()
        
        // Handle optional clock-in and clock-out times
        if let clockInString = try container.decodeIfPresent(String.self, forKey: .clockInTime) {
            self.clockInTime = DateFormatter.iso8601.date(from: clockInString)
        } else {
            self.clockInTime = nil
        }
        
        if let clockOutString = try container.decodeIfPresent(String.self, forKey: .clockOutTime) {
            self.clockOutTime = DateFormatter.iso8601.date(from: clockOutString)
        } else {
            self.clockOutTime = nil
        }
    }
}

struct ShiftResponseDTO: Decodable {
    let success: Bool
    let message: String
    let data: [ShiftDTO]
}
