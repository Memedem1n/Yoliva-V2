// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/Modifiers/GlassCardModifier.swift
import SwiftUI

/// Vision Pro-inspired glassmorphism ViewModifier with enhanced depth and responsiveness.
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat
    var addGlow: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // 1. Base Material
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(0.02))
                        .background(.ultraThinMaterial)
                    
                    // 2. Subtle Background Glow (Optional)
                    if addGlow {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(AppTheme.primaryGlow.blur(radius: 20))
                    }
                    
                    // 3. Inner Shadow / Rim Light for Depth
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .clear, .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                // 4. External Stroke definition
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppTheme.glassStroke, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 10)
    }
}

extension View {
    /// Applies a premium responsive glassmorphic card effect.
    func glassCard(cornerRadius: CGFloat = 24, addGlow: Bool = false) -> some View {
        self.modifier(GlassCardModifier(cornerRadius: cornerRadius, addGlow: addGlow))
    }
}
