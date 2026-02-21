// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/AppTheme.swift
import SwiftUI

/// Yoliva Global Design System: Premium Color Palette strictly derived from the official Logo.
struct AppTheme {
    // MARK: - Brand Colors (Extracted from Logo.jpg)
    static let primary = Color(red: 0.18, green: 0.36, blue: 1.0) // #2E5BFF
    static let secondary = Color(red: 0.07, green: 0.07, blue: 0.17) // #12122B
    static let accent = Color(red: 0.0, green: 0.82, blue: 1.0) // #00D1FF
    
    // MARK: - Glow & Depth Colors
    static let primaryGlow = primary.opacity(0.3)
    static let accentGlow = accent.opacity(0.4)
    static let glassStroke = Color.white.opacity(0.15)
    static let rimLight = Color.white.opacity(0.1)
    
    // MARK: - Compatibility Aliases
    static let primaryBlue = primary
    static let electricTeal = primary
    static let yolivaPink = Color(red: 0.910, green: 0.263, blue: 0.576) // #E84393
    
    // MARK: - System Colors
    static let success = Color(red: 0.0, green: 0.78, blue: 0.32)
    static let error = Color(red: 1.0, green: 0.09, blue: 0.27)
    static let warning = Color(red: 1.0, green: 0.75, blue: 0.0)
    
    // MARK: - Neutrals & Surfaces
    static let pureBlack = Color.black
    static let background = Color(red: 0.02, green: 0.02, blue: 0.05) // Near-black navy
    static let surface = Color(red: 0.1, green: 0.12, blue: 0.2).opacity(0.4)
    
    // MARK: - Text Palette
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.7, green: 0.75, blue: 0.85)
    static let textMuted = Color.white.opacity(0.4)
    
    // MARK: - Typography
    struct Typography {
        static func title(_ size: CGFloat = 22) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        static func body(_ size: CGFloat = 16) -> Font {
            .system(size: size, weight: .medium, design: .default)
        }
        static func numeric(_ size: CGFloat = 18) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
    }
    
    // MARK: - Haptic Motor
    static func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func notificationHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
