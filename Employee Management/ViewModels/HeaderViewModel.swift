//
//  HeaderViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 08/01/2025.
//

import Foundation
import Combine


class HeaderViewModel: ObservableObject {
    @Published var fullName: String = "Loading..."
    @Published var greeting: String = "Good Morning"
    @Published var currentDate: String = ""
    @Published var initials: String = ""
    
    private var userService = UserService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchUserData()
        updateGreeting()
        formatCurrentDate()
    }
    
    private func fetchUserData() {
        userService.getCurrentUser { [weak self] user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.fullName = user.fullName
                    self?.initials = user.initials
                } else {
                    self?.fullName = "User"
                    self?.initials = "??"
                }
            }
        }
    }
    
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            greeting = "Good Morning"
        case 12..<18:
            greeting = "Good Afternoon"
        case 18..<22:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }
    }
    
    private func formatCurrentDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, EEEE"
        currentDate = formatter.string(from: Date())
    }
}
