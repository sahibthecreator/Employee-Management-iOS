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
    @Published var isAuthenticated: Bool = false
    
    init() {
        if let _ = UserDefaults.standard.string(forKey: "access_token") {
            self.isAuthenticated = true
        }
    }
    
    func login() {
        errorMessage = nil
        isLoading = true
        
        let parameters = ["username": email, "password": password]
        
        APIClient.shared.request(
            endpoint: "auth/login",
            method: "POST",
            parameters: parameters,
            headers: nil,
            contentType: "form",
            responseType: LoginResponse.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    // Save the token and authenticate the user
                    UserDefaults.standard.set(response.access_token, forKey: "access_token")
                    self?.isAuthenticated = true
                    
                case .failure(let error):
                    switch error {
                    case .serverError(400):
                        self?.errorMessage = "Missing username or password."
                    case .serverError(401):
                        self?.errorMessage = "Invalid email or password."
                    default:
                        print(error)
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "access_token")
        isAuthenticated = false
    }
}

struct LoginResponse: Decodable {
    let access_token: String
    let refresh_token: String
    let expires_in: Int
}
