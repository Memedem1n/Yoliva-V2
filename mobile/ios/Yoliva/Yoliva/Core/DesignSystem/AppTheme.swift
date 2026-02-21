// mobile/ios/Yoliva/Core/DesignSystem/AppTheme.swift
import SwiftUI

/// Yoliva Global Design System: Color Palette, Typography, and Haptics.
struct AppTheme {
    // MARK: - Core Colors
    static let electricTeal = Color(red: 0.0, green: 0.898, blue: 0.749) // #00E5BF
    static let yolivaPink = Color(red: 0.910, green: 0.263, blue: 0.576) // #E84393
    static let pureBlack = Color.black
    static let background = Color.black // Added missing background property
    static let cardBackground = Color(white: 0.08)
    
    // MARK: - Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    
    // MARK: - Typography
    struct Typography {
        /// Rounded titles for a modern, friendly feel.
        static func title(_ size: CGFloat = 22) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        
        /// Standard default font for body text readability.
        static func body(_ size: CGFloat = 16) -> Font {
            .system(size: size, weight: .medium, design: .default)
        }
        
        /// Numeric/price font using rounded design.
        static func numeric(_ size: CGFloat = 18) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
    }
    
    // MARK: - Haptic Motor
    /// Central haptic feedback engine for impact interactions.
    static func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Central haptic feedback engine for notification-based interactions (success, error, warning).
    static func notificationHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
