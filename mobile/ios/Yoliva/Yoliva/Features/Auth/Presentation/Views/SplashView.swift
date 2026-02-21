// mobile/ios/Yoliva/Features/Auth/Presentation/Views/SplashView.swift
import SwiftUI

/// Stunning Initial Screen with a Mesh-style Teal-to-Black gradient.
struct SplashView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var router: AppRouter
    @State private var startAnimation: Bool = false
    
    var body: some View {
        ZStack {
            // Background Mesh Gradient (Primary Blue to Deep Navy)
            RadialGradient(
                colors: [AppTheme.primary.opacity(0.4), AppTheme.secondary],
                center: .topTrailing,
                startRadius: 100,
                endRadius: 800
            )
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Animated Logo
                Image("Logo") // Custom Asset with integrated colors
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(startAnimation ? 1.0 : 0.6)
                    .opacity(startAnimation ? 1.0 : 0.0)
                    .shadow(color: AppTheme.primary.opacity(0.6), radius: 20)
                
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
