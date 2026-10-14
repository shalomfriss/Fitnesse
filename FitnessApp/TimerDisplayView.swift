import SwiftUI

struct TimerDisplayView: View {
    let timeText: String
    let phaseLabel: String
    let progress: Double
    let nextPhaseLabel: String?
    let nextPhaseSeconds: Int?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .largeTitle) private var timerFontSize = 80.0
    @ScaledMetric(relativeTo: .headline) private var phaseFontSize = 17.0

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let progressValue = min(max(progress, 0), 1)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.surfaceStrong, AppTheme.background],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(size * 0.105)
                    .overlay {
                        Circle()
                            .stroke(Color.white.opacity(0.075), lineWidth: 1)
                            .padding(size * 0.105)
                    }
                    .shadow(color: .black.opacity(0.55), radius: 22, y: 12)

                Circle()
                    .stroke(Color.white.opacity(0.055), lineWidth: 1)
                    .padding(size * 0.035)

                ForEach(0..<72, id: \.self) { index in
                    Capsule()
                        .fill(Double(index) / 72 <= progressValue ? AppTheme.accent.opacity(0.9) : Color.white.opacity(0.10))
                        .frame(width: index.isMultiple(of: 6) ? 2.2 : 1.4, height: index.isMultiple(of: 6) ? 9 : 5)
                        .offset(y: -size * 0.465)
                        .rotationEffect(.degrees(Double(index) * 5))
                        .accessibilityHidden(true)
                }

                Circle()
                    .trim(from: 0, to: progressValue)
                    .stroke(AppTheme.accent.opacity(0.48), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .blur(radius: 8)
                    .padding(size * 0.055)
                    .rotationEffect(.degrees(-90))

                Circle()
                    .trim(from: 0, to: progressValue)
                    .stroke(
                        LinearGradient(colors: [AppTheme.accent, Color(red: 1.0, green: 0.93, blue: 0.35)], startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .shadow(color: AppTheme.accent.opacity(0.35), radius: 8)
                    .padding(size * 0.055)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: size * 0.035) {
                    Text(phaseLabel.uppercased())
                        .font(.system(size: CGFloat(phaseFontSize), weight: .medium, design: .rounded))
                        .tracking(7)
                        .foregroundStyle(AppTheme.secondaryInk)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text(timeText)
                        .font(.system(size: min(CGFloat(timerFontSize), size * 0.235), weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.62)
                        .foregroundStyle(AppTheme.accent)
                        .shadow(color: AppTheme.accent.opacity(0.46), radius: 14)

                    if let nextPhaseLabel, let nextPhaseSeconds {
                        VStack(spacing: 3) {
                            Rectangle()
                                .fill(AppTheme.stroke)
                                .frame(height: 1)
                                .padding(.horizontal, size * 0.16)
                                .padding(.bottom, 4)
                            Text("NEXT: \(nextPhaseLabel.uppercased())")
                                .font(.caption.bold())
                                .tracking(2.6)
                                .foregroundStyle(AppTheme.secondaryInk)
                            Text(Self.format(nextPhaseSeconds))
                                .font(.system(.title2, design: .rounded, weight: .medium))
                                .monospacedDigit()
                                .foregroundStyle(AppTheme.secondaryInk)
                        }
                        .padding(.top, size * 0.015)
                    }
                }
                .padding(.horizontal, size * 0.13)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(phaseLabel), \(timeText)")
            .animation(reduceMotion ? nil : .linear(duration: 0.25), value: progressValue)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private static func format(_ seconds: Int) -> String {
        let duration = Duration.seconds(max(0, seconds))
        return duration.formatted(.time(pattern: .minuteSecond))
    }
}
