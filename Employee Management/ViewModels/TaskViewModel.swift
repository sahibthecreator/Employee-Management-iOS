//
//  TaskViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 09/01/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskDTO] = []
    @Published var completedCount: Int = 0
    @Published var showClockInAlert = false
    @Published var showClockOutAlert = false
    @Published var isUploadingImage = false
    private var completedTaskIds: Set<Int> = []
    private var db = Firestore.firestore()
    var shift: ShiftDTO
    
    var progress: Double {
        tasks.isEmpty ? 0 : Double(completedCount) / Double(tasks.count)
    }
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    init(shift: ShiftDTO) {
        self.shift = shift
        loadTasks(for: shift)
    }
    
    func clockIn() {
        updateAssignedUserField(
            field: "clockInTime",
            value: Timestamp(date: Date())
        )
    }

    func clockOut() {
        updateAssignedUserField(
            field: "clockOutTime",
            value: Timestamp(date: Date())
        )
    }
    
    private func updateAssignedUserField(field: String, value: Any) {
        guard let shiftId = shift.id else { return }
        var currentTasks: [Int] = []
        // Prepare the updated assignedUsers array for Firestore
        let updatedUsers = shift.assignedUsers.map { user -> [String: Any] in
            var userDict = user.toDictionary()
            if user.userId == currentUserId {
                if field == "completedTasks", let taskId = value as? Int {
                    // Append taskId to completedTasks if it doesn't already exist
                    currentTasks = userDict["completedTasks"] as? [Int] ?? []
                    if !currentTasks.contains(taskId) {
                        currentTasks.append(taskId)
                    }
                    userDict["completedTasks"] = currentTasks
                } else {
                    userDict[field] = value
                }
            }
            return userDict
        }
        
        // Update Firestore
        db.collection("shifts").document(shiftId).updateData(["assignedUsers": updatedUsers]) { [weak self] error in
            if let error = error {
                print("Error updating \(field): \(error)")
            } else {
                print("\(field) updated successfully.")
                
                // Update the local shift object
                DispatchQueue.main.async {
                    if let index = self?.shift.assignedUsers.firstIndex(where: { $0.userId == self?.currentUserId }) {
                        switch field {
                        case "clockInTime":
                            if let timestamp = value as? Timestamp {
                                self?.shift.assignedUsers[index].clockInTime = timestamp.dateValue()
                            }
                        case "clockOutTime":
                            if let timestamp = value as? Timestamp {
                                self?.shift.assignedUsers[index].clockOutTime = timestamp.dateValue()
                            }
                        case "completedTasks":
                            self?.shift.assignedUsers[index].completedTasks = currentTasks
                            if let index = self?.tasks.firstIndex(where: { $0.id == value as? Int }) {
                                self?.tasks[index].isDone = true
                            }
                            
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    func loadTasks(for shift: ShiftDTO) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        // Find the role of the logged-in user in assignedUsers
        guard let currentUserRole = shift.assignedUsers.first(where: { $0.userId == currentUserId })?.role else {
            print("Role not found for current user.")
            return
        }
        
        // Fetch tasks for the role
        fetchRoleTasks(role: currentUserRole) { [weak self] predefinedTasks in
            self?.fetchCompletedTasks(for: shift) { completedIds in
                DispatchQueue.main.async {
                    var allTasks = predefinedTasks.map { task in
                        var updatedTask = task
                        updatedTask.isDone = completedIds.contains(task.id)
                        return updatedTask
                    }
                    
                    self?.tasks = allTasks
                    self?.completedCount = allTasks.filter { $0.isDone }.count
                }
            }
        }
    }
    
    func markTaskAsDone(at index: Int, with image: UIImage? = nil) {
        guard !tasks[index].isDone else { return }
        
        if let image = image, tasks[index].requiresImage {
            isUploadingImage = true
//            completeTaskWithImage(taskId: tasks[index].id, image: image)
            completeTaskWithImage(taskId: tasks[index].id, image: image) { [weak self] success in
                DispatchQueue.main.async {
                    self?.isUploadingImage = false
                    if success {
                        self?.tasks[index].isDone = true
                        self?.completedCount += 1
                    }
                }
            }
        } else {
            updateAssignedUsers(taskId: tasks[index].id) { [weak self] success in
                if success {
                    self?.tasks[index].isDone = true
                    self?.completedCount += 1
                }
            }
        }
    }
    
    private func fetchRoleTasks(role: String, completion: @escaping ([TaskDTO]) -> Void) {
        db.collection("roles")
            .whereField("title", isEqualTo: role) // Match the role title
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching role tasks: \(error)")
                    completion([])
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No role found matching the title: \(role)")
                    completion([])
                    return
                }
                
                if let tasks = document.data()["tasks"] as? [[String: Any]] {
                    let predefinedTasks = tasks.compactMap { try? TaskDTO(from: $0) }
                    completion(predefinedTasks)
                } else {
                    print("No tasks found for role: \(role)")
                    completion([])
                }
            }
    }
    
    private func fetchCompletedTasks(for shift: ShiftDTO, completion: @escaping ([Int]) -> Void) {
        guard let shiftId = shift.id else {
            completion([])
            return
        }
        
        db.collection("shifts").document(shiftId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching completed tasks: \(error)")
                completion([])
                return
            }
            
            guard let data = snapshot?.data(),
                  let assignedUsersData = data["assignedUsers"] as? [[String: Any]] else {
                completion([])
                return
            }
            
            // Update the local shift object
            let updatedAssignedUsers = assignedUsersData.compactMap { AssignedUser.fromFirestore($0) }
            DispatchQueue.main.async {
                self.shift.assignedUsers = updatedAssignedUsers
            }
            
            // Extract the current user's completed tasks
            let completedTasks = self.getCompletedTasks(for: Auth.auth().currentUser?.uid, from: updatedAssignedUsers)
            completion(completedTasks)
        }
        
    }
    
    private func getCompletedTasks(for userId: String?, from assignedUsers: [AssignedUser]) -> [Int] {
        guard let userId = userId else { return [] }
        return assignedUsers.first(where: { $0.userId == userId })?.completedTasks ?? []
    }
    
    private func updateAssignedUsers(taskId: Int, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        guard let shiftId = shift.id else {
            completion(false)
            return
        }
        
        var updatedAssignedUsers = shift.assignedUsers
        
        // find the current user's record
        if let index = updatedAssignedUsers.firstIndex(where: { $0.userId == currentUser.uid }) {
            var user = updatedAssignedUsers[index]
            var completedTasks = user.completedTasks ?? []
            
            // update the completedTasks array if the task isn't already marked as done
            completedTasks.append(taskId)
            user.completedTasks = completedTasks
            updatedAssignedUsers[index] = user
            print("----TASK ID----")
            print(taskId)
            // update with the modified assignedUsers array
            db.collection("shifts").document(shiftId).updateData([
                "assignedUsers": updatedAssignedUsers.map { $0.toDictionary() }
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Task \(taskId) saved successfully.")
                    self.shift.assignedUsers = updatedAssignedUsers
                    completion(true)
                }
            }
        } else {
            print("User not found in assignedUsers")
            completion(false)
        }
    }
    
    private func completeTaskWithImage(taskId: Int, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let shiftId = shift.id else { return }
        
        // Convert image to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        // Create a reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("task_images/\(shiftId)/\(currentUser.uid)_\(taskId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Image uploaded successfully, now mark the task as done in Firestore
            self?.updateAssignedUserField(field: "completedTasks", value: taskId)
            completion(true)
        }
    }
}
