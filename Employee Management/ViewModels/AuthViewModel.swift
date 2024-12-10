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
    @Published var isAuthenticated: Bool = false // Default to false
    
    init() {
        // Check if an access token exists in Keychain
        if let _ = KeychainService.shared.get("access_token") {
            self.isAuthenticated = true
        }
    }
    
    func login() async {
        errorMessage = nil
        isLoading = true
        
        let parameters = ["username": email, "password": password]
        
        do {
            let response: LoginResponse = try await APIClient.shared.requestAsync(
                endpoint: "auth/login",
                method: "POST",
                parameters: parameters,
                contentType: "form",
                responseType: LoginResponse.self
            )
            
            KeychainService.shared.set(response.access_token, forKey: "access_token")
            
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch let error as APIError {
            DispatchQueue.main.async {
                self.isLoading = false
                switch error {
                case .serverError(400):
                    self.errorMessage = "Missing username or password."
                case .serverError(401):
                    self.errorMessage = "Invalid email or password."
                default:
                    self.errorMessage = "Something went wrong. Please try again."
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func logOut() {
        KeychainService.shared.remove("access_token")
        isAuthenticated = false
    }
}

struct LoginResponse: Decodable {
    let access_token: String
    let refresh_token: String
    let expires_in: Int
}
