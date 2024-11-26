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
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        contentType: String? = "form",
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Add headers (including Bearer Token if available)
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Handle parameters encoding
        if let parameters = parameters {
            if contentType == "form" {
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                // Encode parameters as form-data
                let formDataString = parameters.map { "\($0.key)=\($0.value)" }
                    .joined(separator: "&")
                request.httpBody = formDataString.data(using: .utf8)
            } else if contentType == "json" {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                // Encode parameters as JSON
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        
        // Perform network request
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
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
