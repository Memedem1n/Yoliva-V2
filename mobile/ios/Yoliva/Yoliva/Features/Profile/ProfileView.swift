// mobile/ios/Yoliva/Yoliva/Features/Profile/ProfileView.swift
import SwiftUI

/// Redesigned ProfileView matching Image #11.
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // 1. Header: Avatar with Teal Border
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                )
                                .overlay(Circle().stroke(AppTheme.primary, lineWidth: 2))
                            
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(AppTheme.primary)
                                .background(Circle().fill(.black))
                                .offset(x: -5, y: -5)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Emre Yılmaz")
                                .font(AppTheme.Typography.title(24))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 4) {
                                ForEach(0..<4) { _ in Image(systemName: "star.fill").foregroundColor(.yellow) }
                                Image(systemName: "star.leadinghalf.filled").foregroundColor(.yellow)
                                Text("4.8").font(.subheadline.bold()).foregroundColor(.gray)
                            }
                        }
                        
                        Text("İstanbul-Ankara arası sık seyahat ediyorum. Güvenli ve keyifli yolculuklar!")
                            .font(AppTheme.Typography.body(14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        HStack(spacing: 12) {
                            VerificationBadge(icon: "shield.fill", label: "Doğrulanmış", color: AppTheme.primary)
                            VerificationBadge(icon: "calendar", label: "2024'den beri üye", color: .gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    // 2. Stats Grid (Image #11)
                    HStack(spacing: 0) {
                        ProfileStat(label: "Yolculuk", value: "47", icon: "arrow.up.right")
                        Divider().frame(height: 40).background(Color.white.opacity(0.1))
                        ProfileStat(label: "Puan", value: "4.8", icon: "star")
                        Divider().frame(height: 40).background(Color.white.opacity(0.1))
                        ProfileStat(label: "Üyelik", value: "2024", icon: "medal")
                    }
                    .padding(.vertical, 20)
                    .yolivaCard(cornerRadius: 24)
                    
                    // 3. Menu Sections
                    VStack(alignment: .leading, spacing: 16) {
                        Text("HESAP").font(.caption.bold()).foregroundColor(.gray).padding(.leading, 4)
                        
                        VStack(spacing: 0) {
                            ProfileMenuRow(icon: "doc.text.fill", title: "Doğrulama Merkezi", status: "Doğrulanmış", accent: AppTheme.primary)
                            Divider().background(Color.white.opacity(0.05)).padding(.horizontal, 20)
                            ProfileMenuRow(icon: "car.fill", title: "Araçlarım", status: "Volkswagen Passat 2022")
                            Divider().background(Color.white.opacity(0.05)).padding(.horizontal, 20)
                            ProfileMenuRow(icon: "creditcard.fill", title: "Ödeme Yöntemleri")
                        }
                        .yolivaCard(cornerRadius: 24)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("TERCİHLER").font(.caption.bold()).foregroundColor(.gray).padding(.leading, 4)
                        
                        ProfileMenuRow(icon: "bell.fill", title: "Bildirimler")
                            .yolivaCard(cornerRadius: 24)
                    }
                    
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
            }
        }
    }
}

struct ProfileStat: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(AppTheme.primary)
            Text(value).font(AppTheme.Typography.numeric(20)).foregroundColor(.white)
            Text(label).font(.system(size: 10)).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    var status: String? = nil
    var accent: Color = .white
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(accent)
                .frame(width: 32, height: 32)
                .background(accent.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold()).foregroundColor(.white)
                if let status = status {
                    Text(status).font(.caption).foregroundColor(accent == .white ? .gray : accent)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(20)
    }
}
