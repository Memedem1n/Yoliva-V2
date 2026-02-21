// mobile/ios/Yoliva/Yoliva/Features/Search/SearchViewModel.swift
import SwiftUI

/// SearchViewModel for managing search state, criteria, and filters.
@MainActor
final class SearchViewModel: ObservableObject {
    // Search Criteria
    @Published var departureCity: String = ""
    @Published var arrivalCity: String = ""
    @Published var searchDate: Date = Date()
    @Published var passengerCount: Int = 1
    
    // Filter Toggles
    @Published var isLadiesOnly: Bool = false
    @Published var allowPets: Bool = false
    @Published var allowSmoking: Bool = false
    @Published var maxPrice: Double = 1000.0
    
    // Search State
    @Published var isLoading: Bool = false
    @Published var results: [TripResult] = []
    
    // Filter Chips
    @Published var selectedFilter: String = "Tümü"
    let filters = ["Tümü", "Kadınlara Özel", "Evcil Hayvan", "Kargo"]
    
    /// Swaps the departure and arrival locations.
    func swapLocations() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
            let temp = departureCity
            departureCity = arrivalCity
            arrivalCity = temp
            AppTheme.haptic(.light)
        }
    }
    
    /// Executes the search based on current criteria.
    func executeSearch() async {
        guard !departureCity.isEmpty && !arrivalCity.isEmpty else {
            AppTheme.notificationHaptic(.error)
            return
        }
        
        isLoading = true
        AppTheme.haptic(.rigid)
        
        // Mock API Call Simulation
        try? await Task.sleep(nanoseconds: 1_200_000_000)
        
        // Load data from mock JSON
        do {
            let allTrips: [TripResult] = try MockDataLoader.shared.load("Trips")
            // Filter based on criteria if needed
            self.results = allTrips.filter { trip in
                let cityMatch = trip.fromCity.lowercased().contains(departureCity.lowercased()) || departureCity.isEmpty
                let ladiesMatch = isLadiesOnly ? trip.isLadiesOnly : true
                return cityMatch && ladiesMatch
            }
        } catch {
            print("Mock Data Error: \(error)")
            self.results = []
        }
        
        isLoading = false
    }
}

/// Simple model for trip results during the search phase.
struct TripResult: Identifiable, Decodable { // Added Decodable
    let id: UUID
    let driverName: String
    let departureTime: Date
    let fromCity: String
    let toCity: String
    let price: Double
    let isLadiesOnly: Bool
    let rating: Double
    let carModel: String
}
