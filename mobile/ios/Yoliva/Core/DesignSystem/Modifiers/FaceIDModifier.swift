// mobile/ios/Yoliva/Core/DesignSystem/Modifiers/FaceIDModifier.swift
import SwiftUI

/// A ViewModifier that simulates a Face ID authentication scan.
struct FaceIDAuthModifier: ViewModifier {
    @Binding var isAuthenticating: Bool
    var onAuthenticated: () -> Void
    
    @State private var showIcon: Bool = false
    @State private var isScanning: Bool = false
    @State private var isSuccess: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isAuthenticating {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 30) {
                    Image(systemName: isSuccess ? "faceid" : "faceid")
                        .font(.system(size: 80))
                        .foregroundColor(isSuccess ? AppTheme.electricTeal : .white)
                        .scaleEffect(showIcon ? 1.0 : 0.5)
                        .opacity(showIcon ? 1.0 : 0.0)
                        .overlay(
                            Circle()
                                .stroke(AppTheme.electricTeal.opacity(isScanning ? 0.6 : 0), lineWidth: 4)
                                .scaleEffect(isScanning ? 1.5 : 1.0)
                                .opacity(isScanning ? 0 : 1)
                        )
                    
                    Text(isSuccess ? "Kimlik Doğrulandı" : "Face ID taranıyor...")
                        .font(AppTheme.Typography.title(20))
                        .foregroundColor(.white)
                }
                .onAppear {
                    AppTheme.haptic(.medium)
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showIcon = true
                    }
                    
                    // Simulate Scan
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                        isScanning = true
                    }
                    
                    // Success logic
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        AppTheme.haptic(.success)
                        withAnimation {
                            isScanning = false
                            isSuccess = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation {
                                isAuthenticating = false
                            }
                            onAuthenticated()
                        }
                    }
                }
            }
        }
    }
}

extension View {
    /// Protects a view with a simulated Face ID authentication scan.
    func faceIDProtected(isAuthenticating: Binding<Bool>, onAuthenticated: @escaping () -> Void) -> some View {
        self.modifier(FaceIDAuthModifier(isAuthenticating: isAuthenticating, onAuthenticated: onAuthenticated))
    }
}
