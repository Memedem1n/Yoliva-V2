// mobile/ios/Yoliva/Core/DesignSystem/Components/YolivaInputs.swift
import SwiftUI

/// Premium Dark Mode Glassmorphic Text Field for forms.
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

/// Secure version of the Glassmorphic Text Field for sensitive info.
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
