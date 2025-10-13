//
//  HTTPClient.swift
//  Improved Implementation
//

import Foundation

// MARK: - Network Error Types

enum NetworkError: LocalizedError {
    case invalidURL
    case unauthorized
    case serverError(statusCode: Int, message: String?)
    case decodingError(Error)
    case networkFailure(Error)
    case tokenMissing
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .unauthorized:
            return "Authentication required. Please log in again."
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message ?? "Unknown error")"
        case .decodingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .networkFailure(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .tokenMissing:
            return "Access token not found"
        }
    }
}

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

// MARK: - Logger

enum Logger {
    enum LogLevel: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    static func log(_ message: String, level: LogLevel = .info) {
        #if DEBUG
        print("[\(level.rawValue)] \(message)")
        #endif
    }
}

// MARK: - Protocols

protocol TokenStorageProtocol {
    func get(identifier: String) -> String?
    func save(token: String, identifier: String)
    func remove(identifier: String)
}

protocol HTTPClientProtocol {
    func getReports(status: String?, userId: Int?) async throws -> [ReportDTO]
    func getCategories() async throws -> [CategoryDTO]
    func createUpvote(reportId: Int) async throws -> Int
    func deleteUpvote(reportId: Int) async throws -> Int
    func getTotalUpvotes(reportId: Int) async throws -> Int
    func loginUser(email: String, password: String) async throws -> UserLoginResponse
    func registerUser(name: String, email: String, password: String) async throws -> RegisterResponse
    func getUserProfile() async throws -> UserResponse
    func updateUserProfile(name: String?, email: String?, username: String?, imagePath: String?) async throws -> UserResponse
    func uploadProfileImage(imageData: Data) async throws -> String
    func getUserPostInfo() async throws -> UserPostInfoDTO
}

// MARK: - Supporting Types

struct ErrorResponse: Decodable {
    let message: String
}

private struct UpvoteRequest: Encodable {
    let reportId: String
    
    init(reportId: Int) {
        self.reportId = String(reportId)
    }
}

private struct GetUpvotesRequest: Encodable {
    let postId: String
    
    init(reportId: Int) {
        self.postId = String(reportId)
    }
}

struct EmptyResponse: Decodable {}

// MARK: - URL Extensions

extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        guard !parameters.isEmpty else { return self }
        
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
}

// MARK: - Network Configuration

struct NetworkConfiguration {
    let timeout: TimeInterval
    let maxRetries: Int
    
    static let `default` = NetworkConfiguration(
        timeout: 30,
        maxRetries: 3
    )
}

// MARK: - HTTP Client

struct HTTPClient: HTTPClientProtocol {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let tokenStorage: TokenStorageProtocol
    private let configuration: NetworkConfiguration
    
    // MARK: - Initialization
    
    init(
        session: URLSession? = nil,
        tokenStorage: TokenStorageProtocol = TokenStorage.shared,
        configuration: NetworkConfiguration = .default
    ) {
        if let session = session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = configuration.timeout
            config.timeoutIntervalForResource = configuration.timeout * 2
            config.waitsForConnectivity = true
            self.session = URLSession(configuration: config)
        }
        
        self.tokenStorage = tokenStorage
        self.configuration = configuration
    }
    
    // MARK: - Public Methods
    
    func getReports(status: String? = nil, userId: Int? = nil) async throws -> [ReportDTO] {
        var parameters: [String: String] = [:]
        
        if let status = status {
            parameters["status_id"] = status
        }
        if let userId = userId {
            parameters["userId"] = String(userId)
        }
        
        guard let baseURL = URL(string: URLEndpoints.reports),
              let url = baseURL.appendingQueryParameters(parameters) else {
            throw NetworkError.invalidURL
        }
        
        let request = try buildRequest(
            url: url,
            method: .get
        )
        
        Logger.log("Fetching reports with parameters: \(parameters)", level: .debug)
        
        return try await performRequest(request, expecting: [ReportDTO].self)
    }
    
    func getCategories() async throws -> [CategoryDTO] {
        guard let url = URL(string: URLEndpoints.categories) else {
            throw NetworkError.invalidURL
        }
        
        let request = try buildRequest(url: url, method: .get)
        
        Logger.log("Fetching categories", level: .debug)
        
        return try await performRequest(request, expecting: [CategoryDTO].self)
    }
    
    func createUpvote(reportId: Int) async throws -> Int {
        guard let url = URL(string: URLEndpoints.upvotes) else {
            throw NetworkError.invalidURL
        }
        
        let body = UpvoteRequest(reportId: reportId)
        let request = try buildRequest(
            url: url,
            method: .post,
            body: body,
            requiresAuth: true
        )
        
        Logger.log("Creating upvote for report \(reportId)", level: .debug)
        
        let response = try await performRequest(request, expecting: UpvoteResponse.self)
        
        Logger.log("Upvote created. Total likes: \(response.likes)", level: .info)
        
        return response.likes
    }
    
    func deleteUpvote(reportId: Int) async throws -> Int {
        guard let url = URL(string: URLEndpoints.upvotes) else {
            throw NetworkError.invalidURL
        }
        
        let body = UpvoteRequest(reportId: reportId)
        let request = try buildRequest(
            url: url,
            method: .delete,
            body: body,
            requiresAuth: true
        )
        
        Logger.log("Deleting upvote for report \(reportId)", level: .debug)
        
        let response = try await performRequest(request, expecting: UpvoteResponse.self)
        
        Logger.log("Upvote deleted. Total likes: \(response.likes)", level: .info)
        
        return response.likes
    }
    
    func getTotalUpvotes(reportId: Int) async throws -> Int {
        guard let url = URL(string: URLEndpoints.upvotesTotal) else {
            throw NetworkError.invalidURL
        }
        
        let body = GetUpvotesRequest(reportId: reportId)
        let request = try buildRequest(
            url: url,
            method: .post,
            body: body,
            requiresAuth: true
        )
        
        Logger.log("Fetching total upvotes for report \(reportId)", level: .debug)
        
        return try await performRequest(request, expecting: Int.self)
    }
    
    func loginUser(email: String, password: String) async throws -> UserLoginResponse {
        guard let url = URL(string: URLEndpoints.login) else {
            throw NetworkError.invalidURL
        }
        
        let body = UserLoginRequest(email: email, password: password, type: "mobile")
        let request = try buildRequest(
            url: url,
            method: .post,
            body: body
        )
        
        Logger.log("Attempting login for user: \(email)", level: .debug)
        
        let response = try await performRequest(request, expecting: UserLoginResponse.self)
        
        Logger.log("Login successful", level: .info)
        
        return response
    }
    
    func registerUser(name: String, email: String, password: String) async throws -> RegisterResponse {
        guard let url = URL(string: URLEndpoints.register) else {
            throw NetworkError.invalidURL
        }
        
        let body = UserRequest(
            email: email,
            name: name,
            password: password,
            role_id: "1"
        )
        
        let request = try buildRequest(
            url: url,
            method: .post,
            body: body
        )
        
        Logger.log("Attempting registration for user: \(email)", level: .debug)
        
        let response = try await performRequest(request, expecting: RegisterResponse.self)
        
        Logger.log("Registration successful for user: \(response.user.name) (ID: \(response.user.id))", level: .info)
        
        return response
    }
    
    func getUserProfile() async throws -> UserResponse {
        guard let url = URL(string: URLEndpoints.users) else {
            throw NetworkError.invalidURL
        }

        let request = try buildRequest(
            url: url,
            method: .get,
            requiresAuth: true
        )

        Logger.log("Fetching user profile", level: .debug)

        return try await performRequest(request, expecting: UserResponse.self)
    }

    func getUserReports() async throws -> [ReportDTO] {
        guard let url = URL(string: URLEndpoints.userReports) else {
            throw NetworkError.invalidURL
        }

        let request = try buildRequest(
            url: url,
            method: .get,
            requiresAuth: true
        )

        Logger.log("Fetching user reports", level: .debug)

        return try await performRequest(request, expecting: [ReportDTO].self)
    }

    func updateUserProfile(name: String?, email: String?, username: String?, imagePath: String? = nil) async throws -> UserResponse {
        guard let url = URL(string: URLEndpoints.users) else {
            throw NetworkError.invalidURL
        }

        let body = UpdateUserRequest(email: email, name: name, username: username, image_path: imagePath)

        let request = try buildRequest(
            url: url,
            method: .put,
            body: body,
            requiresAuth: true
        )

        Logger.log("Updating user profile", level: .debug)

        let response = try await performRequest(request, expecting: UserResponse.self)

        Logger.log("Profile updated successfully", level: .info)

        return response
    }

    func uploadProfileImage(imageData: Data) async throws -> String {
        guard let url = URL(string: URLEndpoints.uploadProfileImage) else {
            throw NetworkError.invalidURL
        }

        let token = try requireAuthToken()

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        Logger.log("Uploading profile image", level: .debug)

        let response = try await performRequest(request, expecting: ImageUploadResponse.self)

        Logger.log("Profile image uploaded successfully: \(response.path)", level: .info)

        return response.path
    }

    func getUserPostInfo() async throws -> UserPostInfoDTO {
        guard let url = URL(string: URLEndpoints.userPostInfo) else {
            throw NetworkError.invalidURL
        }

        let request = try buildRequest(
            url: url,
            method: .get,
            requiresAuth: true
        )

        Logger.log("Fetching user post info", level: .debug)

        return try await performRequest(request, expecting: UserPostInfoDTO.self)
    }
    
    // MARK: - User Settings

    func getUserSettingsInfo() async throws -> SettingsResponseDTO {
        guard let url = URL(string: URLEndpoints.userSettingsInfo) else {
            throw NetworkError.invalidURL
        }

        let request = try buildRequest(
            url: url,
            method: .get,
            requiresAuth: true
        )

        Logger.log("Fetching user settings info", level: .debug)
        return try await performRequest(request, expecting: SettingsResponseDTO.self)
    }

    func updateUserSettingsInfo(_ settings: SettingsRequestDTO) async throws {
        guard let url = URL(string: URLEndpoints.userSettingsInfo) else {
            throw NetworkError.invalidURL
        }

        let request = try buildRequest(
            url: url,
            method: .put,
            body: settings,
            requiresAuth: true
        )

        Logger.log("Updating user settings info", level: .debug)
        _ = try await performRequest(request, expecting: EmptyResponse.self)
    }



    // MARK: - Private Methods
    
    private func buildRequest(
        url: URL,
        method: HTTPMethod,
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            let token = try requireAuthToken()
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
    
    private func requireAuthToken() throws -> String {
        guard let token = tokenStorage.get(identifier: "accessToken") else {
            Logger.log("Access token not found", level: .error)
            throw NetworkError.tokenMissing
        }
        return token
    }
    
    private func performRequest<T: Decodable>(
        _ request: URLRequest,
        expecting type: T.Type
    ) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError(statusCode: 0, message: "Invalid response type")
            }
            
            Logger.log("Response status: \(httpResponse.statusCode)", level: .debug)
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = try? JSONDecoder()
                    .decode(ErrorResponse.self, from: data)
                    .message
                
                Logger.log("Server error: \(errorMessage ?? "Unknown")", level: .error)
                
                throw NetworkError.serverError(
                    statusCode: httpResponse.statusCode,
                    message: errorMessage
                )
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            
            return result
            
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            Logger.log("Decoding error: \(error)", level: .error)
            throw NetworkError.decodingError(error)
        } catch {
            Logger.log("Network failure: \(error)", level: .error)
            throw NetworkError.networkFailure(error)
        }
    }
}

// MARK: - TokenStorage Implementation

class TokenStorage: TokenStorageProtocol {
    static let shared = TokenStorage()
    
    private init() {}
    
    func get(identifier: String) -> String? {
        // Original implementation - replace with your actual implementation
        return UserDefaults.standard.string(forKey: identifier)
    }
    
    func save(token: String, identifier: String) {
        UserDefaults.standard.set(token, forKey: identifier)
    }
    
    func remove(identifier: String) {
        UserDefaults.standard.removeObject(forKey: identifier)
    }
}
