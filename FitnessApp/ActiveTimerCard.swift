import SwiftUI

struct ActiveTimerCard: View {
    let remainingSeconds: Int
    let progress: Double
    let isRunning: Bool
    let toggle: () -> Void
    let reset: () -> Void

    private var timeText: String {
        Duration.seconds(remainingSeconds).formatted(.time(pattern: .minuteSecond))
    }

    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.10), lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(AppTheme.accent, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 4) {
                        Text(timeText)
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .contentTransition(.numericText())
                        Text(isRunning ? "IN PROGRESS" : "READY")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(isRunning ? AppTheme.accent : .secondary)
                    }
                }
                .frame(maxWidth: 210, minHeight: 210)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Timer, \(timeText) remaining")

                Button(isRunning ? "Pause" : "Start timer", systemImage: isRunning ? "pause.fill" : "play.fill", action: toggle)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 76)
                    .background(AppTheme.accent)
                    .clipShape(.rect(cornerRadius: 22))

                Button("Reset timer", systemImage: "arrow.counterclockwise", action: reset)
                    .foregroundStyle(.secondary)
                    .frame(minHeight: 44)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
