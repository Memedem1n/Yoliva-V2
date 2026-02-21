// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/AppTheme.swift
import SwiftUI

/// Yoliva Global Design System: Matched exactly to user-provided screenshots.
struct AppTheme {
    // MARK: - Exact Colors from Screenshots
    static let primary = Color(red: 0.0, green: 0.898, blue: 0.749) // #00E5BF (Neon Teal)
    static let secondary = Color(red: 0.07, green: 0.07, blue: 0.17) // #12122B (Dark Container)
    static let background = Color.black // #000000
    static let accentPink = Color(red: 0.910, green: 0.263, blue: 0.576) // #E84393
    
    // MARK: - Layout Constants
    static let horizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    
    // MARK: - Typography
    struct Typography {
        static func header(_ size: CGFloat = 34) -> Font {
            .system(size: size, weight: .black, design: .rounded)
        }
        
        static func title(_ size: CGFloat = 22) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        
        static func body(_ size: CGFloat = 16) -> Font {
            .system(size: size, weight: .medium, design: .default)
        }
        
        static func numeric(_ size: CGFloat = 18) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
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
