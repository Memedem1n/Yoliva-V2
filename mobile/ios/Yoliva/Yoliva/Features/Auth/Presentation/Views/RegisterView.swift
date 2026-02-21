// mobile/ios/Yoliva/Features/Auth/Presentation/Views/RegisterView.swift
import SwiftUI

/// Premium Registration Screen with Input Fields and Terms Toggle.
struct RegisterView: View {
    @StateObject private var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    init(sessionManager: SessionManager) {
        _viewModel = StateObject(wrappedValue: AuthViewModel(sessionManager: sessionManager))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Yeni Hesap Oluştur")
                        .font(AppTheme.Typography.title(28))
                        .foregroundColor(.white)
                    Text("Yoliva topluluğuna katıl ve tasarruf etmeye başla.")
                        .font(AppTheme.Typography.body(16))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                
                // Form Section
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        CustomGlassTextField(placeholder: "Ad", text: $viewModel.regFirstName, icon: "person.fill")
                        CustomGlassTextField(placeholder: "Soyad", text: $viewModel.regLastName, icon: "person.fill")
                    }
                    
                    CustomGlassTextField(placeholder: "Telefon", text: $viewModel.regPhone, icon: "phone.fill")
                        .keyboardType(.phonePad)
                    
                    CustomGlassTextField(placeholder: "E-posta", text: $viewModel.regEmail, icon: "envelope.fill")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    CustomGlassSecureField(placeholder: "Şifre", text: $viewModel.regPassword)
                    
                    // Terms & Conditions Toggle
                    Toggle(isOn: $viewModel.regTermsAccepted) {
                        HStack(spacing: 4) {
                            Text("Kullanım koşullarını")
                                .foregroundColor(AppTheme.textSecondary)
                            Text("Kabul Ediyorum")
                                .foregroundColor(AppTheme.primary)
                                .bold()
                        }
                        .font(.caption)
                    }
                    .tint(AppTheme.primary)
                    .padding(.horizontal, 10)
                }
                .padding(.horizontal, 24)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                // Submit Button
                YolivaPrimaryButton(
                    title: "Kaydol",
                    isLoading: viewModel.isLoading,
                    action: {
                        Task { await viewModel.register() }
                    }
                )
                .padding(.horizontal, 24)
                
                // Navigation to Login
                Button("Zaten hesabın var mı? Giriş yap") {
                    dismiss()
                }
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}
