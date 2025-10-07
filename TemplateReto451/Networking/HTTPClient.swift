//
//  HTTPClient.swift
//  TemplateReto451
//
//  Created by José Molina on 02/09/25.
//

import Foundation

struct HTTPClient {
    func getReports(status: String? = nil, userId: Int? = nil) async throws -> [ReportDTO] {
        var urlString = URLEndpoints.reports

        var queryItems: [String] = []
        if let status = status {
            queryItems.append("status_id=\(status)")
        }
        if let userId = userId {
            queryItems.append("userId=\(userId)")
        }
        if !queryItems.isEmpty {
            urlString += "?" + queryItems.joined(separator: "&")
        }

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let reports = try JSONDecoder().decode([ReportDTO].self, from: data)
        return reports
    }

    func getCategories() async throws -> [CategoryDTO] {
        guard let url = URL(string: URLEndpoints.categories) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let categories = try JSONDecoder().decode([CategoryDTO].self, from: data)
        return categories
    }

    func createUpvote(reportId: Int) async throws -> Int {
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            print("❌ No access token found")
            throw URLError(.userAuthenticationRequired)
        }

        guard let url = URL(string: URLEndpoints.upvotes) else {
            print("❌ Invalid URL: \(URLEndpoints.upvotes)")
            throw URLError(.badURL)
        }

        print("📡 POST \(url.absoluteString)")
        print("🔑 Using Bearer token: \(String(token.prefix(20)))...")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = ["reportId": "\(reportId)"]
        request.httpBody = try JSONEncoder().encode(body)
        print("📦 Request body: \(body)")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid response type")
            throw URLError(.badServerResponse)
        }

        print("📥 Response status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("❌ Server error response: \(errorString)")
            }
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(UpvoteResponse.self, from: data)
        print("✅ Decoded response - likes: \(result.likes)")
        return result.likes
    }

    func deleteUpvote(reportId: Int) async throws -> Int {
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            print("❌ No access token found")
            throw URLError(.userAuthenticationRequired)
        }

        guard let url = URL(string: URLEndpoints.upvotes) else {
            print("❌ Invalid URL: \(URLEndpoints.upvotes)")
            throw URLError(.badURL)
        }

        print("📡 DELETE \(url.absoluteString)")
        print("🔑 Using Bearer token: \(String(token.prefix(20)))...")

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = ["reportId": "\(reportId)"]
        request.httpBody = try JSONEncoder().encode(body)
        print("📦 Request body: \(body)")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid response type")
            throw URLError(.badServerResponse)
        }

        print("📥 Response status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("❌ Server error response: \(errorString)")
            }
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(UpvoteResponse.self, from: data)
        print("✅ Decoded response - likes: \(result.likes)")
        return result.likes
    }

    func getTotalUpvotes(reportId: Int) async throws -> Int {
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }

        guard let url = URL(string: URLEndpoints.upvotesTotal) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = ["postId": "\(reportId)"]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let count = try JSONDecoder().decode(Int.self, from: data)
        return count
    }

    func loginUser(email: String, password: String) async throws -> UserLoginResponse{
        let userLoginRequest = UserLoginRequest(email: email, password: password)
        let jsonData = try JSONEncoder().encode(userLoginRequest)
        let url = URL(string: URLEndpoints.login)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        let userLoginResponse =  try JSONDecoder().decode(UserLoginResponse.self, from: data)
        return userLoginResponse
        
    }
    func registerUser(name: String, email: String, password: String) async throws -> RegisterResponse {
        let dataRequest = UserRequest(email: email, name: name, password: password, role_id: "1")
        let jsonData = try JSONEncoder().encode(dataRequest)
        let url = URL(string: URLEndpoints.register)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        print("📡 POST \(url.absoluteString)")
        print("📦 Request body: \(String(data: jsonData, encoding: .utf8) ?? "")")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid response type")
            throw URLError(.badServerResponse)
        }

        print("📥 Response status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("❌ Server error response: \(errorString)")

                // Try to parse error message from backend
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = errorJson["message"] as? String {
                    throw NSError(domain: "Registration", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                }
            }
            throw URLError(.badServerResponse)
        }

        let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
        print("✅ User registered successfully: \(registerResponse.user.name) with ID: \(registerResponse.user.id)")
        return registerResponse
    }
}
