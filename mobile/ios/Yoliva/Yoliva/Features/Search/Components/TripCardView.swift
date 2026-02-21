// mobile/ios/Yoliva/Yoliva/Features/Search/Components/TripCardView.swift
import SwiftUI

/// Redesigned Responsive Trip Card with Depth and Symbol Effects.
struct TripCardView: View {
    let trip: TripResult
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            AppTheme.haptic(.light)
            action()
        }) {
            VStack(alignment: .leading, spacing: 16) {
                // 1. Time & Price: High contrast
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(trip.departureTime, style: .time)
                                .font(AppTheme.Typography.numeric(22))
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption2.bold())
                                .foregroundColor(AppTheme.accent.opacity(0.5))
                            
                            Text(trip.departureTime.addingTimeInterval(14400), style: .time)
                                .font(AppTheme.Typography.numeric(22))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Text("\(trip.fromCity) ➔ \(trip.toCity)")
                            .font(.caption.bold())
                            .foregroundColor(AppTheme.accent)
                    }
                    
                    Spacer()
                    
                    Text("₺\(Int(trip.price))")
                        .font(AppTheme.Typography.numeric(26))
                        .foregroundColor(AppTheme.accent)
                        .shadow(color: AppTheme.accent.opacity(0.3), radius: 8)
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                // 2. Driver & Badges: Modern layout
                HStack {
                    HStack(spacing: 12) {
                        // Avatar with depth
                        ZStack {
                            Circle()
                                .fill(AppTheme.surface)
                                .frame(width: 40, height: 40)
                            
                            Text(String(trip.driverName.prefix(1)))
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                        }
                        .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(trip.driverName)
                                .font(.subheadline.bold())
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
                    
                    // Animated Symbol Badges (iOS 17+)
                    HStack(spacing: 10) {
                        if trip.isLadiesOnly {
                            Image(systemName: "figure.and.child.holdinghands")
                                .symbolEffect(.bounce, options: .repeat(2))
                                .foregroundColor(AppTheme.yolivaPink)
                                .padding(8)
                                .background(AppTheme.yolivaPink.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        Image(systemName: "shield.checkered")
                            .foregroundColor(AppTheme.primary)
                            .padding(8)
                            .background(AppTheme.primary.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(20)
            .glassCard(cornerRadius: 28, addGlow: trip.isLadiesOnly)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
