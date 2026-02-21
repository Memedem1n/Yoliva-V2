// mobile/ios/Yoliva/Features/Search/Components/TripCardView.swift
import SwiftUI

/// Premium Result Card for Trip Search Results.
struct TripCardView: View {
    let trip: TripResult
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            AppTheme.haptic(.light)
            action()
        }) {
            VStack(alignment: .leading, spacing: 18) {
                // Time and Price Header
                HStack {
                    HStack(spacing: 8) {
                        Text(trip.departureTime, style: .time)
                            .font(AppTheme.Typography.numeric(20))
                            .foregroundColor(trip.isLadiesOnly ? AppTheme.yolivaPink : AppTheme.electricTeal)
                        
                        Text("➔")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text(trip.departureTime.addingTimeInterval(14400), style: .time)
                            .font(AppTheme.Typography.numeric(20))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Text("₺\(Int(trip.price))")
                        .font(AppTheme.Typography.numeric(24))
                        .foregroundColor(.white)
                }
                
                // Vertical Timeline logic for Location
                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Circle()
                            .fill(trip.isLadiesOnly ? AppTheme.yolivaPink : AppTheme.electricTeal)
                            .frame(width: 8, height: 8)
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 2, height: 20)
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 8, height: 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text(trip.fromCity)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(trip.toCity)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                // Driver and Badges Footer
                HStack {
                    HStack(spacing: 10) {
                        // Driver Avatar with Glassmorphic Circle
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(Text(String(trip.driverName.prefix(1))).font(.caption.bold()))
                            .glassCard(cornerRadius: 16)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(trip.driverName)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", trip.rating))
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Feature Badges
                    HStack(spacing: 6) {
                        if trip.isLadiesOnly {
                            FeatureBadge(icon: "figure.and.child.holdinghands", color: AppTheme.yolivaPink)
                        }
                        FeatureBadge(icon: "bolt.fill", color: AppTheme.electricTeal)
                    }
                }
            }
            .padding(20)
            .glassCard(cornerRadius: 24)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Subcomponents

struct FeatureBadge: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 12, weight: .bold))
            .padding(8)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .clipShape(Circle())
            .overlay(Circle().stroke(color.opacity(0.2), lineWidth: 1))
    }
}
