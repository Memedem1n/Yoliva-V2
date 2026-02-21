// mobile/ios/Yoliva/Core/State/SessionManager.swift
import SwiftUI

/// Main Authentication and User Session Manager for Yoliva.
@MainActor
final class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isFirstTimeUser: Bool = true
    
    // Key for identifying the authentication token in Keychain
    private let tokenKey = "auth_token"
    
    init() {
        checkAuthentication()
    }
    
    /// Synchronize the application's authentication status with the Keychain state.
    func checkAuthentication() {
        let token = KeychainManager.shared.retrieve(for: tokenKey)
        self.isAuthenticated = token != nil
        
        // Check if the user has completed onboarding before (UserDefaults is fine for this UI state)
        self.isFirstTimeUser = !UserDefaults.standard.bool(forKey: "has_completed_onboarding")
    }
    
    /// Log in the user by storing their session token and updating the state.
    /// - Parameter token: The JWT token received from the backend.
    func login(token: String) {
        KeychainManager.shared.save(token, for: tokenKey)
        self.isAuthenticated = true
    }
    
    /// Log out the user by clearing the session token and resetting the state.
    func logout() {
        KeychainManager.shared.delete(for: tokenKey)
        self.isAuthenticated = false
    }
    
    /// Mark onboarding as completed.
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
        self.isFirstTimeUser = false
    }
}
