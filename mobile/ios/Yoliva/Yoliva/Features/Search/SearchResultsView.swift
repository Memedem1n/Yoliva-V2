// mobile/ios/Yoliva/Features/Search/SearchResultsView.swift
import SwiftUI

/// Detailed Results View for Yoliva Trips with Filter Chips and Trip Cards.
struct SearchResultsView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack(spacing: 0) {
            // Horizontal Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.filters, id: \.self) { filter in
                        FilterChip(
                            title: filter,
                            isSelected: viewModel.selectedFilter == filter,
                            isLadiesOnly: filter == "Kadınlara Özel",
                            action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75, blendDuration: 0)) {
                                    viewModel.selectedFilter = filter
                                    AppTheme.haptic(.light)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .background(AppTheme.background)
            
            // List of Trip Result Cards
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        // Skeleton/Progress View
                        ProgressView()
                            .padding(.top, 40)
                    } else if viewModel.results.isEmpty {
                        // Empty State Placeholder
                        VStack(spacing: 20) {
                            Image(systemName: "car.2.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.1))
                            Text("Maalesef bu kriterde yolculuk bulunamadı.")
                                .font(AppTheme.Typography.body())
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(.top, 60)
                    } else {
                        // Trip Results List
                        ForEach(viewModel.results) { trip in
                            TripCardView(trip: trip) {
                                AppTheme.haptic(.medium)
                                router.navigate(to: .rideDetails(id: trip.id.uuidString))
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 120) // Floating Tab Bar offset
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("\(viewModel.departureCity) ➔ \(viewModel.arrivalCity)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subcomponents

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let isLadiesOnly: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    ZStack {
                        if isSelected {
                            (isLadiesOnly ? AppTheme.yolivaPink : AppTheme.electricTeal)
                        } else {
                            Color.white.opacity(0.1)
                        }
                        
                        // Glow effect for selected Ladies Only filter
                        if isSelected && isLadiesOnly {
                            AppTheme.yolivaPink.blur(radius: 8).opacity(0.3)
                        }
                    }
                )
                .foregroundColor(isSelected ? .black : .white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? .clear : .white.opacity(0.1), lineWidth: 1)
                )
        }
    }
}
