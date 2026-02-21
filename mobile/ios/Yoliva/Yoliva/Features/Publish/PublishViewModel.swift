// mobile/ios/Yoliva/Features/Publish/PublishViewModel.swift
import SwiftUI

/// Data structure representing a trip draft being published.
struct PublishDraft {
    var fromCity: String = ""
    var toCity: String = ""
    var date: Date = Date()
    var capacity: Int = 3
    var luggageSize: Int = 1 // 0: Small, 1: Medium, 2: Large
    var isLadiesOnly: Bool = false
    var petsAllowed: Bool = false
    var selectedPrice: Double = 350.0
    
    // Price Lock Boundaries (Calculated based on route distance/fuel)
    var minRecommendedPrice: Double = 320.0
    var maxRecommendedPrice: Double = 520.0
}

/// State machine managing the 4 steps of publishing a trip.
@MainActor
final class PublishViewModel: ObservableObject {
    @Published var draft = PublishDraft()
    @Published var currentStep: Int = 1
    @Published var isLoading: Bool = false
    @Published var isPublished: Bool = false
    
    /// Navigates to the next step with haptic feedback.
    func nextStep() {
        if currentStep < 4 {
            AppTheme.haptic(.light)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep += 1
            }
        }
    }
    
    /// Navigates back to the previous step.
    func previousStep() {
        if currentStep > 1 {
            AppTheme.haptic(.light)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep -= 1
            }
        }
    }
    
    /// Finalizes the trip publication.
    func publishTrip() async {
        isLoading = true
        AppTheme.haptic(.rigid)
        
        // Mock API Call for Publishing
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        isLoading = false
        withAnimation(.spring()) {
            isPublished = true
        }
        AppTheme.notificationHaptic(.success)
    }
    
    /// Resets the wizard for a new trip.
    func resetWizard() {
        draft = PublishDraft()
        currentStep = 1
        isPublished = false
    }
    
    /// Validation logic for each step.
    var canGoNext: Bool {
        switch currentStep {
        case 1: return !draft.fromCity.isEmpty && !draft.toCity.isEmpty
        case 2: return true
        case 3: return true
        case 4: return true
        default: return false
        }
    }
}
