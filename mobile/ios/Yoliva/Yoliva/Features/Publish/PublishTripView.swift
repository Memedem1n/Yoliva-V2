// mobile/ios/Yoliva/Features/Publish/PublishTripView.swift
import SwiftUI

/// A 4-step wizard for drivers to publish their trips with a Price Lock.
struct PublishTripView: View {
    @StateObject private var viewModel = PublishViewModel()
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Step Indicator (4 Dots)
                StepIndicator(currentStep: viewModel.currentStep)
                    .padding(.top, 20)
                
                Spacer()
                
                // 2. Wizard Content with Asymmetric Transitions
                ZStack {
                    switch viewModel.currentStep {
                    case 1: StepOneRoute(draft: $viewModel.draft)
                    case 2: StepTwoDateCapacity(draft: $viewModel.draft)
                    case 3: StepThreeRules(draft: $viewModel.draft)
                    case 4: StepFourPriceLock(draft: $viewModel.draft)
                    default: EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .id(viewModel.currentStep) // Trigger transition on step change
                .padding(.horizontal, 24)
                
                Spacer()
                
                // 3. Wizard Footer: Navigation Buttons
                HStack {
                    if viewModel.currentStep > 1 {
                        Button("Geri") { viewModel.previousStep() }
                            .foregroundColor(.white.opacity(0.6))
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    YolivaPrimaryButton(
                        title: viewModel.currentStep == 4 ? "Yayınla" : "Devam Et",
                        isLoading: viewModel.isLoading,
                        isPink: viewModel.draft.isLadiesOnly,
                        action: {
                            if viewModel.currentStep == 4 {
                                Task { await viewModel.publishTrip() }
                            } else {
                                viewModel.nextStep()
                            }
                        }
                    )
                    .frame(width: 160)
                    .disabled(!viewModel.canGoNext)
                    .opacity(viewModel.canGoNext ? 1.0 : 0.5)
                }
                .padding(24)
            }
            
            // 4. Success Overlay
            if viewModel.isPublished {
                SuccessOverlay(action: {
                    viewModel.resetWizard()
                    dismiss()
                    router.popToRoot()
                })
                .transition(.opacity.combined(with: .scale))
            }
        }
        .navigationTitle("Yolculuk Yayınla")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Wizard Sub-steps

struct StepIndicator: View {
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...4, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? AppTheme.primary : .white.opacity(0.1))
                    .frame(width: 10, height: 10)
                    .shadow(color: step == currentStep ? AppTheme.primary.opacity(0.6) : .clear, radius: 4)
                    .scaleEffect(step == currentStep ? 1.2 : 1.0)
            }
        }
    }
}

struct StepOneRoute: View {
    @Binding var draft: PublishDraft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Nereden Nereye?")
                .font(AppTheme.Typography.title(28))
            
            VStack(spacing: 16) {
                CustomGlassTextField(placeholder: "Kalkış Şehri", text: $draft.fromCity, icon: "mappin.and.ellipse")
                CustomGlassTextField(placeholder: "Varış Şehri", text: $draft.toCity, icon: "location.fill")
            }
        }
    }
}

struct StepTwoDateCapacity: View {
    @Binding var draft: PublishDraft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Tarih ve Kapasite")
                .font(AppTheme.Typography.title(28))
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(AppTheme.primary)
                DatePicker("Yolculuk Tarihi", selection: $draft.date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .tint(AppTheme.primary)
            }
            .padding()
            .glassCard(cornerRadius: 16)
            
            HStack {
                Text("Koltuk Sayısı").font(.headline)
                Spacer()
                Stepper("\(draft.capacity)", value: $draft.capacity, in: 1...4)
                    .padding(.horizontal)
            }
            .padding()
            .glassCard(cornerRadius: 16)
        }
    }
}

struct StepThreeRules: View {
    @Binding var draft: PublishDraft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Yolculuk Kuralları")
                .font(AppTheme.Typography.title(28))
            
            Toggle(isOn: $draft.isLadiesOnly) {
                HStack(spacing: 12) {
                    Image(systemName: "figure.and.child.holdinghands")
                    Text("Sadece Kadınlar")
                }
                .font(.headline)
            }
            .tint(AppTheme.accentPink)
            .padding()
            .glassCard(cornerRadius: 16)
            
            Toggle(isOn: $draft.petsAllowed) {
                HStack(spacing: 12) {
                    Image(systemName: "pawprint.fill")
                    Text("Evcil Hayvan")
                }
                .font(.headline)
            }
            .tint(AppTheme.primary)
            .padding()
            .glassCard(cornerRadius: 16)
        }
    }
}

struct StepFourPriceLock: View {
    @Binding var draft: PublishDraft
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("Ücret Belirle")
                    .font(AppTheme.Typography.title(28))
                Text("Sistemimiz yakıt maliyetine göre size bir fiyat aralığı önerir.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            // Neon Price Display
            VStack(spacing: 4) {
                Text("₺\(Int(draft.selectedPrice))")
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.primary)
                    .shadow(color: AppTheme.primary.opacity(0.8), radius: 20)
                Text("Yolcu Başına")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.vertical, 30)
            
            // Price Lock Slider (Bounded)
            VStack(spacing: 12) {
                Slider(value: $draft.selectedPrice, in: draft.minRecommendedPrice...draft.maxRecommendedPrice, step: 10)
                    .tint(AppTheme.primary)
                
                HStack {
                    Text("₺\(Int(draft.minRecommendedPrice))").font(.caption.bold())
                    Spacer()
                    Text("₺\(Int(draft.maxRecommendedPrice))").font(.caption.bold())
                }
                .foregroundColor(.gray)
            }
            .padding(20)
            .glassCard(cornerRadius: 24)
            
            HStack(spacing: 10) {
                Image(systemName: "lock.fill").foregroundColor(AppTheme.primary)
                Text("Yoliva Fiyat Kilidi Aktif: Daha yüksek fiyat belirlenemez.")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Success Overlay

struct SuccessOverlay: View {
    let action: () -> Void
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Animated Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(AppTheme.primary)
                    .shadow(color: AppTheme.primary.opacity(0.5), radius: 20)
                
                VStack(spacing: 12) {
                    Text("Yolculuğun Yayınlandı!")
                        .font(AppTheme.Typography.title(32))
                        .foregroundColor(.white)
                    Text("Yol arkadaşların seni bekliyor. Şimdiden iyi yolculuklar!")
                        .font(AppTheme.Typography.body())
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                YolivaPrimaryButton(title: "Ana Sayfaya Dön", action: action)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
            }
        }
    }
}
