//
//  User.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import FirebaseFirestore

struct UserDTO: Identifiable, Decodable {
    @DocumentID var id: String?
    var fullName: String
    var email: String
    var phone: String
    
    var initials: String {
        let names = fullName.split(separator: " ")
        let initials = names.compactMap { $0.first?.uppercased() }.joined()
        return String(initials.prefix(2))  // Ensure only two initials are used
    }
}
