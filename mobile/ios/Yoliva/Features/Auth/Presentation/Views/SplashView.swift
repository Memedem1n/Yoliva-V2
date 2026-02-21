// mobile/ios/Yoliva/Features/Auth/Presentation/Views/SplashView.swift
import SwiftUI

/// Stunning Initial Screen with a Mesh-style Teal-to-Black gradient.
struct SplashView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var router: AppRouter
    @State private var startAnimation: Bool = false
    
    var body: some View {
        ZStack {
            // Background Mesh Gradient (Teal-to-Black)
            RadialGradient(
                colors: [AppTheme.electricTeal.opacity(0.3), AppTheme.pureBlack],
                center: .topTrailing,
                startRadius: 100,
                endRadius: 700
            )
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Animated Logo
                Image(systemName: "car.2.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.electricTeal)
                    .scaleEffect(startAnimation ? 1.0 : 0.6)
                    .opacity(startAnimation ? 1.0 : 0.0)
                    .shadow(color: AppTheme.electricTeal.opacity(0.6), radius: 20)
                
                // Animated App Name
                Text("Yoliva")
                    .font(AppTheme.Typography.title(42))
                    .foregroundColor(.white)
                    .scaleEffect(startAnimation ? 1.0 : 0.8)
                    .opacity(startAnimation ? 1.0 : 0.0)
                
                Text("Yolun Keyfini Paylaş.")
                    .font(AppTheme.Typography.body(18))
                    .foregroundColor(.white.opacity(0.6))
                    .offset(y: startAnimation ? 0 : 20)
                    .opacity(startAnimation ? 1.0 : 0.0)
            }
        }
        .onAppear {
            // Initiate animations
            withAnimation(.spring(response: 0.8, dampingFraction: 0.65, blendDuration: 0)) {
                startAnimation = true
            }
            
            // Automatic Navigation logic after splash duration (e.g., 2.5 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.spring()) {
                    if session.isAuthenticated {
                        router.navigate(to: .dashboard)
                    } else if session.isFirstTimeUser {
                        router.navigate(to: .onboarding)
                    } else {
                        router.navigate(to: .login)
                    }
                }
            }
        }
    }
}
