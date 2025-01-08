//
//  Event.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 29/12/2024.
//

import Foundation

struct EventDTO: Decodable, Identifiable {
    let id: String
    let rowKey: String
    let startTime: Date
    let endTime: Date
    let address: String
    let venue: String
    let description: String
    let money: Int
    let status: String
    let person: PersonDTO
    let note: String
    let shiftIDs: [String]?
    let roleIDs: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "partitionKey"
        case rowKey
        case startTime
        case endTime
        case address
        case venue
        case description
        case money
        case status
        case person
        case note
        case shiftIDs
        case roleIDs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.rowKey = try container.decode(String.self, forKey: .rowKey)
        self.address = try container.decode(String.self, forKey: .address)
        self.venue = try container.decode(String.self, forKey: .venue)
        self.description = try container.decode(String.self, forKey: .description)
        self.money = try container.decode(Int.self, forKey: .money)
        self.status = try container.decode(String.self, forKey: .status)
        self.person = try container.decode(PersonDTO.self, forKey: .person)
        self.note = try container.decode(String.self, forKey: .note)
        self.roleIDs = try container.decodeIfPresent([String].self, forKey: .roleIDs)
        
        // Convert startTime and endTime from String to Date
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        
        self.startTime = DateFormatter.iso8601.date(from: startTimeString) ?? Date()
        self.endTime = DateFormatter.iso8601.date(from: endTimeString) ?? Date()
        
        if let shiftIDsArray = try? container.decode([String]?.self, forKey: .shiftIDs) {
            self.shiftIDs = shiftIDsArray
        } else {
            self.shiftIDs = nil
        }
    }
}

struct EventResponseDTO: Decodable {
    let success: Bool
    let message: String
    let data: [EventDTO]
}
