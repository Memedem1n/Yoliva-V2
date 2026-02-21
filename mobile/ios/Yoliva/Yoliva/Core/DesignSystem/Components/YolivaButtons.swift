// mobile/ios/Yoliva/Core/DesignSystem/Components/YolivaButtons.swift
import SwiftUI

/// Premium reusable pill-shaped button with spring animations and haptics.
struct YolivaPrimaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let isPink: Bool // Ladies Only mode
    let action: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isPink: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isPink = isPink
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            AppTheme.haptic(.rigid)
            action()
        }) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .tint(.black)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .bold))
                    }
                    Text(title)
                        .font(AppTheme.Typography.title(18))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                ZStack {
                    (isPink ? AppTheme.yolivaPink : AppTheme.electricTeal)
                    
                    // Subtle Inner Glow
                    Capsule()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                }
            )
            .clipShape(Capsule())
            .foregroundColor(.black)
            .shadow(color: (isPink ? AppTheme.yolivaPink : AppTheme.electricTeal).opacity(0.35), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(YolivaButtonStyle())
        .disabled(isLoading)
    }
}

/// Custom button style to provide a fluid, spring-loaded tactile response.
struct YolivaButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.65, blendDuration: 0), value: configuration.isPressed)
    }
}
