// mobile/ios/Yoliva/Features/Home/HomeView.swift
import SwiftUI

/// Yoliva Dashboard: Home to quick actions and upcoming trip summaries.
struct HomeView: View {
    @EnvironmentObject var router: AppRouter
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                // Header: Welcome
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Merhaba, Barış") // User name from Session
                            .font(AppTheme.Typography.title(28))
                            .foregroundColor(.white)
                        Text("Bugün nereye gidiyoruz?")
                            .font(AppTheme.Typography.body())
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    Spacer()
                    
                    // Profile Avatar with Glassmorphism
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 54, height: 54)
                        .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                        .glassCard(cornerRadius: 27)
                        .onTapGesture {
                            AppTheme.haptic(.light)
                            router.navigate(to: .profile)
                        }
                }
                .padding(.top, 20)
                
                // Quick Search Bar (Glassmorphic)
                Button(action: {
                    AppTheme.haptic(.medium)
                    router.navigate(to: .search)
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppTheme.electricTeal)
                            .font(.system(size: 20, weight: .bold))
                        Text("Nereye Gidiyorsun?")
                            .font(AppTheme.Typography.body(18))
                            .foregroundColor(.white.opacity(0.4))
                        Spacer()
                    }
                    .padding()
                    .frame(height: 64)
                    .glassCard(cornerRadius: 20)
                }
                
                // Upcoming Trips Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Yaklaşan Yolculuklar")
                            .font(AppTheme.Typography.title(20))
                            .foregroundColor(.white)
                        Spacer()
                        Button("Tümü") {
                            AppTheme.haptic(.light)
                            router.navigate(to: .myRides)
                        }
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.electricTeal)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<3) { _ in
                                UpcomingTripCard()
                                    .frame(width: 280)
                            }
                        }
                    }
                }
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 15) {
                    Text("Hızlı İşlemler")
                        .font(AppTheme.Typography.title(20))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        QuickActionCard(title: "İlan Yayınla", icon: "plus.circle.fill", color: AppTheme.electricTeal) {
                            router.navigate(to: .publishWizard)
                        }
                        QuickActionCard(title: "Güvenlik Merkezi", icon: "shield.checkered", color: .white) {
                            router.navigate(to: .trustCenter)
                        }
                    }
                }
                
                Spacer(minLength: 120) // Floating Tab Bar offset
            }
            .padding(.horizontal, 24)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}

// MARK: - Subviews

struct UpcomingTripCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("İstanbul ➔ Ankara")
                    .font(.headline)
                Spacer()
                Image(systemName: "car.fill")
                    .foregroundColor(AppTheme.electricTeal)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Yarın, 09:30")
                        .font(AppTheme.Typography.numeric(16))
                    Text("Kadıköy Boğa Önü")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("₺350")
                    .font(AppTheme.Typography.numeric(20))
                    .foregroundColor(.white)
            }
        }
        .padding(20)
        .glassCard(cornerRadius: 24)
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            AppTheme.haptic(.light)
            action()
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .glassCard(cornerRadius: 20)
        }
    }
}
