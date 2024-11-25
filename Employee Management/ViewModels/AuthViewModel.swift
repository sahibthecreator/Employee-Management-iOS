//
//  LoginViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 15/11/2024.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = true

    func login() {
        // Reset previous error state
        errorMessage = nil
        isLoading = true

        // Mock login delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false

            // Simple validation for testing
            if self.email.lowercased() == "test" && self.password == "test" {
                self.isAuthenticated = true
            } else {
                self.errorMessage = "Invalid email or password."
            }
        }
    }
    
    func logOut() {
        self.isAuthenticated = false
    }
}
