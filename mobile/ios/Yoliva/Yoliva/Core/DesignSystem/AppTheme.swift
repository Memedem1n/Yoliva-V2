// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/AppTheme.swift
import SwiftUI

/// Yoliva Global Design System: Premium Color Palette strictly derived from the official Logo.
struct AppTheme {
    // MARK: - Brand Colors (Extracted from Logo.jpg)
    /// Primary Brand Color: Vibrant Royal Blue (#2E5BFF)
    static let primary = Color(red: 0.18, green: 0.36, blue: 1.0)
    
    /// Secondary Brand Color: Deep Space Navy (#12122B)
    static let secondary = Color(red: 0.07, green: 0.07, blue: 0.17)
    
    /// Accent/Highlight Color: Azure Breeze (#00D1FF)
    static let accent = Color(red: 0.0, green: 0.82, blue: 1.0)
    
    // MARK: - Compatibility Aliases (To be phased out)
    static let primaryBlue = primary
    static let electricTeal = primary // Redirecting old Teal references to the new Logo Blue
    static let yolivaPink = Color(red: 0.910, green: 0.263, blue: 0.576) // #E84393 - Retained for Ladies Only
    
    // MARK: - System Colors (Derived for Accessibility & Cohesion)
    static let success = Color(red: 0.0, green: 0.78, blue: 0.32) // Emerald Green
    static let error = Color(red: 1.0, green: 0.09, blue: 0.27)   // Vibrant Crimson
    static let warning = Color(red: 1.0, green: 0.75, blue: 0.0)  // Amber Gold
    
    // MARK: - Neutrals & Surfaces
    static let pureBlack = Color.black
    static let background = Color.black
    static let surface = Color(red: 0.1, green: 0.12, blue: 0.2) // Deep navy tinted surface
    static let cardBackground = Color(white: 0.08)
    
    // MARK: - Text Palette (Accessibility Compliant)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.7, green: 0.75, blue: 0.85) // High contrast blue-gray
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
