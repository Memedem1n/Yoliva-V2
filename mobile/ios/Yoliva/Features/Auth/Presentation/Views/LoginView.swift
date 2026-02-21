// mobile/ios/Yoliva/Features/Auth/Presentation/Views/LoginView.swift
import SwiftUI

/// Premium Dark Mode Login Screen for Yoliva.
struct LoginView: View {
    @StateObject private var viewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        _viewModel = StateObject(wrappedValue: AuthViewModel(sessionManager: sessionManager))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Branding Section
            VStack(spacing: 12) {
                Image(systemName: "car.2.fill") // Logo Placeholder
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.electricTeal)
                
                Text("Yoliva")
                    .font(AppTheme.Typography.title(32))
                    .foregroundColor(.white)
                
                Text("Yolun Keyfini Paylaş.")
                    .font(AppTheme.Typography.body(18))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.bottom, 40)
            
            // Login Fields
            VStack(spacing: 20) {
                CustomGlassTextField(placeholder: "E-posta Adresin", text: $viewModel.loginEmail, icon: "envelope.fill")
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                CustomGlassSecureField(placeholder: "Şifre", text: $viewModel.loginPassword)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                YolivaPrimaryButton(
                    title: "Giriş Yap",
                    isLoading: viewModel.isLoading,
                    action: {
                        Task { await viewModel.login() }
                    }
                )
            }
            .padding(.horizontal, 24)
            
            // Social Auth Divider
            HStack {
                Rectangle().fill(.white.opacity(0.1)).frame(height: 1)
                Text("veya").font(.caption).foregroundColor(.gray)
                Rectangle().fill(.white.opacity(0.1)).frame(height: 1)
            }
            .padding(.horizontal, 40)
            
            // Navigate to Register
            Button(action: {
                AppTheme.haptic(.light)
                // Navigation logic (TBD based on AppRoute)
            }) {
                HStack {
                    Text("Hesabın yok mu?")
                        .foregroundColor(AppTheme.textSecondary)
                    Text("Hemen Kaydol")
                        .foregroundColor(AppTheme.electricTeal)
                        .bold()
                }
                .font(.subheadline)
            }
            
            Spacer()
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}

// MARK: - Custom Reusable Form Fields

struct CustomGlassTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.electricTeal.opacity(0.7))
                .frame(width: 24)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.3)))
                .foregroundColor(.white)
                .font(AppTheme.Typography.body())
        }
        .padding()
        .glassCard(cornerRadius: 16)
    }
}

struct CustomGlassSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "lock.fill")
                .foregroundColor(AppTheme.electricTeal.opacity(0.7))
                .frame(width: 24)
            
            SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.3)))
                .foregroundColor(.white)
                .font(AppTheme.Typography.body())
        }
        .padding()
        .glassCard(cornerRadius: 16)
    }
}
