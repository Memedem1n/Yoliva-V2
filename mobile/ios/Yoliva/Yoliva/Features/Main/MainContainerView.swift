// mobile/ios/Yoliva/Yoliva/Features/Main/MainContainerView.swift
import SwiftUI

/// The primary shell of the application after login, managing tab navigation and content.
struct MainContainerView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var router: AppRouter
    @State private var selectedTab: YolivaTab = .search
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottom) {
                // Content Layer
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
                
                // Premium Tab Bar (Floating)
                PremiumTabView(selection: $selectedTab)
            }
            .edgesIgnoringSafeArea(.bottom)
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
