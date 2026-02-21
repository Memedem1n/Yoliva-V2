// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/Modifiers/GlassCardModifier.swift
import SwiftUI

/// Updated Card Modifier matching the dark, sharp-bordered style from screenshots.
struct CustomCardModifier: ViewModifier {
    var cornerRadius: CGFloat
    var borderOpacity: CGFloat = 0.1
    
    func body(content: Content) -> some View {
        content
            .background(AppTheme.secondary)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(borderOpacity), lineWidth: 1)
            )
    }
}

extension View {
    func yolivaCard(cornerRadius: CGFloat = 24, borderOpacity: CGFloat = 0.1) -> some View {
        self.modifier(CustomCardModifier(cornerRadius: cornerRadius, borderOpacity: borderOpacity))
    }
    
    // Maintain legacy glassCard for compatibility or specific needs
    func glassCard(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(CustomCardModifier(cornerRadius: cornerRadius))
    }
}
