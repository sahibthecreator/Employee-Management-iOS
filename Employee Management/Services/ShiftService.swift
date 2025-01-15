//
//  ShiftService.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 15/01/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ShiftService {
    private let db = Firestore.firestore()
    
    func clockIn(for shift: ShiftDTO, userId: String, completion: @escaping (Result<ShiftDTO, Error>) -> Void) {
        updateAssignedUserField(
            for: shift,
            userId: userId,
            field: "clockInTime",
            value: Timestamp(date: Date()),
            completion: completion
        )
    }
    
    func clockOut(for shift: ShiftDTO, userId: String, completion: @escaping (Result<ShiftDTO, Error>) -> Void) {
        updateAssignedUserField(
            for: shift,
            userId: userId,
            field: "clockOutTime",
            value: Timestamp(date: Date()),
            completion: completion
        )
    }
    
    private func updateAssignedUserField(
        for shift: ShiftDTO,
        userId: String,
        field: String,
        value: Any,
        completion: @escaping (Result<ShiftDTO, Error>) -> Void
    ) {
        guard let shiftId = shift.id else {
            return
        }
        
        var updatedTasks: [Int] = []
        
        // Prepare updated assigned users array
        let updatedUsers = shift.assignedUsers.map { user -> [String: Any] in
            var userDict = user.toDictionary()
            if user.userId == userId {
                if field == "completedTasks", let taskId = value as? Int {
                    // Update completed tasks array
                    updatedTasks = userDict["completedTasks"] as? [Int] ?? []
                    if !updatedTasks.contains(taskId) {
                        updatedTasks.append(taskId)
                    }
                    userDict["completedTasks"] = updatedTasks
                } else {
                    userDict[field] = value
                }
            }
            return userDict
        }
        
        // Update Firestore
        db.collection("shifts").document(shiftId).updateData(["assignedUsers": updatedUsers]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Update the local shift object
            var updatedShift = shift
            if let userIndex = shift.assignedUsers.firstIndex(where: { $0.userId == userId }) {
                var updatedUser = shift.assignedUsers[userIndex]
                switch field {
                case "clockInTime":
                    if let timestamp = value as? Timestamp {
                        updatedUser.clockInTime = timestamp.dateValue()
                    }
                case "clockOutTime":
                    if let timestamp = value as? Timestamp {
                        updatedUser.clockOutTime = timestamp.dateValue()
                    }
                case "completedTasks":
                    updatedUser.completedTasks = updatedTasks
                default:
                    break
                }
                updatedShift.assignedUsers[userIndex] = updatedUser
            }
            completion(.success(updatedShift))
        }
    }
    
    func loadTasks(
        for shift: ShiftDTO,
        currentUserId: String,
        completion: @escaping (Result<([TaskDTO], Int), Error>) -> Void
    ) {
        guard let currentUserRole = shift.assignedUsers.first(where: { $0.userId == currentUserId })?.role else {
            print("Role not found for current user.")
            completion(.failure(ShiftServiceError.roleNotFound))
            return
        }
        
        // Fetch role-specific tasks
        fetchRoleTasks(role: currentUserRole) { result in
            switch result {
            case .success(let predefinedTasks):
                self.fetchCompletedTasks(for: shift) { result in
                    switch result {
                    case .success(let completedIds):
                        let allTasks = predefinedTasks.map { task -> TaskDTO in
                            var updatedTask = task
                            updatedTask.isDone = completedIds.contains(task.id)
                            return updatedTask
                        }
                        let completedCount = allTasks.filter { $0.isDone }.count
                        completion(.success((allTasks, completedCount)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCompletedTasks(
        for shift: ShiftDTO,
        completion: @escaping (Result<[Int], Error>) -> Void
    ) {
        guard let shiftId = shift.id else {
            completion(.failure(ShiftServiceError.invalidShift))
            return
        }
        
        db.collection("shifts").document(shiftId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching completed tasks: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data(),
                  let assignedUsersData = data["assignedUsers"] as? [[String: Any]] else {
                completion(.failure(ShiftServiceError.dataParsingError))
                return
            }
            
            // Map assigned users from Firestore
            let updatedAssignedUsers = assignedUsersData.compactMap { AssignedUser.fromFirestore($0) }
            
            // Extract completed tasks for the current user
            let completedTasks = self.getCompletedTasks(for: Auth.auth().currentUser?.uid, from: updatedAssignedUsers)
            completion(.success(completedTasks))
        }
    }
    
    func fetchRoleTasks(
        role: String,
        completion: @escaping (Result<[TaskDTO], Error>) -> Void
    ) {
        db.collection("roles")
            .whereField("title", isEqualTo: role)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first,
                      let tasks = document.data()["tasks"] as? [[String: Any]] else {
                    completion(.failure(ShiftServiceError.dataParsingError))
                    return
                }
                
                let predefinedTasks = tasks.compactMap { try? TaskDTO(from: $0) }
                completion(.success(predefinedTasks))
            }
    }
    
    private func getCompletedTasks(
        for userId: String?,
        from assignedUsers: [AssignedUser]
    ) -> [Int] {
        guard let userId = userId else { return [] }
        return assignedUsers.first(where: { $0.userId == userId })?.completedTasks ?? []
    }
}

   // Define custom errors for ShiftService
enum ShiftServiceError: Error {
    case invalidShift
    case roleNotFound
    case dataParsingError
}
