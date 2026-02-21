// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/Components/PremiumTabView.swift
import SwiftUI

/// Ultra-Premium, Glassmorphic Tab Bar with Ripple and Burst effects.
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
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            ZStack {
                // 1. Precise Glass Background matching screenshot
                RoundedRectangle(cornerRadius: 35)
                    .fill(Color(red: 0.08, green: 0.08, blue: 0.12).opacity(0.8))
                    .background(.ultraThinMaterial)
                
                // 2. Subtle Rim Light
                RoundedRectangle(cornerRadius: 35)
                    .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
            }
        )
        // 3. Responsive Geometry: Wider and shorter as requested
        .frame(height: 60) 
        .padding(.horizontal, 12) // Increases overall width by reducing side padding
        .padding(.bottom, 25) // Floating above bottom
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
                    
                    // Icon with Burst/Spring
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? AppTheme.primary : .white.opacity(0.6))
                        .symbolEffect(.bounce, value: isSelected)
                }
                
                Text(tab.label)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppTheme.primary : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if isSelected {
                        // Glassy Bubble Highlight (Matched Geometry)
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.08))
                            .matchedGeometryEffect(id: "tab_bubble", in: animation)
                            .shadow(color: AppTheme.primary.opacity(0.2), radius: 10)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func triggerEffects() {
        AppTheme.haptic(.medium)
        
        // Reset and fire ripple
        rippleScale = 0.5
        rippleOpacity = 0.6
        
        withAnimation(.easeOut(duration: 0.5)) {
            rippleScale = 2.0
            rippleOpacity = 0.0
        }
    }
}
