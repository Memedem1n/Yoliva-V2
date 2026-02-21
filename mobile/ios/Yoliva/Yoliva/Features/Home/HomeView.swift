// mobile/ios/Yoliva/Yoliva/Features/Home/HomeView.swift
import SwiftUI

/// Redesigned HomeView using a responsive Bento Box layout and living background.
struct HomeView: View {
    @EnvironmentObject var router: AppRouter
    
    // Responsive column definition
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            MeshBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // 1. Header: Dynamic Scaling
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Merhaba, Barış")
                                .font(AppTheme.Typography.title(28))
                                .foregroundColor(.white)
                            Text("Nereye gitmek istersin?")
                                .font(AppTheme.Typography.body())
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        Spacer()
                        
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                            .glassCard(cornerRadius: 25)
                    }
                    .padding(.top, 20)
                    
                    // 2. Bento Grid: Responsive Widgets
                    LazyVGrid(columns: columns, spacing: 16) {
                        // Large Search Widget (Full Width)
                        Button(action: { router.navigate(to: .search) }) {
                            VStack(alignment: .leading, spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.title2.bold())
                                    .foregroundColor(AppTheme.accent)
                                Text("Yolculuk Ara")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .glassCard(cornerRadius: 24, addGlow: true)
                        }
                        .gridCellColumns(2)
                        
                        // Small Widgets
                        BentoWidget(title: "İlan Ver", icon: "plus.circle.fill", color: AppTheme.primary) {
                            router.navigate(to: .publishWizard)
                        }
                        
                        BentoWidget(title: "Cüzdan", icon: "creditcard.fill", color: .white) {
                            router.navigate(to: .profile)
                        }
                    }
                    
                    // 3. Upcoming Trips (Horizontal responsive list)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Sıradaki Yolculuğun")
                                .font(AppTheme.Typography.title(20))
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(AppTheme.accent)
                        }
                        
                        UpcomingTripCard()
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Add more sections here...
                    
                    Spacer(minLength: 140) // Responsive bottom padding for Tab Bar
                }
                .padding(.horizontal, 20) // Responsive side margins
            }
        }
        .navigationBarHidden(true)
    }
}

struct BentoWidget: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .glassCard(cornerRadius: 20)
        }
    }
}
