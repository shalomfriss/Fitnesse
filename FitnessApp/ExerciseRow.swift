import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        GlassCard {
            HStack(spacing: 14) {
                ExerciseIllustration(exercise: exercise, compact: true)
                    .frame(width: 76, height: 76)
                VStack(alignment: .leading, spacing: 5) {
                    Text(exercise.name).font(.headline)
                    Text("\(exercise.muscleGroup) • \(exercise.equipment)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
        }
    }
}
