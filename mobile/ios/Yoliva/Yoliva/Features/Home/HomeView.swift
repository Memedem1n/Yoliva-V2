// mobile/ios/Yoliva/Yoliva/Features/Home/HomeView.swift
import SwiftUI

/// Redesigned HomeView matching Image #1 from screenshots.
struct HomeView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    // 1. App Logo & Name (Minimal)
                    HStack(spacing: 12) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(AppTheme.primary)
                            .font(.title2)
                        Text("Yoliva")
                            .font(AppTheme.Typography.title(24))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    // 2. Large Typographic Header
                    Text("Yolculuğunu\npaylaş")
                        .font(AppTheme.Typography.header(42))
                        .foregroundColor(.white)
                        .lineSpacing(-5)
                    
                    Text("Güvenli, uygun fiyatlı ve çevre dostu şehirlerarası yolculuk")
                        .font(AppTheme.Typography.body(14))
                        .foregroundColor(.gray)
                        .frame(maxWidth: 280, alignment: .leading)
                    
                    // 3. Central Search Box (Image #1)
                    VStack(spacing: 0) {
                        SearchRow(icon: "mappin.circle.fill", label: "Nereden", value: "İstanbul")
                        Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                        SearchRow(icon: "paperplane.fill", label: "Nereye", value: "Ankara")
                        
                        HStack(spacing: 0) {
                            SearchSubRow(icon: "calendar", label: "Tarih", value: "25 Şuba...")
                            Divider().frame(height: 40).background(Color.white.opacity(0.05))
                            SearchSubRow(icon: "person.2.fill", label: "Yolcu", value: "1 kişi")
                        }
                        
                        Button(action: { 
                            AppTheme.haptic(.rigid)
                            router.navigate(to: .search)
                        }) {
                            Text("Yolculuk Ara ➔")
                                .font(AppTheme.Typography.title(18))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(AppTheme.primary)
                                .cornerRadius(16)
                                .padding(16)
                        }
                    }
                    .yolivaCard(cornerRadius: 28)
                    
                    // 4. Popular Routes
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(AppTheme.primary)
                            Text("Popüler Güzergahlar")
                                .font(AppTheme.Typography.title(18))
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                RouteChip(icon: "building.columns.fill", route: "İstanbul ➔ Ankara")
                                RouteChip(icon: "cloud.sun.fill", route: "İstanbul ➔ İzmir")
                            }
                        }
                    }
                    
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
            }
        }
    }
}

// MARK: - Subviews

struct SearchRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primary)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption).foregroundColor(.gray)
                Text(value).font(.headline).foregroundColor(.white)
            }
            Spacer()
        }
        .padding(16)
    }
}

struct SearchSubRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primary)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption2).foregroundColor(.gray)
                Text(value).font(.subheadline.bold()).foregroundColor(.white)
            }
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity)
    }
}

struct RouteChip: View {
    let icon: String
    let route: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.6))
            Text(route)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppTheme.secondary)
        .cornerRadius(30)
        .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
