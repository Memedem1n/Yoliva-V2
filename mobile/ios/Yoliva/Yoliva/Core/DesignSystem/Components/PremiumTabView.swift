// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/Components/PremiumTabView.swift
import SwiftUI

/// Ultra-Premium, Floating Capsule Tab Bar matching the reference exactly.
struct PremiumTabView: View {
    @Binding var selection: YolivaTab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(YolivaTab.allCases, id: \.self) { tab in
                TabItemButton(
                    tab: tab,
                    isSelected: selection == tab,
                    animation: animation
                ) {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.2)) {
                        selection = tab
                    }
                }
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .background(
            ZStack {
                // 1. Solid High-Contrast Background (Matches reference)
                // Using a very dark gray/almost black to stand out against the pure black app background
                Capsule()
                    .fill(Color(red: 0.11, green: 0.11, blue: 0.13)) 
                    .shadow(color: Color.black.opacity(0.5), radius: 20, y: 10) // Deep shadow for lift
                
                // 2. Subtle Border for Definition
                Capsule()
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            }
        )
        // 3. Layout: Floating Capsule Constraints
        .frame(height: 64) 
        .padding(.horizontal, 24) // Margins from screen edges
        .padding(.bottom, 10) // Float above home indicator
    }
}

struct TabItemButton: View {
    let tab: YolivaTab
    let isSelected: Bool
    var animation: Namespace.ID
    let action: () -> Void
    
    @State private var rippleScale: CGFloat = 0.0
    @State private var rippleOpacity: Double = 0.0
    
    var body: some View {
        Button(action: {
            triggerEffects()
            action()
        }) {
            VStack(spacing: 4) {
                ZStack {
                    // Water Drop / Ripple Effect
                    Circle()
                        .fill(AppTheme.primary.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .scaleEffect(rippleScale)
                        .opacity(rippleOpacity)
                    
                    // Icon
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .medium)) // Slightly larger icons
                        .foregroundColor(isSelected ? AppTheme.primary : .gray)
                        .symbolEffect(.bounce, value: isSelected)
                }
                
                // Label (Only show if needed or simplify like the ref image)
                if isSelected {
                    Text(tab.label)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppTheme.primary)
                        .transition(.scale.combined(with: .opacity))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if isSelected {
                        // Subtle Active Indicator (Behind icon)
                        Capsule()
                            .fill(AppTheme.primary.opacity(0.1))
                            .frame(height: 40)
                            .matchedGeometryEffect(id: "tab_bubble", in: animation)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func triggerEffects() {
        AppTheme.haptic(.medium)
        rippleScale = 0.5
        rippleOpacity = 0.6
        withAnimation(.easeOut(duration: 0.5)) {
            rippleScale = 2.0
            rippleOpacity = 0.0
        }
    }
}

/// Enum defining the main navigation tabs.
enum YolivaTab: Int, CaseIterable {
    case search, publish, rides, inbox, profile
    
    var icon: String {
        switch self {
        case .search: return "magnifyingglass"
        case .publish: return "plus.circle"
        case .rides: return "car.2"
        case .inbox: return "bubble.left.and.bubble.right"
        case .profile: return "person.crop.circle"
        }
    }
    
    var label: String {
        switch self {
        case .search: return "Ara"
        case .publish: return "Yayınla"
        case .rides: return "Yolculuk"
        case .inbox: return "Mesajlar"
        case .profile: return "Profil"
        }
    }
}
