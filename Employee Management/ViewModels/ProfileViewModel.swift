//
//  ProfileViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 08/01/2025.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var user: UserDTO?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var totalHoursWorked: Double = 0.0
    
    private var userService = UserService()
    private var cancellables = Set<AnyCancellable>()
    
    private var db = Firestore.firestore()

    
    init() {
        fetchUserData()
        calculateTotalHoursWorked()
    }
    
    func fetchUserData() {
        print("---")
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not authenticated."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        userService.getUserById(userId: userId) { [weak self] user in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let user = user {
                    self?.user = user
                } else {
                    self?.errorMessage = "Failed to load user data."
                }
            }
        }
    }
    
    func calculateTotalHoursWorked() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not authenticated."
            return
        }
        
        let startOfMonth = Calendar.current.dateInterval(of: .month, for: Date())!.start
        let endOfMonth = Calendar.current.dateInterval(of: .month, for: Date())!.end
        
        db.collection("shifts")
            .whereField("assignedUserIds", arrayContains: userId)
            .whereField("startTime", isGreaterThanOrEqualTo: Timestamp(date: startOfMonth))
            .whereField("startTime", isLessThanOrEqualTo: Timestamp(date: endOfMonth))
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = "Failed to fetch shifts: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    let totalHours = documents.compactMap { doc -> Double? in
                        let data = doc.data()
                        guard let startTime = (data["startTime"] as? Timestamp)?.dateValue(),
                              let endTime = (data["endTime"] as? Timestamp)?.dateValue() else {
                            return nil
                        }
                        let hoursWorked = endTime.timeIntervalSince(startTime) / 3600  // Convert to hours
                        return hoursWorked
                    }.reduce(0, +)
                    
                    self?.totalHoursWorked = totalHours
                }
            }
    }
}

