//
//  Task.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 09/01/2025.
//

import Foundation

struct TaskDTO: Identifiable, Decodable {
//    var id: Int { taskId } // Conform to Identifiable using taskId
    let id: Int
    let title: String
    let requiresImage: Bool
    var isDone: Bool = false // Default to not done
    var time: String?
    
    init(id: Int, title: String, requiresImage: Bool, isDone: Bool = false, time: String?) {
        self.id = id
        self.title = title
        self.requiresImage = requiresImage
        self.isDone = isDone
        if let time = time {
            self.time = time
        }
    }

    init(from dictionary: [String: Any]) throws {
        self.id = dictionary["id"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? "Untitled Task"
        self.requiresImage = dictionary["requiresImage"] as? Bool ?? false
        self.isDone = false
    }
}
