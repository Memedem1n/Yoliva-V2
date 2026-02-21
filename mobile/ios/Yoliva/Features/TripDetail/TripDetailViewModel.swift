// mobile/ios/Yoliva/Features/TripDetail/TripDetailViewModel.swift
import SwiftUI

/// ViewModel for managing the selected Trip details and Booking flow.
@MainActor
final class TripDetailViewModel: ObservableObject {
    @Published var trip: TripResult?
    @Published var isLoading: Bool = false
    @Published var isBookingSuccess: Bool = false
    @Published var pnrCode: String?
    @Published var isShowingConfirmation: Bool = false
    @Published var bookingLoading: Bool = false
    
    // Trip Rules (Mocked based on trip attributes)
    @Published var petsAllowed: Bool = false
    @Published var smokingAllowed: Bool = false
    @Published var luggageLimit: String = "1 Büyük, 1 Küçük"
    
    init(trip: TripResult?) {
        self.trip = trip
        // Initialize rules based on trip data (if any)
        if let trip = trip {
            self.petsAllowed = !trip.isLadiesOnly // Mock rule for variety
        }
    }
    
    /// Simulates the booking process with a 1.5s delay.
    func confirmBooking() async {
        bookingLoading = true
        AppTheme.haptic(.rigid)
        
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Success Logic
        self.pnrCode = "YLV-\(Int.random(in: 1000...9999))"
        self.isBookingSuccess = true
        self.bookingLoading = false
        AppTheme.haptic(.success)
    }
}
