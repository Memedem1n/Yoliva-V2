// mobile/ios/Yoliva/Yoliva/Features/Main/MainContainerView.swift
import SwiftUI

/// The primary shell of the application, managing tab navigation and content visibility.
struct MainContainerView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var router: AppRouter
    @State private var selectedTab: YolivaTab = .search
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottom) {
                // 1. Living Background (Consistent throughout the shell)
                MeshBackgroundView()
                    .ignoresSafeArea()
                
                // 2. Content Layer
                Group {
                    switch selectedTab {
                    case .search:
                        SearchRouteView()
                    case .publish:
                        PublishTripView()
                    case .rides:
                        MyRidesView()
                    case .inbox:
                        InboxListView()
                    case .profile:
                        ProfileView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                .animation(.easeOut(duration: 0.2), value: selectedTab)
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
                
                // 3. Premium Tab Bar (Floating with Ripple & Burst)
                PremiumTabView(selection: $selectedTab)
            }
            // Ensure content doesn't hide behind the tab bar
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80) 
            }
            .background(AppTheme.background) // Fixes any gray background bleeding
            .ignoresSafeArea(.keyboard) // Responsive keyboard handling
        }
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
