import SwiftUI

struct ActiveExerciseCard: View {
    let item: WorkoutExercise
    let isComplete: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            GlassCard {
                HStack(spacing: 14) {
                    Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundStyle(isComplete ? AppTheme.accent : .secondary)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.exercise.name)
                            .font(.headline)
                            .strikethrough(isComplete)
                        Text("\(item.sets) sets × \(item.reps) reps")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityHint(isComplete ? "Marks exercise incomplete" : "Marks exercise complete")
    }
}
