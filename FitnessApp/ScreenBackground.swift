import SwiftUI

struct ScreenBackground: View {
    var body: some View {
        ZStack {
            AppTheme.background

            RadialGradient(
                colors: [Color.white.opacity(0.88), .clear],
                center: .topLeading,
                startRadius: 40,
                endRadius: 430
            )

            RadialGradient(
                colors: [AppTheme.accent.opacity(0.075), .clear],
                center: .bottomTrailing,
                startRadius: 20,
                endRadius: 360
            )

            LinearGradient(
                colors: [.clear, AppTheme.ink.opacity(0.025)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
