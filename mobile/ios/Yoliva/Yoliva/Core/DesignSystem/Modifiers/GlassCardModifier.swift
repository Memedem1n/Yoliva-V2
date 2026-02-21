// mobile/ios/Yoliva/Core/DesignSystem/Modifiers/GlassCardModifier.swift
import SwiftUI

/// Vision Pro-inspired glassmorphism ViewModifier.
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial) // Dynamic system material
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.12), lineWidth: 1) // Subtle border for definition
            )
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 8) // Soft shadow for depth
    }
}

extension View {
    /// Applies a premium glassmorphic card effect to any view.
    /// - Parameter cornerRadius: The corner radius for the card. Defaults to 24.
    func glassCard(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}
