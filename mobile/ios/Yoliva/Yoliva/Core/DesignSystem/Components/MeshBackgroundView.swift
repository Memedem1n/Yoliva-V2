// mobile/ios/Yoliva/Yoliva/Core/DesignSystem/Components/MeshBackgroundView.swift
import SwiftUI

/// A living, animating background using Mesh Gradients and Blur for a "Vision" feel.
struct MeshBackgroundView: View {
    @State private var animate: Bool = false
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            // Dynamic Glow Blobs
            Circle()
                .fill(AppTheme.primary.opacity(0.15))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(x: animate ? 100 : -100, y: animate ? -200 : 200)
            
            Circle()
                .fill(AppTheme.accent.opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: animate ? -150 : 150, y: animate ? 150 : -150)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}
