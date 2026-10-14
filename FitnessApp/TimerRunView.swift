import SwiftUI

struct TimerRunView: View {
    let timer: TimerPreset
    let remainingSeconds: Int
    let elapsedSeconds: Int
    let remainingSessionSeconds: Int?
    let totalSeconds: Int?
    let phaseProgress: Double
    let currentRound: Int?
    let totalRounds: Int?
    let isRestPeriod: Bool
    let isCountUp: Bool
    let isRunning: Bool
    let isPaused: Bool
    let nextPhaseLabel: String?
    let nextPhaseSeconds: Int?
    let lapCumulativeTimes: [Int]
    @Binding var soundEnabled: Bool
    @Binding var hapticsEnabled: Bool
    @Binding var timerSoundStyleRawValue: String
    let back: () -> Void
    let togglePause: () -> Void
    let skipPrevious: () -> Void
    let skipNext: () -> Void
    let recordLap: () -> Void
    let restart: () -> Void
    let reset: () -> Void
    let end: () -> Void

    private var isComplete: Bool {
        !isCountUp && !isRunning && !isPaused && remainingSeconds == 0
    }

    private var phaseLabel: String {
        if isComplete { return "COMPLETE" }
        if timer.isLapTimer { return "LAP TIME" }
        if isCountUp { return timer.name == "For Time" ? "FOR TIME" : "STOPWATCH" }
        if timer.isCompound { return isRestPeriod ? "REST" : "WORK" }
        return "TIMER"
    }

    private var controlLabel: String {
        if isRunning { return "Pause timer" }
        if isPaused { return "Resume timer" }
        return "Restart timer"
    }

    private var timerSoundStyle: TimerSoundStyle {
        TimerSoundStyle(rawValue: timerSoundStyleRawValue) ?? .classic
    }

    private var lastLapSeconds: Int? {
        guard let last = lapCumulativeTimes.last else { return nil }
        return max(last - (lapCumulativeTimes.dropLast().last ?? 0), 0)
    }

    private var visibleLapIndexes: [Int] {
        Array((max(0, lapCumulativeTimes.count - 3)..<lapCumulativeTimes.count).reversed())
    }

    var body: some View {
        GeometryReader { geometry in
            let ringSize = min(
                geometry.size.width - 36,
                geometry.size.height * (timer.isLapTimer ? 0.34 : 0.44)
            )

            ZStack {
                ScreenBackground()

                VStack(spacing: 0) {
                    topBar
                    timerHeading
                        .padding(.top, 12)

                    Spacer(minLength: 2)

                    TimerDisplayView(
                        timeText: Self.format(remainingSeconds),
                        phaseLabel: phaseLabel,
                        progress: phaseProgress,
                        nextPhaseLabel: nextPhaseLabel,
                        nextPhaseSeconds: nextPhaseSeconds
                    )
                    .frame(width: ringSize, height: ringSize)

                    Spacer(minLength: 8)

                    statsPanel

                    if timer.isLapTimer {
                        lapHistory
                            .padding(.top, 8)
                    }

                    Spacer(minLength: 10)

                    controls

                    Button(action: end) {
                        Label("End Timer", systemImage: "stop.fill")
                            .font(.headline.bold())
                            .foregroundStyle(AppTheme.accent)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(AppTheme.backgroundRaised)
                            .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                            .overlay {
                                RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                                    .stroke(AppTheme.stroke, lineWidth: 1)
                            }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 14)
                }
                .padding(.horizontal, 18)
                .padding(.top, 5)
                .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    private var topBar: some View {
        HStack {
            Button(action: back) {
                Label("Timers", systemImage: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(AppTheme.accent)
                    .frame(minHeight: 44)
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                soundEnabled.toggle()
            } label: {
                Image(systemName: soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.title3)
                    .foregroundStyle(AppTheme.ink)
                    .frame(width: 44, height: 44)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(soundEnabled ? "Mute timer sounds" : "Enable timer sounds")

            Menu("Timer settings", systemImage: "gearshape.fill") {
                Toggle("Haptics", isOn: $hapticsEnabled)
                Picker("Timer sound", selection: $timerSoundStyleRawValue) {
                    ForEach(TimerSoundStyle.allCases) { style in
                        Text(style.title).tag(style.rawValue)
                    }
                }

                Button("Preview \(timerSoundStyle.title)", systemImage: "play.fill") {
                    TimerSound.play(timerSoundStyle)
                }
                Divider()
                Button("Restart timer", systemImage: "arrow.counterclockwise", action: restart)
                Button("End timer", systemImage: "stop.fill", role: .destructive, action: end)
            }
            .labelStyle(.iconOnly)
            .font(.title3)
            .foregroundStyle(AppTheme.ink)
            .frame(width: 44, height: 44)
        }
    }

    private var timerHeading: some View {
        VStack(spacing: 5) {
            Text(timer.name.uppercased())
                .font(.system(.title2, design: .rounded, weight: .medium))
                .tracking(6)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .foregroundStyle(AppTheme.ink)

            if timer.isLapTimer {
                Text("LAP \(lapCumulativeTimes.count + 1)")
                    .font(.caption.bold())
                    .tracking(2.8)
                    .foregroundStyle(AppTheme.secondaryInk)
                    .contentTransition(.numericText())
            } else if let currentRound, let totalRounds {
                Text("ROUND \(currentRound) OF \(totalRounds)")
                    .font(.caption.bold())
                    .tracking(2.8)
                    .foregroundStyle(AppTheme.secondaryInk)
                    .contentTransition(.numericText())
            } else if isPaused {
                Text("PAUSED")
                    .font(.caption.bold())
                    .tracking(2.8)
                    .foregroundStyle(AppTheme.secondaryInk)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    private var statsPanel: some View {
        HStack(spacing: 0) {
            if timer.isLapTimer {
                statColumn(title: "ELAPSED", value: Self.format(elapsedSeconds))
                Rectangle()
                    .fill(AppTheme.stroke)
                    .frame(width: 1, height: 42)
                statColumn(title: "LAPS", value: "\(lapCumulativeTimes.count)")
                Rectangle()
                    .fill(AppTheme.stroke)
                    .frame(width: 1, height: 42)
                statColumn(title: "LAST LAP", value: lastLapSeconds.map(Self.format) ?? "—")
            } else {
                statColumn(title: "ELAPSED", value: Self.format(elapsedSeconds))
                Rectangle()
                    .fill(AppTheme.stroke)
                    .frame(width: 1, height: 42)
                statColumn(title: "REMAINING", value: remainingSessionSeconds.map(Self.format) ?? "—")
                Rectangle()
                    .fill(AppTheme.stroke)
                    .frame(width: 1, height: 42)
                statColumn(title: "TOTAL", value: totalSeconds.map(Self.format) ?? "—")
            }
        }
        .padding(.vertical, 12)
        .background(AppTheme.backgroundRaised)
        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                .stroke(AppTheme.stroke, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private var lapHistory: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 12) {
                Text("LAP SPLITS")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("SPLIT")
                    .frame(width: 58, alignment: .trailing)
                Text("TOTAL")
                    .frame(width: 58, alignment: .trailing)
            }
            .font(.system(size: 9, weight: .semibold))
            .tracking(0.7)
            .foregroundStyle(AppTheme.secondaryInk)

            if visibleLapIndexes.isEmpty {
                Text("Tap Lap to record your first split")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryInk)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ForEach(visibleLapIndexes, id: \.self) { index in
                    let cumulative = lapCumulativeTimes[index]
                    let previous = index == 0 ? 0 : lapCumulativeTimes[index - 1]

                    HStack(spacing: 12) {
                        Text("LAP \(index + 1)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(Self.format(max(cumulative - previous, 0)))
                            .frame(width: 58, alignment: .trailing)
                        Text(Self.format(cumulative))
                            .frame(width: 58, alignment: .trailing)
                    }
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .monospacedDigit()
                    .foregroundStyle(AppTheme.ink)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(AppTheme.backgroundRaised)
        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                .stroke(AppTheme.stroke, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private func statColumn(title: String, value: String) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption2.weight(.medium))
                .tracking(0.8)
                .foregroundStyle(AppTheme.secondaryInk)
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(AppTheme.accent)
        }
        .frame(maxWidth: .infinity)
    }

    private var controls: some View {
        HStack(spacing: 16) {
            if timer.isLapTimer {
                sideControl(
                    title: "Lap",
                    systemImage: "flag.fill",
                    accessibilityLabel: "Record lap split",
                    action: recordLap,
                    isDisabled: !isRunning
                )
            } else {
                sideControl(
                    title: "Skip",
                    systemImage: "backward.end.fill",
                    accessibilityLabel: "Skip to previous phase",
                    action: skipPrevious
                )
            }

            pauseControl

            if timer.isLapTimer {
                sideControl(
                    title: "Reset",
                    systemImage: "arrow.counterclockwise",
                    accessibilityLabel: "Reset lap timer",
                    action: reset
                )
            } else {
                sideControl(
                    title: "Skip",
                    systemImage: "forward.end.fill",
                    accessibilityLabel: "Skip to next phase",
                    action: skipNext
                )
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var pauseControl: some View {
        Button(action: togglePause) {
            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 120, height: 96)
                .background(AppTheme.backgroundRaised)
                .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                        .stroke(AppTheme.accent, lineWidth: 2)
                }
                .shadow(color: AppTheme.accent.opacity(0.22), radius: 14)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(controlLabel)
        .accessibilityHint("Pauses, resumes, or restarts the current timer")
    }

    private func sideControl(
        title: String,
        systemImage: String,
        accessibilityLabel: String,
        action: @escaping () -> Void,
        isDisabled: Bool = false
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.ink)
            }
            .frame(width: 82, height: 88)
            .background(AppTheme.backgroundRaised)
            .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                    .stroke(AppTheme.stroke, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.55 : 1)
        .accessibilityLabel(accessibilityLabel)
    }

    private static func format(_ seconds: Int) -> String {
        let duration = Duration.seconds(max(0, seconds))
        if seconds >= 3_600 {
            return duration.formatted(.time(pattern: .hourMinuteSecond))
        }
        return duration.formatted(.time(pattern: .minuteSecond))
    }
}
