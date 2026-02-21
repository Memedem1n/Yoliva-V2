// mobile/ios/Yoliva/Yoliva/Features/Search/SearchRouteView.swift
import SwiftUI

/// Detailed Search Form for Yoliva Trips.
struct SearchRouteView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack(spacing: 0) {
            // Header: Search Panel (Glassmorphic)
            VStack(spacing: 15) {
                ZStack(alignment: .trailing) {
                    VStack(spacing: 8) {
                        CustomGlassTextField(placeholder: "Nereden?", text: $viewModel.departureCity, icon: "mappin.and.ellipse")
                        CustomGlassTextField(placeholder: "Nereye?", text: $viewModel.arrivalCity, icon: "location.fill")
                    }
                    
                    // Swap Button
                    Button(action: {
                        viewModel.swapLocations()
                    }) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.title)
                            .foregroundColor(AppTheme.primary)
                            .background(Circle().fill(AppTheme.background))
                            .padding(.trailing, 10)
                    }
                }
                
                HStack(spacing: 15) {
                    DatePickerButton(date: viewModel.searchDate)
                    PassengerStepper(count: $viewModel.passengerCount)
                }
                
                // "Ladies Only" Toggle
                Toggle(isOn: $viewModel.isLadiesOnly) {
                    HStack {
                        Image(systemName: "figure.and.child.holdinghands")
                        Text("Sadece Kadınlar")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(viewModel.isLadiesOnly ? AppTheme.accentPink : .white)
                }
                .tint(AppTheme.accentPink)
                .padding(.horizontal, 10)
                .onChange(of: viewModel.isLadiesOnly) { _ in
                    AppTheme.haptic(.soft)
                }
                
                // Search Action
                YolivaPrimaryButton(
                    title: "Yolculuk Bul",
                    isLoading: viewModel.isLoading,
                    isPink: viewModel.isLadiesOnly,
                    action: {
                        Task { await viewModel.executeSearch() }
                    }
                )
            }
            .padding(20)
            .yolivaCard(cornerRadius: 30)
            .padding()
            
            Spacer()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Yolculuk Ara")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subcomponents

struct DatePickerButton: View {
    let date: Date
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(AppTheme.primary)
            Text(date, style: .date)
                .font(.caption.bold())
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .yolivaCard(cornerRadius: 15)
        .onTapGesture {
            AppTheme.haptic(.light)
        }
    }
}

struct PassengerStepper: View {
    @Binding var count: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Button("-") { if count > 1 { count -= 1; AppTheme.haptic(.light) } }
                .foregroundColor(AppTheme.primary)
                .font(.title2.bold())
            
            HStack(spacing: 4) {
                Image(systemName: "person.fill")
                    .foregroundColor(AppTheme.primary)
                Text("\(count)")
                    .font(AppTheme.Typography.numeric(18))
                    .foregroundColor(.white)
            }
            
            Button("+") { if count < 4 { count += 1; AppTheme.haptic(.light) } }
                .foregroundColor(AppTheme.primary)
                .font(.title2.bold())
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .yolivaCard(cornerRadius: 15)
    }
}
