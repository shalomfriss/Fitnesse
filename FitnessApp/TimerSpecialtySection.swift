import SwiftUI

struct TimerSpecialtySection: View {
    let timers: [TimerPreset]
    let favoriteKeys: Set<String>
    let timerAction: (TimerPreset) -> Void
    let favoriteAction: (TimerPreset) -> Void
    let editAction: (TimerPreset) -> Void
    let deleteAction: (TimerPreset) -> Void
    let countdownAction: () -> Void
    let seeAllAction: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 9, alignment: .top), count: 3)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Specialty Timers")
                    .font(.title3.bold())
                    .foregroundStyle(AppTheme.ink)
                Spacer()
                Button(action: seeAllAction) {
                    Label("See All", systemImage: "chevron.right")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.accent)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Shows all predefined timers")
            }

            LazyVGrid(columns: columns, spacing: 9) {
                ForEach(timers) { timer in
                    TimerCard(
                        timer: timer,
                        style: .specialty,
                        isFavorite: favoriteKeys.contains(TimerLibrarySection.favoriteKey(for: timer)),
                        timerAction: { timerAction(timer) },
                        favoriteAction: { favoriteAction(timer) },
                        edit: { editAction(timer) },
                        delete: { deleteAction(timer) }
                    )
                }

                CountdownShortcutCard(action: countdownAction)
            }
        }
    }
}
