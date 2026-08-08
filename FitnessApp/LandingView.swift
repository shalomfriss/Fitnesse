import SwiftUI

struct LandingView: View {
    let continueAction: () -> Void

    var body: some View {
        ZStack {
            ScreenBackground()

            Circle()
                .fill(AppTheme.accent.opacity(0.13))
                .frame(width: 280, height: 280)
                .blur(radius: 70)
                .offset(x: 150, y: -330)
                .accessibilityHidden(true)

            Circle()
                .fill(AppTheme.blue.opacity(0.11))
                .frame(width: 240, height: 240)
                .blur(radius: 80)
                .offset(x: -150, y: 300)
                .accessibilityHidden(true)

            ScrollView {
                VStack(spacing: 28) {
                    Label("Fitness app X", systemImage: "bolt.heart.fill")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(AppTheme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Everything you need to move forward.")
                            .font(.largeTitle)
                            .bold()
                            .tracking(-1)

                        Text("Plan workouts, track every run, and keep your nutrition goals in one focused place.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    LandingHeroVisual()

                    VStack(spacing: 12) {
                        LandingFeatureRow(
                            title: "Train with purpose",
                            detail: "Build routines and stay on top of every set.",
                            systemImage: "dumbbell.fill",
                            color: AppTheme.accent
                        )
                        LandingFeatureRow(
                            title: "See your momentum",
                            detail: "Track runs, timers, and recent activity.",
                            systemImage: "chart.line.uptrend.xyaxis",
                            color: AppTheme.blue
                        )
                        LandingFeatureRow(
                            title: "Fuel your progress",
                            detail: "Log meals and monitor daily nutrition goals.",
                            systemImage: "fork.knife",
                            color: AppTheme.coral
                        )
                    }

                    VStack(spacing: 12) {
                        Button("Start training", systemImage: "arrow.right", action: continueAction)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(AppTheme.accent)
                            .clipShape(.rect(cornerRadius: AppTheme.cardRadius))

                        Text("No account required. Your data stays on this device.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    LandingView(continueAction: {})
        .preferredColorScheme(.dark)
}
