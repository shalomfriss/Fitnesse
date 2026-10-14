import SwiftUI

struct TimerCard: View {
    let timer: TimerPreset
    let style: TimerCardStyle
    let isFavorite: Bool
    let timerAction: () -> Void
    let favoriteAction: () -> Void
    let edit: () -> Void
    let delete: () -> Void

    private var cardTitle: String {
        if style == .quick || (style == .mixed && !timer.isCompound && timer.seconds > 0) {
            return timer.compactDurationLabel
        }
        return timer.name
    }

    private var cardDetail: String {
        switch style {
        case .quick:
            timer.expandedDurationLabel
        case .specialty:
            switch timer.name {
            case "Stopwatch": "Track elapsed time"
            case "Lap Timer": "Record lap splits"
            case "Rest Timer": "Between sets"
            default: timer.isCountUp ? "Count up" : timer.expandedDurationLabel
            }
        case .workout:
            workoutDetail
        case .mixed:
            if timer.isCompound {
                workoutDetail
            } else if timer.name == "Stopwatch" || timer.isLapTimer || timer.name == "Rest Timer" {
                cardDetailForSpecialty
            } else {
                timer.expandedDurationLabel
            }
        }
    }

    private var cardDetailForSpecialty: String {
        switch timer.name {
        case "Stopwatch": "Track elapsed time"
        case "Lap Timer": "Record lap splits"
        default: "Between sets"
        }
    }

    private var workoutDetail: String {
        switch timer.name {
        case "Tabata": return "20s work / 10s rest\n8 rounds"
        case "Boxing": return "3 min / 1 min\n12 rounds"
        case "HIIT": return "40s work / 20s rest\n8 rounds"
        case "EMOM": return "Every minute\n10 rounds"
        case "AMRAP": return "As many rounds\nas possible"
        case "For Time": return "Count up\nNo rest"
        default:
            if let intervalLabel = timer.intervalLabel, let rounds = timer.rounds {
                return "\(intervalLabel)\n\(rounds) rounds"
            }
            return timer.isCountUp ? "Count up\nNo rest" : timer.expandedDurationLabel
        }
    }

    private var cardHeight: CGFloat {
        switch style {
        case .quick: 62
        case .workout: 73
        case .specialty: 60
        case .mixed: 73
        }
    }

    var body: some View {
        Button(action: timerAction) {
            VStack(alignment: .leading, spacing: style == .quick ? 1 : 5) {
                HStack(spacing: 4) {
                    Text(cardTitle)
                        .font(style == .quick ? .title3.bold() : .subheadline.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                        .foregroundStyle(AppTheme.ink)

                    Spacer(minLength: 0)

                    Image(systemName: "play.fill")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.accent)
                        .accessibilityHidden(true)
                }

                Text(cardDetail)
                    .font(.caption)
                    .lineSpacing(1)
                    .lineLimit(style == .workout ? 2 : 1)
                    .minimumScaleFactor(0.78)
                    .foregroundStyle(AppTheme.secondaryInk)
                    .padding(.trailing, isFavorite ? 14 : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: cardHeight, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 9)
            .background(AppTheme.backgroundRaised)
            .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                    .stroke(isFavorite ? AppTheme.accent.opacity(0.58) : AppTheme.stroke, lineWidth: 1)
            }
            .overlay(alignment: .bottomTrailing) {
                if isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(AppTheme.accent)
                        .padding(6)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(timer.name), \(cardDetail.replacingOccurrences(of: "\n", with: ", "))\(isFavorite ? ", favorite" : "")")
        .accessibilityHint("Starts the timer. Touch and hold for timer options.")
        .contextMenu {
            Button(isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: isFavorite ? "star.slash" : "star", action: favoriteAction)
            Button("Edit timer", systemImage: "pencil", action: edit)
            if timer.isCustom {
                Button("Delete timer", systemImage: "trash", role: .destructive, action: delete)
            }
        }
    }
}
