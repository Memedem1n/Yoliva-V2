// mobile/ios/Yoliva/Yoliva/YolivaApp.swift
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
struct AppRootView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                // Navigation Logic
                if session.isAuthenticated {
                    // Main application dashboard after login
                    HomeView()
                } else if session.isFirstTimeUser {
                    // Initial welcome/onboarding screens
                    SplashView()
                } else {
                    // Standard login flow
                    LoginView(sessionManager: session)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                // Global routing logic based on AppRoute enum
                switch route {
                case .login:
                    LoginView(sessionManager: session)
                case .onboarding:
                    SplashView() // Or OnboardingView if implemented
                case .dashboard:
                    HomeView()
                case .search:
                    SearchRouteView()
                case .myRides:
                    MyRidesView()
                case .rideDetails(let id):
                    // In a real app, we'd fetch the trip by ID
                    TripDetailView(trip: TripResult(id: UUID(uuidString: id) ?? UUID(), driverName: "Zeynep Y.", departureTime: Date(), fromCity: "İstanbul", toCity: "Ankara", price: 350, isLadiesOnly: false, rating: 4.9, carModel: "Tesla Model 3"))
                case .publishWizard:
                    PublishTripView()
                case .profile:
                    ProfileView()
                case .chat(let rideId):
                    // Mocking a conversation for the view based on the ID
                    ChatDetailView(conversation: Conversation(id: UUID(uuidString: rideId) ?? UUID(), userName: "Zeynep Y.", tripRoute: "İstanbul ➔ Ankara", lastMessage: "Tamamdır, Boğa heykelinin önündeyim.", unreadCount: 0, isVerified: true, timestamp: Date()))
                case .trustCenter:
                    // Navigate to Verification Center through Profile or directly
                    VerificationCenterView(viewModel: ProfileViewModel())
                case .otp(let email):
                    Text("OTP for \(email)") // OTPView placeholder
                }
            }
        }
    }
}
