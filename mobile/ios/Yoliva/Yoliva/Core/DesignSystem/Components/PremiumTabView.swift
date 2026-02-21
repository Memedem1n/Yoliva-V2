// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/Components/PremiumTabView.swift
import SwiftUI

/// A high-fidelity, floating glassmorphic Tab Bar matching the user's reference image.
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
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                        selection = tab
                        AppTheme.haptic(.light)
                    }
                }
            }
        }
        .padding(8)
        .background(
            ZStack {
                // Background of the whole bar
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color(red: 0.05, green: 0.05, blue: 0.07)) // Very dark navy
                    .background(.ultraThinMaterial)
                
                // Subtle border
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

struct TabItemButton: View {
    let tab: YolivaTab
    let isSelected: Bool
    var animation: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                // Icon
                if tab == .profile {
                    // Profile uses an avatar style
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 28, height: 28)
                        .overlay(Image(systemName: "person.fill").font(.system(size: 14)))
                        .overlay(Circle().stroke(isSelected ? AppTheme.primary : Color.clear, lineWidth: 1.5))
                } else {
                    Image(systemName: tab.icon)
                        .font(.system(size: 22, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? AppTheme.primary : .white.opacity(0.8))
                }
                
                // Label
                Text(tab.label)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppTheme.primary : .white.opacity(0.8))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(
                ZStack {
                    if isSelected {
                        // Sliding highlight pill
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.08))
                            .matchedGeometryEffect(id: "tab_highlight", in: animation)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 4)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

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
        case .rides: return "Yolculukların"
        case .inbox: return "Gelen Kutusu"
        case .profile: return "Profil"
        }
    }
}
