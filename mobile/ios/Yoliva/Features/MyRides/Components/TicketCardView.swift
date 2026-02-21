// mobile/ios/Yoliva/Features/MyRides/Components/TicketCardView.swift
import SwiftUI

/// Boarding pass-style card for upcoming and past rides.
struct TicketCardView: View {
    let ride: UserRide
    let onQRAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Upper Section: Locations and Date
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ride.fromCity).font(.headline).foregroundColor(.white)
                        Text(ride.date, style: .time).font(AppTheme.Typography.numeric(16)).foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "arrow.right").foregroundColor(AppTheme.electricTeal)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(ride.toCity).font(.headline).foregroundColor(.white)
                        Text(ride.date.addingTimeInterval(14400), style: .time).font(AppTheme.Typography.numeric(16)).foregroundColor(.gray)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("SÜRÜCÜ").font(.system(size: 10)).foregroundColor(.gray)
                        Text(ride.driverName).font(.subheadline.bold()).foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("PNR").font(.system(size: 10)).foregroundColor(.gray)
                        Text(ride.pnr).font(AppTheme.Typography.numeric(16)).foregroundColor(AppTheme.electricTeal)
                    }
                }
            }
            .padding(20)
            
            // Dashed Divider (Airplane ticket style)
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.15))
                .padding(.horizontal, 10)
            
            // Bottom Section: Actions
            VStack {
                if ride.status == .upcoming {
                    Button(action: {
                        AppTheme.haptic(.medium)
                        onQRAction()
                    }) {
                        HStack {
                            Image(systemName: "qrcode")
                            Text("Biniş QR Kodunu Göster")
                        }
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppTheme.electricTeal.opacity(0.1))
                        .foregroundColor(AppTheme.electricTeal)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.electricTeal.opacity(0.3), lineWidth: 1))
                        .shadow(color: AppTheme.electricTeal.opacity(0.1), radius: 5)
                    }
                } else {
                    Button(action: {
                        AppTheme.haptic(.light)
                    }) {
                        Text("Puan Ver")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.05))
                            .foregroundColor(.gray)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(20)
        }
        .glassCard(cornerRadius: 24)
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
