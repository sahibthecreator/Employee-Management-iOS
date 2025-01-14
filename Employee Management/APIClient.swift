//
//  APIClient.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 26/11/2024.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = URL(string: "http://localhost:5136")!
    private var session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    func requestAsync<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        contentType: String = "form",
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Add Bearer token from Keychain if available
        if let token = KeychainService.shared.get("access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Handle parameters encoding
        if let parameters = parameters {
            if contentType == "form" {
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let formDataString = parameters.map { "\($0.key)=\($0.value)" }
                    .joined(separator: "&")
                request.httpBody = formDataString.data(using: .utf8)
            } else if contentType == "json" {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case serverError(Int)
    case invalidResponse
    case noData
    case decodingError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .networkError(let error): return error.localizedDescription
        case .serverError(let code): return "Server error: \(code)"
        case .invalidResponse: return "Invalid response from server"
        case .noData: return "No data received"
        case .decodingError(let error): return "Failed to decode response: \(error)"
        }
    }
}
