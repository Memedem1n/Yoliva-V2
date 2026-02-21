// mobile/ios/Yoliva/Core/Navigation/AppRouter.swift
import SwiftUI

/// Central navigation system for Yoliva using NavigationStack.
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    /// Navigates to a specific route by appending it to the path.
    /// - Parameter route: The route to navigate to.
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    /// Pops the last route from the path.
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// Clears the navigation path and returns to the root view.
    func popToRoot() {
        path.removeLast(path.count)
    }
}

/// A hashable enum representing all potential routes in the application.
enum AppRoute: Hashable {
    case onboarding
    case login
    case otp(email: String)
    case dashboard
    case rideDetails(id: String)
    case publishWizard
    case profile
    case chat(rideId: String)
    case trustCenter
    
    // Example: Sub-routing for the Dashboard's tabs if needed
    enum Tab: Int, CaseIterable {
        case search, publish, rides, inbox, profile
    }
}
