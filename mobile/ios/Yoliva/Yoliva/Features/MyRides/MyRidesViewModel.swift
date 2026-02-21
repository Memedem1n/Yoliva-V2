// mobile/ios/Yoliva/Features/MyRides/MyRidesViewModel.swift
import SwiftUI

/// Simple model for a ride in the "My Rides" list.
struct UserRide: Identifiable, Decodable {
    let id: UUID
    let fromCity: String
    let toCity: String
    let date: Date
    let driverName: String
    let price: Double
    let pnr: String
    let status: RideStatus
}

enum RideStatus: String, Decodable {
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
        
        // Load data from mock JSON
        do {
            let allBookings: [UserRide] = try MockDataLoader.shared.load("Bookings")
            self.upcomingRides = allBookings.filter { $0.status == .upcoming }
            self.pastRides = allBookings.filter { $0.status == .past }
        } catch {
            print("Mock Bookings Error: \(error)")
            self.upcomingRides = []
            self.pastRides = []
        }
        
        isLoading = false
    }
}
