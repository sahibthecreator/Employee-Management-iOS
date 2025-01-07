//
//  Availability.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 07/01/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct Availability: Codable {
    @DocumentID var id: String?
    var date: Timestamp
    var timeRange: String
    var status: String
    var startTime: String?
    var endTime: String?
    
    func toDictionary() -> [String: Any] {
        return [
            "date": date,
            "timeRange": timeRange,
            "status": status,
            "startTime": startTime ?? "",
            "endTime": endTime ?? ""
        ]
    }
}
