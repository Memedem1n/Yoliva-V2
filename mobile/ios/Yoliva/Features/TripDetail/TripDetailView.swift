// mobile/ios/Yoliva/Features/TripDetail/TripDetailView.swift
import SwiftUI

/// Detailed Trip View for Yoliva with Booking Conversion.
struct TripDetailView: View {
    @StateObject private var viewModel: TripDetailViewModel
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss
    
    init(trip: TripResult) {
        _viewModel = StateObject(wrappedValue: TripDetailViewModel(trip: trip))
    }
    
    private var accentColor: Color {
        viewModel.trip?.isLadiesOnly == true ? AppTheme.yolivaPink : AppTheme.electricTeal
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    // 1. Mock Map Header
                    MapHeader(accentColor: accentColor, from: viewModel.trip?.fromCity ?? "", to: viewModel.trip?.toCity ?? "")
                    
                    VStack(alignment: .leading, spacing: 25) {
                        // 2. Driver Card (Glassmorphic)
                        DriverCard(driverName: viewModel.trip?.driverName ?? "Sürücü", rating: viewModel.trip?.rating ?? 4.5, accentColor: accentColor)
                        
                        // 3. Trip Rules Section
                        RulesSection(petsAllowed: viewModel.petsAllowed, smokingAllowed: viewModel.smokingAllowed, luggageLimit: viewModel.luggageLimit, accentColor: accentColor)
                        
                        // 4. Car Info Card
                        CarCard(carModel: viewModel.trip?.carModel ?? "Bilinmiyor", accentColor: accentColor)
                        
                        // 5. Trip Notes (Mocked)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sürücü Notu")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Yola vaktinde çıkacağız. Lütfen Beşiktaş meydanındaki Boğa heykelinin önünde olun. Valiz sınırı 1 orta boydur.")
                                .font(AppTheme.Typography.body(15))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(20)
                        .glassCard(cornerRadius: 24)
                        
                        Spacer(minLength: 120) // Footer offset
                    }
                    .padding(.horizontal, 24)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            
            // 6. Sticky Safe-Area Footer
            StickyBookingFooter(price: viewModel.trip?.price ?? 0.0, accentColor: accentColor) {
                viewModel.isShowingConfirmation = true
                AppTheme.haptic(.medium)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isShowingConfirmation) {
            BookingConfirmationSheet(viewModel: viewModel, accentColor: accentColor)
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

// MARK: - Subviews

struct MapHeader: View {
    let accentColor: Color
    let from: String
    let to: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Dark Gradient / Mock Graphic
            LinearGradient(
                colors: [accentColor.opacity(0.15), AppTheme.pureBlack],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .frame(height: 220)
            
            // Route Graphic (Mock)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Circle().fill(accentColor).frame(width: 10, height: 10)
                    Text(from).font(.headline).foregroundColor(.white)
                }
                Rectangle().fill(accentColor.opacity(0.3)).frame(width: 2, height: 20).padding(.leading, 4)
                HStack(spacing: 12) {
                    Circle().stroke(Color.white.opacity(0.5), lineWidth: 2).frame(width: 10, height: 10)
                    Text(to).font(.headline).foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(24)
        }
    }
}

struct DriverCard: View {
    let driverName: String
    let rating: Double
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(Text(String(driverName.prefix(1))).font(.title.bold()))
                .glassCard(cornerRadius: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(driverName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(accentColor)
                        .font(.caption)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                    Text("(120 Yolculuk)")
                        .font(.system(size: 10))
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
            Spacer()
            
            Button("Profil") {
                AppTheme.haptic(.light)
            }
            .font(.caption.bold())
            .foregroundColor(accentColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(accentColor.opacity(0.1))
            .clipShape(Capsule())
        }
        .padding(16)
        .glassCard(cornerRadius: 24)
    }
}

struct RulesSection: View {
    let petsAllowed: Bool
    let smokingAllowed: Bool
    let luggageLimit: String
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Yolculuk Kuralları")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                RuleItem(icon: "pawprint.fill", label: "Evcil Hayvan", isActive: petsAllowed, accentColor: accentColor)
                RuleItem(icon: "nosign", label: "Sigara", isActive: smokingAllowed, accentColor: accentColor)
                RuleItem(icon: "briefcase.fill", label: luggageLimit, isActive: true, accentColor: accentColor)
            }
        }
    }
}

struct RuleItem: View {
    let icon: String
    let label: String
    let isActive: Bool
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(isActive ? accentColor : .white.opacity(0.2))
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(isActive ? .white : .white.opacity(0.2))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .glassCard(cornerRadius: 16)
    }
}

struct CarCard: View {
    let carModel: String
    let accentColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: "car.side.fill")
                .font(.title3)
                .foregroundColor(accentColor)
            VStack(alignment: .leading) {
                Text(carModel)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text("Konfor Sınıfı")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("34 YLV 123")
                .font(AppTheme.Typography.numeric(12))
                .padding(6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(16)
        .glassCard(cornerRadius: 20)
    }
}

struct StickyBookingFooter: View {
    let price: Double
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        VStack {
            Divider().background(Color.white.opacity(0.1))
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Koltuk Başı")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("₺\(Int(price))")
                        .font(AppTheme.Typography.numeric(24))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                YolivaPrimaryButton(
                    title: "Rezervasyon Yap",
                    isLoading: false,
                    isPink: accentColor == AppTheme.yolivaPink,
                    action: action
                )
                .frame(width: 200)
            }
            .padding(.horizontal, 24)
            .padding(.top, 15)
            .padding(.bottom, 30)
        }
        .background(AppTheme.background.opacity(0.8))
        .background(.ultraThinMaterial)
    }
}
