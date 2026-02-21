// mobile/ios/Yoliva/Features/Profile/ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var router: AppRouter
    @State private var isNavigatingToVerification: Bool = false
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // 1. Header: Avatar & Stats
                    VStack(spacing: 15) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                            .glassCard(cornerRadius: 50)
                        
                        VStack(spacing: 4) {
                            Text(viewModel.fullName)
                                .font(AppTheme.Typography.title(24))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill").foregroundColor(.yellow)
                                    Text(String(format: "%.1f", viewModel.rating))
                                }
                                Text("|")
                                    .foregroundColor(.white.opacity(0.2))
                                Text("\(viewModel.totalRides) Yolculuk")
                            }
                            .font(.subheadline.bold())
                            .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    // 2. Trust Center Feature Card
                    Button(action: {
                        AppTheme.haptic(.medium)
                        withAnimation {
                            viewModel.isFaceIDAuthenticating = true
                        }
                    }) {
                        HStack(spacing: 20) {
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 32))
                                .foregroundColor(AppTheme.electricTeal)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Doğrulama Merkezi")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Hesap güvenliğini artır ve daha fazla güven kazan.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(20)
                        .glassCard(cornerRadius: 24)
                    }
                    .padding(.horizontal, 24)
                    
                    // 3. Wallet Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Finans")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading, 4)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Cüzdan Bakiyesi")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("₺\(String(format: "%.2f", viewModel.walletBalance))")
                                    .font(AppTheme.Typography.numeric(28))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button("Yükle") {
                                AppTheme.haptic(.light)
                            }
                            .font(.subheadline.bold())
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(AppTheme.electricTeal)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                        }
                        .padding(24)
                        .glassCard(cornerRadius: 24)
                    }
                    .padding(.horizontal, 24)
                    
                    // 4. Settings List
                    VStack(spacing: 0) {
                        SettingsListRow(icon: "gearshape.fill", title: "Hesap Ayarları")
                        Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 20)
                        SettingsListRow(icon: "bell.fill", title: "Bildirimler")
                        Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 20)
                        SettingsListRow(icon: "lock.fill", title: "Gizlilik ve Güvenlik")
                        Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 20)
                        SettingsListRow(icon: "rectangle.portrait.and.arrow.right", title: "Çıkış Yap", color: .red)
                    }
                    .glassCard(cornerRadius: 24)
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 120) // Floating tab bar offset
                }
            }
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        // Face ID Authentication Overlay
        .faceIDProtected(isAuthenticating: $viewModel.isFaceIDAuthenticating) {
            isNavigatingToVerification = true
        }
        .navigationDestination(isPresented: $isNavigatingToVerification) {
            VerificationCenterView(viewModel: viewModel)
        }
    }
}

struct SettingsListRow: View {
    let icon: String
    let title: String
    var color: Color = .white
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color.opacity(0.8))
                .frame(width: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(color)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(20)
    }
}
