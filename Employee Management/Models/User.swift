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
}
