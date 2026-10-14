import SwiftUI

struct ScreenBackground: View {
    var body: some View {
        ZStack {
            AppTheme.background

            RadialGradient(
                colors: [Color.white.opacity(0.035), .clear],
                center: .topLeading,
                startRadius: 40,
                endRadius: 430
            )

            RadialGradient(
                colors: [AppTheme.accent.opacity(0.065), .clear],
                center: .bottomTrailing,
                startRadius: 20,
                endRadius: 360
            )

            LinearGradient(
                colors: [.clear, Color.black.opacity(0.42)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
