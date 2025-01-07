//
//  Event.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct EventDTO: Identifiable, Decodable {
    @DocumentID var id: String?
    var startTime: Date
    var endTime: Date
    var address: String
    var venue: String
    var description: String
    var status: String
    var note: String?
}
