// mobile/ios/Yoliva/Yoliva/YolivaApp.swift
import SwiftUI

/// Main Entry Point for the Yoliva application.
@main
struct YolivaApp: App {
    @StateObject private var sessionManager = SessionManager()
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            RootSwitcherView()
                .environmentObject(sessionManager)
                .environmentObject(router)
                .preferredColorScheme(.dark)
        }
    }
}

/// A high-level switcher that manages the root view based on AppState.
/// This prevents infinite routing loops by ensuring only one root exists at a time.
struct RootSwitcherView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        Group {
            switch session.appState {
            case .splash:
                SplashView()
            case .unauthenticated:
                NavigationStack(path: $router.path) {
                    LoginView(sessionManager: session)
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
            case .authenticated:
                NavigationStack(path: $router.path) {
                    HomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
            }
        }
        .animation(.spring(), value: session.appState)
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .login:
            LoginView(sessionManager: session)
        case .onboarding:
            SplashView()
        case .dashboard:
            HomeView()
        case .search:
            SearchRouteView()
        case .myRides:
            MyRidesView()
        case .rideDetails(let id):
            TripDetailView(trip: TripResult(id: UUID(uuidString: id) ?? UUID(), driverName: "Zeynep Y.", departureTime: Date(), fromCity: "İstanbul", toCity: "Ankara", price: 350, isLadiesOnly: false, rating: 4.9, carModel: "Tesla Model 3"))
        case .publishWizard:
            PublishTripView()
        case .profile:
            ProfileView()
        case .chat(let rideId):
            ChatDetailView(conversation: Conversation(id: UUID(uuidString: rideId) ?? UUID(), userName: "Zeynep Y.", tripRoute: "İstanbul ➔ Ankara", lastMessage: "Tamamdır, Boğa heykelinin önündeyim.", unreadCount: 0, isVerified: true, timestamp: Date()))
        case .trustCenter:
            VerificationCenterView(viewModel: ProfileViewModel())
        case .otp(let email):
            Text("OTP for \(email)")
        }
    }
}
