// mobile/ios/Yoliva/Yoliva/Features/Search/Components/TripCardView.swift
import SwiftUI

/// Redesigned Trip Card matching Image #2.
struct TripCardView: View {
    let trip: TripResult
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 20) {
                // Header: Driver and Price
                HStack(alignment: .top) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(Text(String(trip.driverName.prefix(1))).font(.subheadline.bold()))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 4) {
                                Text(trip.driverName).font(.subheadline.bold()).foregroundColor(.white)
                                Image(systemName: "checkmark.seal.fill").foregroundColor(AppTheme.primary).font(.caption2)
                            }
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption2)
                                Text(String(format: "%.1f", trip.rating)).font(.caption2.bold()).foregroundColor(.gray)
                                Text("• \(Int.random(in: 50...150)) yolculuk").font(.system(size: 10)).foregroundColor(.gray.opacity(0.6))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(Int(trip.price))").font(AppTheme.Typography.numeric(24)).foregroundColor(.white)
                        Text("₺").font(.caption).foregroundColor(.gray)
                    }
                }
                
                // Content: Vertical Timeline
                HStack(spacing: 16) {
                    VStack(spacing: 0) {
                        Circle().fill(AppTheme.primary).frame(width: 8, height: 8)
                        Rectangle().fill(Color.white.opacity(0.1)).frame(width: 1, height: 35)
                        Circle().fill(AppTheme.accentPink).frame(width: 8, height: 8)
                    }
                    .padding(.leading, 4)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 12) {
                                Text("08:00").font(AppTheme.Typography.numeric(16)).foregroundColor(.white)
                                Text(trip.fromCity).font(.headline).foregroundColor(.white)
                            }
                            Text("Kadıköy").font(.caption).foregroundColor(.gray).padding(.leading, 52)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 12) {
                                Text("12:30").font(AppTheme.Typography.numeric(16)).foregroundColor(.white)
                                Text(trip.toCity).font(.headline).foregroundColor(.white)
                            }
                            Text("Kızılay").font(.caption).foregroundColor(.gray).padding(.leading, 52)
                        }
                    }
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                // Footer: Labels
                HStack {
                    if trip.isLadiesOnly {
                        Text("Kadınlara Özel")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(AppTheme.accentPink.opacity(0.1))
                            .foregroundColor(AppTheme.accentPink)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill").font(.caption).foregroundColor(.gray)
                        Text("2 koltuk").font(.caption).foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .yolivaCard(cornerRadius: 24)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
