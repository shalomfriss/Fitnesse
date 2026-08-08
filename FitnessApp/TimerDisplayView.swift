import SwiftUI

struct TimerDisplayView: View {
    let remainingSeconds: Int
    let isRunning: Bool
    let phaseText: String?
    let roundNumber: Int?
    let isRestPeriod: Bool
    @ScaledMetric(relativeTo: .largeTitle) private var displaySize = 84.0
    @ScaledMetric(relativeTo: .largeTitle) private var roundDisplaySize = 34.0
    private let darkDisplayColor = Color(red: 0.035, green: 0.055, blue: 0.10)

    private var timeText: String {
        Duration.seconds(remainingSeconds).formatted(.time(pattern: .minuteSecond))
    }

    private var usesActiveColors: Bool {
        isRunning && !isRestPeriod
    }

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 12) {
                if let roundNumber {
                    Text(roundNumber, format: .number)
                        .font(.system(size: roundDisplaySize, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                        .foregroundStyle(usesActiveColors ? AppTheme.accent : darkDisplayColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(usesActiveColors ? darkDisplayColor : AppTheme.accent)
                        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                        .accessibilityHidden(true)
                }

                Text(timeText)
                    .font(.system(size: displaySize, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
                    .foregroundStyle(usesActiveColors ? darkDisplayColor : isRunning ? AppTheme.accent : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            if let phaseText {
                Text(phaseText)
                    .font(.headline)
                    .bold()
                    .foregroundStyle(usesActiveColors ? darkDisplayColor : .secondary)
            }
        }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(usesActiveColors ? AppTheme.accent : .clear)
            .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
            .padding(.horizontal, usesActiveColors ? 12 : 0)
            .accessibilityLabel("Timer")
            .accessibilityValue(phaseText.map { "\($0), \(timeText) remaining" } ?? "\(timeText) remaining")
    }
}
