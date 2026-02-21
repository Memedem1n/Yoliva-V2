// mobile/ios/Yoliva/YolivaApp.swift
import SwiftUI

/// Main Entry Point for the Yoliva application.
/// Initializes the core infrastructure (SessionManager, AppRouter) and injects them as environment objects.
@main
struct YolivaApp: App {
    // Session state across the app lifecycle
    @StateObject private var sessionManager = SessionManager()
    
    // Centralized navigation state for the NavigationStack
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(sessionManager)
                .environmentObject(router)
                .preferredColorScheme(.dark) // Yoliva defaults to Dark Mode
        }
    }
}

/// A simplified AppRootView that manages the top-level switching between Auth and Dashboard.
/// In a real scenario, this would be defined in Core/Navigation/AppRootView.swift.
struct AppRootView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Navigation Logic
                if session.isAuthenticated {
                    // Main application dashboard after login
                    Text("Ana Ekran (Dashboard)")
                        .foregroundColor(.white)
                } else if session.isFirstTimeUser {
                    // Initial welcome/onboarding screens
                    Text("Hoş Geldiniz (Onboarding)")
                        .foregroundColor(.white)
                } else {
                    // Standard login flow
                    Text("Giriş Yap (Login)")
                        .foregroundColor(.white)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                // Global routing logic based on AppRoute enum
                switch route {
                case .login:
                    Text("Login View Placeholder")
                case .onboarding:
                    Text("Onboarding View Placeholder")
                case .dashboard:
                    Text("Dashboard View Placeholder")
                case .rideDetails(let id):
                    Text("Ride Detail #\(id)")
                default:
                    Text("Rota: \(String(describing: route))")
                }
            }
        }
    }
}
