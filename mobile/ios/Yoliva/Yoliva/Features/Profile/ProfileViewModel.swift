// mobile/ios/Yoliva/Features/Profile/ProfileViewModel.swift
import SwiftUI

enum VerificationStatus: String {
    case approved = "Onaylandı"
    case missing = "Eksik"
    case pending = "İnceleniyor"
    
    var color: Color {
        switch self {
        case .approved: return .green
        case .missing: return .red
        case .pending: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .approved: return "checkmark.seal.fill"
        case .missing: return "exclamationmark.triangle.fill"
        case .pending: return "clock.fill"
        }
    }
}

@MainActor
final class ProfileViewModel: ObservableObject {
    // User Stats
    @Published var fullName: String = "Barış B."
    @Published var totalRides: Int = 42
    @Published var rating: Double = 4.9
    @Published var walletBalance: Double = 1250.50
    
    // Verification Statuses
    @Published var idStatus: VerificationStatus = .approved
    @Published var licenseStatus: VerificationStatus = .missing
    @Published var criminalRecordStatus: VerificationStatus = .approved
    @Published var vehicleRegStatus: VerificationStatus = .missing
    
    @Published var isTakingPhoto: Bool = false
    @Published var isFaceIDAuthenticating: Bool = false
    @Published var selectedDocType: String? = nil
    
    func startVerification(for type: String) {
        selectedDocType = type
        isTakingPhoto = true
    }
    
    func completePhotoUpload() async {
        // Mock upload delay
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Update status to pending
        if let type = selectedDocType {
            switch type {
            case "Sürücü Belgesi": licenseStatus = .pending
            case "Araç Ruhsatı": vehicleRegStatus = .pending
            default: break
            }
        }
        
        AppTheme.notificationHaptic(.success)
        isTakingPhoto = false
    }
}
