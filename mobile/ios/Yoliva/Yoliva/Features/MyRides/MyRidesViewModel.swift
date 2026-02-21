// mobile/ios/Yoliva/Features/MyRides/MyRidesViewModel.swift
import SwiftUI

/// Simple model for a ride in the "My Rides" list.
struct UserRide: Identifiable {
    let id: UUID
    let fromCity: String
    let toCity: String
    let date: Date
    let driverName: String
    let price: Double
    let pnr: String
    let status: RideStatus
}

enum RideStatus {
    case upcoming, past
}

/// ViewModel managing state for "Upcoming" and "Past" rides.
@MainActor
final class MyRidesViewModel: ObservableObject {
    @Published var selectedTab: RideStatus = .upcoming
    @Published var upcomingRides: [UserRide] = []
    @Published var pastRides: [UserRide] = []
    @Published var isLoading: Bool = false
    
    // For QR Sheet
    @Published var selectedRideForQR: UserRide? = nil
    @Published var isShowingQR: Bool = false
    
    init() {
        fetchRides()
    }
    
    /// Fetches mock data for upcoming and past rides.
    func fetchRides() {
        isLoading = true
        
        // Mocking Data
        self.upcomingRides = [
            UserRide(id: UUID(), fromCity: "İstanbul", toCity: "Ankara", date: Date().addingTimeInterval(86400), driverName: "Zeynep Y.", price: 350.0, pnr: "YLV-9281", status: .upcoming),
            UserRide(id: UUID(), fromCity: "Bursa", toCity: "İzmir", date: Date().addingTimeInterval(172800), driverName: "Caner T.", price: 280.0, pnr: "YLV-1024", status: .upcoming)
        ]
        
        self.pastRides = [
            UserRide(id: UUID(), fromCity: "Ankara", toCity: "İstanbul", date: Date().addingTimeInterval(-86400 * 5), driverName: "Merve G.", price: 320.0, pnr: "YLV-0042", status: .past)
        ]
        
        isLoading = false
    }
}
