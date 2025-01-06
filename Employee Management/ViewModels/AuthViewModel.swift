//
//  LoginViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 15/11/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    // Published properties to reactively update UI
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        // Set up an auth state listener to track user's authentication state
        self.authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.isAuthenticated = user != nil
        }
    }
    
    deinit {
        // Remove auth state listener to avoid memory leaks
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // Function to sign in with email and password
    func signIn() {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print(error)
                    self.errorMessage = error.localizedDescription
                } else {
                    self.isAuthenticated = true
                }
            }
        }
    }
    
    // Function to log out the user
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

//class AuthViewModel: ObservableObject {
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//    @Published var isAuthenticated: Bool = false // Default to false
//    
//    init() {
//        // Check if an access token exists in Keychain
//        if let _ = KeychainService.shared.get("access_token") {
//            self.isAuthenticated = true
//        }
//    }
//    
//    func login() async {
//        errorMessage = nil
//        isLoading = true
//        
//        let parameters = ["username": email, "password": password]
//        
//        do {
//            let response: LoginResponse = try await APIClient.shared.requestAsync(
//                endpoint: "auth/login",
//                method: "POST",
//                parameters: parameters,
//                contentType: "form",
//                responseType: LoginResponse.self
//            )
//            
//            KeychainService.shared.set(response.access_token, forKey: "access_token")
//            
//            DispatchQueue.main.async {
//                self.isAuthenticated = true
//                self.isLoading = false
//            }
//        } catch let error as APIError {
//            DispatchQueue.main.async {
//                self.isLoading = false
//                switch error {
//                case .serverError(400):
//                    self.errorMessage = "Missing username or password."
//                case .serverError(401):
//                    self.errorMessage = "Invalid email or password."
//                default:
//                    self.errorMessage = "Something went wrong. Please try again."
//                }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.isLoading = false
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//    
//    func logOut() {
//        KeychainService.shared.remove("access_token")
//        isAuthenticated = false
//    }
//}
//
//struct LoginResponse: Decodable {
//    let access_token: String
//    let refresh_token: String
//    let expires_in: Int
//}
