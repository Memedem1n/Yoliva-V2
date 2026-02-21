// mobile/ios/Yoliva/Features/MyRides/BoardingQRSheet.swift
import SwiftUI

/// Medium-detent bottom sheet for displaying the boarding QR code.
struct BoardingQRSheet: View {
    let ride: UserRide
    @Environment(\.dismiss) var dismiss
    @State private var showWalletToast: Bool = false
    
    var body: some View {
        ZStack {
            // Background blur using system material
            Color.clear.background(.ultraThinMaterial).ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header with PNR
                VStack(spacing: 4) {
                    Text("Biniş QR Kodu")
                        .font(AppTheme.Typography.title(22))
                        .foregroundColor(.white)
                    Text(ride.pnr)
                        .font(AppTheme.Typography.numeric(18))
                        .foregroundColor(AppTheme.primary)
                        .bold()
                }
                .padding(.top, 40)
                
                // Mock QR Code: Massive white square with symbol
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: AppTheme.primary.opacity(0.3), radius: 20)
                    
                    Image(systemName: "qrcode")
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .foregroundColor(.black)
                }
                
                // Add to Apple Wallet Mock Button
                Button(action: {
                    AppTheme.notificationHaptic(.success)
                    withAnimation(.spring()) {
                        showWalletToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation { showWalletToast = false }
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "wallet.pass.fill")
                        Text("Apple Cüzdan'a Ekle")
                    }
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Toast logic
                if showWalletToast {
                    Text("Bilet Apple Wallet'a eklendi!")
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.primary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .glassCard(cornerRadius: 12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 20)
        }
    }
}
