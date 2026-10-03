import SwiftUI

struct WorkoutExerciseEditor: View {
    @Binding var item: WorkoutExercise

    var body: some View {
        NavigationLink {
            WorkoutExerciseEditView(item: $item)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.exercise.name)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)

                HStack(spacing: 12) {
                    Label("\(item.sets) sets", systemImage: "square.stack.3d.up")
                    Label("\(item.reps) reps", systemImage: "repeat")

                    if item.weightPounds > 0 {
                        Label {
                            Text("\(item.weightPounds, format: .number.precision(.fractionLength(0...1))) lb")
                        } icon: {
                            Image(systemName: "scalemass")
                        }
                    } else {
                        Label("Add weight", systemImage: "scalemass")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryInk)
            }
        }
        .padding(.vertical, 4)
        .accessibilityHint("Opens exercise settings, including weight used")
    }
}
