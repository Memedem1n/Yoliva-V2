// mobile/ios/Yoliva/Features/MyRides/MyRidesView.swift
import SwiftUI

/// Screen displaying upcoming and past rides with a segmented control.
struct MyRidesView: View {
    @StateObject private var viewModel = MyRidesViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Segmented Control (Custom Glassmorphic)
                HStack(spacing: 0) {
                    SegmentButton(title: "Yaklaşan", isSelected: viewModel.selectedTab == .upcoming) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedTab = .upcoming
                            AppTheme.haptic(.light)
                        }
                    }
                    
                    SegmentButton(title: "Geçmiş", isSelected: viewModel.selectedTab == .past) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedTab = .past
                            AppTheme.haptic(.light)
                        }
                    }
                }
                .padding(6)
                .glassCard(cornerRadius: 16)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                
                // List of Tickets
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if viewModel.selectedTab == .upcoming {
                            if viewModel.upcomingRides.isEmpty {
                                EmptyRidesState(icon: "car.2.fill", text: "Henüz planlanmış bir yolculuğun yok.")
                            } else {
                                ForEach(viewModel.upcomingRides) { ride in
                                    TicketCardView(ride: ride) {
                                        viewModel.selectedRideForQR = ride
                                        viewModel.isShowingQR = true
                                    }
                                }
                            }
                        } else {
                            if viewModel.pastRides.isEmpty {
                                EmptyRidesState(icon: "clock.fill", text: "Geçmiş yolculuğun bulunmuyor.")
                            } else {
                                ForEach(viewModel.pastRides) { ride in
                                    TicketCardView(ride: ride) { /* No QR for past rides */ }
                                }
                            }
                        }
                        
                        Spacer(minLength: 120) // Floating Tab Bar offset
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationTitle("Yolculuklarım")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $viewModel.selectedRideForQR) { ride in
            BoardingQRSheet(ride: ride)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

// MARK: - Subviews

struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(isSelected ? AppTheme.electricTeal : Color.clear)
                .foregroundColor(isSelected ? .black : .white.opacity(0.6))
                .cornerRadius(12)
        }
    }
}

struct EmptyRidesState: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.1))
            Text(text)
                .font(AppTheme.Typography.body())
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}

// Extension to make UserRide identifiable for sheet item:
extension UserRide: Identifiable { }
