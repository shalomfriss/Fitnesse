import SwiftUI

struct TimerActiveBanner: View {
    let timerName: String
    let remainingSeconds: Int
    let isCountUp: Bool
    let isRunning: Bool
    let open: () -> Void

    private var timeText: String {
        if remainingSeconds >= 3_600 {
            return Duration.seconds(remainingSeconds).formatted(.time(pattern: .hourMinuteSecond))
        }
        return Duration.seconds(remainingSeconds).formatted(.time(pattern: .minuteSecond))
    }

    var body: some View {
        Button(action: open) {
            HStack(spacing: 12) {
                Image(systemName: isRunning ? "waveform.path" : "pause.fill")
                    .font(.headline)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 42, height: 42)
                    .background(AppTheme.accent.opacity(0.12))
                    .clipShape(.circle)

                VStack(alignment: .leading, spacing: 3) {
                    Text(isRunning ? "TIMER IN PROGRESS" : "TIMER PAUSED")
                        .font(.caption.bold())
                        .tracking(0.8)
                        .foregroundStyle(AppTheme.secondaryInk)
                    Text(timerName)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                }

                Spacer(minLength: 8)

                Text(timeText)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .foregroundStyle(AppTheme.accent)

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(AppTheme.secondaryInk)
            }
            .padding(13)
            .background(AppTheme.backgroundRaised)
            .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                    .stroke(AppTheme.stroke, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(timerName), \(timeText) \(isCountUp ? "elapsed" : "remaining"), \(isRunning ? "running" : "paused"). Open timer controls.")
    }
}
