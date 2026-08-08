import SwiftUI

struct LandingHeroVisual: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.backgroundRaised, AppTheme.accent.opacity(0.13)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .stroke(AppTheme.stroke, lineWidth: 1)

            HStack(spacing: 24) {
                ZStack {
                    Circle()
                        .stroke(AppTheme.surfaceStrong, lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: 0.76)
                        .stroke(AppTheme.accent, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text("76%")
                            .font(.title2)
                            .bold()
                        Text("GOAL")
                            .font(.footnote)
                            .bold()
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 116, height: 116)

                VStack(alignment: .leading, spacing: 14) {
                    Label("4 day streak", systemImage: "flame.fill")
                        .foregroundStyle(AppTheme.coral)
                    Label("3 workouts", systemImage: "dumbbell.fill")
                        .foregroundStyle(AppTheme.accent)
                    Label("82 active min", systemImage: "clock.fill")
                        .foregroundStyle(AppTheme.blue)
                }
                .font(.subheadline)
                .bold()
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, minHeight: 176)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Example weekly progress: 76 percent of goal, a four day streak, three workouts, and 82 active minutes")
    }
}

#Preview {
    LandingHeroVisual()
        .padding()
        .background(AppTheme.background)
        .preferredColorScheme(.dark)
}
