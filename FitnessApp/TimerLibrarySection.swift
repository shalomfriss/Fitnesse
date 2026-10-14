import SwiftUI

struct TimerLibrarySection: View {
    let title: String
    let timers: [TimerPreset]
    let style: TimerCardStyle
    let favoriteKeys: Set<String>
    let showsSeeAll: Bool
    let timerAction: (TimerPreset) -> Void
    let favoriteAction: (TimerPreset) -> Void
    let editAction: (TimerPreset) -> Void
    let deleteAction: (TimerPreset) -> Void
    let seeAllAction: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 9, alignment: .top), count: 3)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(AppTheme.ink)
                Spacer()
                if showsSeeAll {
                    Button(action: seeAllAction) {
                        Label("See All", systemImage: "chevron.right")
                            .labelStyle(.titleAndIcon)
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.accent)
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Shows all predefined timers")
                }
            }

            if timers.isEmpty {
                ContentUnavailableView(
                    "No timers here yet",
                    systemImage: "timer",
                    description: Text("Long-press a timer and add it to Favorites, or create a custom timer.")
                )
                .padding(.vertical, 8)
            } else {
                LazyVGrid(columns: columns, spacing: 9) {
                    ForEach(timers) { timer in
                        TimerCard(
                            timer: timer,
                            style: style,
                            isFavorite: favoriteKeys.contains(Self.favoriteKey(for: timer)),
                            timerAction: { timerAction(timer) },
                            favoriteAction: { favoriteAction(timer) },
                            edit: { editAction(timer) },
                            delete: { deleteAction(timer) }
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    static func favoriteKey(for timer: TimerPreset) -> String {
        timer.isCustom ? timer.id.uuidString : timer.name
    }
}
