// mobile/ios/Yoliva/Yoliva/Features/MyRides/Components/TicketCardView.swift
import SwiftUI

/// Redesigned Boarding Pass matching Image #7.
struct TicketCardView: View {
    let ride: UserRide
    let onQRAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Badge
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "paperplane.fill").font(.system(size: 8))
                    Text("YOLIVA").font(.system(size: 10, weight: .black))
                }
                .foregroundColor(AppTheme.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Onaylandı")
                }
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(AppTheme.primary)
            }
            .padding([.horizontal, .top], 20)
            
            // Route Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("İST").font(.system(size: 44, weight: .black, design: .rounded)).foregroundColor(.white)
                    Text(ride.fromCity).font(.caption).foregroundColor(.gray)
                    Text("08:00").font(AppTheme.Typography.numeric(16)).foregroundColor(AppTheme.primary)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Circle().fill(AppTheme.primary).frame(width: 6, height: 6)
                    Rectangle().fill(AppTheme.primary.opacity(0.2)).frame(width: 60, height: 1)
                        .overlay(Image(systemName: "car.fill").font(.system(size: 12)).foregroundColor(AppTheme.primary))
                    Circle().fill(AppTheme.primary).frame(width: 6, height: 6)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("ANK").font(.system(size: 44, weight: .black, design: .rounded)).foregroundColor(.white)
                    Text(ride.toCity).font(.caption).foregroundColor(.gray)
                    Text("12:30").font(AppTheme.Typography.numeric(16)).foregroundColor(AppTheme.primary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            
            // Middle Stats
            HStack {
                TicketStat(label: "TARİH", value: "2026-02-25")
                Spacer()
                TicketStat(label: "KOLTUK", value: "1")
                Spacer()
                TicketStat(label: "ÜCRET", value: "450₺", isTeal: true)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            
            // Dashed Divider
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .foregroundColor(Color.white.opacity(0.1))
            
            // Footer: Driver and QR
            HStack {
                HStack(spacing: 12) {
                    Circle().fill(Color.white.opacity(0.1)).frame(width: 36, height: 36)
                        .overlay(Text("A").font(.caption.bold()))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ride.driverName).font(.subheadline.bold()).foregroundColor(.white)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill").foregroundColor(.yellow).font(.system(size: 8))
                            Text("4.9").font(.system(size: 10, weight: .bold)).foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                if ride.status == .upcoming {
                    Button(action: onQRAction) {
                        HStack(spacing: 8) {
                            Image(systemName: "qrcode")
                            Text("Biniş QR")
                        }
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppTheme.primary)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                }
            }
            .padding(20)
        }
        .yolivaCard(cornerRadius: 32)
    }
}

struct TicketStat: View {
    let label: String
    let value: String
    var isTeal: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(label).font(.system(size: 10)).foregroundColor(.gray)
            Text(value)
                .font(AppTheme.Typography.numeric(16))
                .foregroundColor(isTeal ? AppTheme.primary : .white)
        }
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        return path
    }
}
