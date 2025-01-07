//
//  UserService.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import FirebaseFirestore

class UserService {
    private let db = Firestore.firestore()

    func getUserById(userId: String, completion: @escaping (UserDTO?) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            guard let document = document, document.exists else {
                print("User not found for ID: \(userId)")
                completion(nil)
                return
            }

            let user = try? document.data(as: UserDTO.self)
            completion(user)
        }
    }
}
