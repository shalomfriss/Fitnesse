import SwiftUI

struct TimerCard: View {
    let timer: TimerPreset
    let isActive: Bool
    let isRunning: Bool
    let timerAction: () -> Void
    let edit: () -> Void
    let delete: () -> Void

    private var actionName: String {
        if isActive && isRunning { return "Pause" }
        if isActive { return "Resume" }
        return "Start"
    }

    private var accessibilityDescription: String {
        let description = timer.intervalLabel.map { "\(timer.durationLabel) timer, \($0)" } ?? "\(timer.durationLabel) timer"
        return "\(actionName) \(description)"
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: timerAction) {
                VStack(spacing: 12) {
                    Text(timer.durationLabel)
                        .font(.title)
                        .bold()
                    if let intervalLabel = timer.intervalLabel {
                        Text(intervalLabel)
                            .font(.subheadline)
                            .foregroundStyle(isActive ? Color.black : Color.secondary)
                    }
                    Image(systemName: isActive && isRunning ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .accessibilityHidden(true)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 138, maxHeight: .infinity)
                .background(isActive ? AppTheme.accent : AppTheme.backgroundRaised)
                .foregroundStyle(isActive ? .black : .white)
                .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                        .stroke(isActive ? .clear : AppTheme.stroke, lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(accessibilityDescription)
            .accessibilityHint(isActive ? "Toggles pause and resume" : "Starts immediately")

            Menu("Timer options", systemImage: "ellipsis.circle.fill") {
                Button("Edit timer", systemImage: "pencil", action: edit)
                if timer.isCustom {
                    Button("Delete timer", systemImage: "trash", role: .destructive, action: delete)
                }
            }
            .labelStyle(.iconOnly)
            .font(.title2)
            .foregroundStyle(isActive ? .black : AppTheme.accent)
            .frame(minWidth: 44, minHeight: 44)
            .background(isActive ? Color.black.opacity(0.08) : AppTheme.surfaceStrong)
            .clipShape(.circle)
        }
    }
}
