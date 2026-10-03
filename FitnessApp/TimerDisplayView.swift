import SwiftUI

struct TimerDisplayView: View {
    let remainingSeconds: Int
    let isRunning: Bool
    let phaseText: String?
    let roundNumber: Int?
    let isRestPeriod: Bool
    @ScaledMetric(relativeTo: .largeTitle) private var displaySize = 84.0
    @ScaledMetric(relativeTo: .largeTitle) private var roundDisplaySize = 34.0
    private var timeText: String {
        Duration.seconds(remainingSeconds).formatted(.time(pattern: .minuteSecond))
    }

    private var usesActiveColors: Bool {
        isRunning && !isRestPeriod
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topLeading) {
                Text(timeText)
                    .font(.system(size: displaySize, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(usesActiveColors ? AppTheme.onAccent : isRunning ? AppTheme.accent : AppTheme.ink)
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                if let roundNumber {
                    Text("Round \(roundNumber)")
                        .font(.system(size: roundDisplaySize, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                        .foregroundStyle(usesActiveColors ? AppTheme.accent : AppTheme.onAccent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(usesActiveColors ? AppTheme.onAccent : AppTheme.accent)
                        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                        .accessibilityHidden(true)
                }
            }
            if let phaseText {
                Text(phaseText)
                    .font(.headline)
                    .bold()
                    .foregroundStyle(usesActiveColors ? AppTheme.onAccent.opacity(0.86) : .secondary)
            }
        }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(usesActiveColors ? AppTheme.accent : .clear)
            .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
            .padding(.horizontal, usesActiveColors ? 12 : 0)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityLabel("Timer")
            .accessibilityValue(phaseText.map { "\($0), \(timeText) remaining" } ?? "\(timeText) remaining")
    }
}
