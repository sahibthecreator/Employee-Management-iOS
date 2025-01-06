//
//  LoginViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 15/11/2024.
//
import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false
    
    private let clientID = "karma-kebab-client"
    private let audience = "karma-kebab-client"
    private let scope = "openid profile email"
    private let baseURL = URL(string: "http://localhost:8080")
    private let authEndpoint = "realms/karma-kebab-realm/protocol/openid-connect/token"
    
    init() {
        if let _ = KeychainService.shared.get("access_token") {
            self.isAuthenticated = true
        }
    }
    
    func login() async {
        errorMessage = nil
        isLoading = true
        
        let parameters: [String: Any] = [
            "grant_type": "password",
            "username": username,
            "password": password,
            "audience": audience,
            "scope": scope
        ]
        
        let basicAuthHeader = basicAuth(username: "karma-kebab-client", password: "karma-kebab-client-secret")
        
        do {
            let response: LoginResponse = try await APIClient.shared.requestAsync(
                endpoint: authEndpoint,
                method: "POST",
                parameters: parameters,
                contentType: "form",
                responseType: LoginResponse.self,
                headers: ["Authorization": basicAuthHeader],
                baseURL: baseURL
            )
            print(response)
            // Save tokens securely in Keychain
            KeychainService.shared.set(response.access_token, forKey: "access_token")
            KeychainService.shared.set(response.refresh_token, forKey: "refresh_token")
            
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch let error as APIError {
            handleAPIError(error)
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func logOut() {
        KeychainService.shared.remove("access_token")
        KeychainService.shared.remove("refresh_token")
        isAuthenticated = false
    }
    
    private func handleAPIError(_ error: APIError) {
        DispatchQueue.main.async {
            self.isLoading = false
            switch error {
            case .serverError(400):
                self.errorMessage = "Missing username or password."
            case .serverError(401):
                self.errorMessage = "Invalid credentials. Please check your email and password."
            case .serverError(403):
                self.errorMessage = "Access denied. Please contact admin."
            default:
                self.errorMessage = "Something went wrong. Please try again."
            }
        }
    }
    
    private func basicAuth(username: String, password: String) -> String {
        let credentials = "\(username):\(password)"
        guard let data = credentials.data(using: .utf8) else {
            return ""
        }
        let base64Credentials = data.base64EncodedString()
        return "Basic \(base64Credentials)"
    }
}


struct LoginResponse: Decodable {
    let access_token: String
    let refresh_token: String
}
