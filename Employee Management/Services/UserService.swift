//
//  UserService.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    private let db = Firestore.firestore()
    private var cachedUser: UserDTO?
    private let cacheExpiration: TimeInterval = 86400  // 24 hours cache
    private var cacheTimestamp: Date?
        
    func getCurrentUser(completion: @escaping (UserDTO?) -> Void) {
        if let cachedUser = cachedUser, let cacheTimestamp = cacheTimestamp, Date().timeIntervalSince(cacheTimestamp) < cacheExpiration {
            completion(cachedUser)
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        getUserById(userId: userId) { [weak self] user in
            self?.cachedUser = user
            self?.cacheTimestamp = Date()
            completion(user)
        }
    }
        
    func invalidateCache() {
        cachedUser = nil
        cacheTimestamp = nil
    }

    func getUserById(userId: String, completion: @escaping (UserDTO?) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            guard let document = document, document.exists else {
                completion(nil)
                return
            }
            let user = try? document.data(as: UserDTO.self)
            completion(user)
        }
    }
}
