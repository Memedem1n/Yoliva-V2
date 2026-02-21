// mobile/ios/Yoliva/Features/Auth/Presentation/ViewModels/AuthViewModel.swift
import SwiftUI

/// AuthViewModel for handling registration and login state.
@MainActor
final class AuthViewModel: ObservableObject {
    // Shared State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var navigateToOTP: Bool = false
    
    // Login Fields
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    
    // Registration Fields
    @Published var regFirstName: String = ""
    @Published var regLastName: String = ""
    @Published var regPhone: String = ""
    @Published var regEmail: String = ""
    @Published var regPassword: String = ""
    @Published var regTermsAccepted: Bool = false
    
    // Dependencies
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    /// Executes the login logic and updates SessionManager on success.
    func login() async {
        guard !loginEmail.isEmpty && !loginPassword.isEmpty else {
            errorMessage = "Lütfen tüm alanları doldurun."
            AppTheme.haptic(.error)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Mock API Call Simulation
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        // On success: Store token and update session state
        let mockToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
        sessionManager.login(token: mockToken)
        AppTheme.haptic(.success)
        
        isLoading = false
    }
    
    /// Executes the registration logic and initiates OTP verification.
    func register() async {
        guard regTermsAccepted else {
            errorMessage = "Lütfen kullanım koşullarını kabul edin."
            AppTheme.haptic(.error)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Mock Registration API Call Simulation
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Success: Navigate to OTP verification
        navigateToOTP = true
        AppTheme.haptic(.success)
        
        isLoading = false
    }
}
