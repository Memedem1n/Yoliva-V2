// mobile/ios/Yoliva/Core/Network/NetworkManager.swift
import Foundation

/// Custom Error enum for Network requests.
enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case unauthorized // 401
    case decodingError(Error)
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Geçersiz URL adresi."
        case .requestFailed(let error): return "İstek başarısız: \(error.localizedDescription)"
        case .invalidResponse: return "Sunucudan geçersiz yanıt alındı."
        case .unauthorized: return "Oturum süresi doldu, lütfen tekrar giriş yapın."
        case .decodingError: return "Veri işleme hatası oluştu."
        case .serverError(let message): return message
        }
    }
}

/// Generic Network Manager using async/await and native URLSession.
final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: configuration)
    }
    
    /// Generic request method to handle API calls.
    /// - Parameters:
    ///   - request: The URLRequest to execute.
    /// - Returns: A decoded object of type T.
    func request<T: Decodable>(_ request: URLRequest) async throws -> T {
        var authenticatedRequest = request
        
        // JWT Interceptor Logic: Automatically inject the token if it exists in Keychain
        if let token = KeychainManager.shared.retrieve(for: "auth_token") {
            authenticatedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Perform the data task
        let (data, response) = try await session.data(for: authenticatedRequest)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Handle HTTP Status Codes
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Standard for NestJS
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        case 401:
            // Notify SessionManager or clear local state
            throw APIError.unauthorized
        default:
            // Attempt to parse error message from server if any
            let errorMessage = String(data: data, encoding: .utf8) ?? "Bilinmeyen bir hata oluştu."
            throw APIError.serverError(errorMessage)
        }
    }
}
