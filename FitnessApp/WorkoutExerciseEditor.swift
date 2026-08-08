import SwiftUI

struct WorkoutExerciseEditor: View {
    @Binding var item: WorkoutExercise

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.exercise.name)
                .font(.headline)
            HStack {
                Stepper("\(item.sets) sets", value: $item.sets, in: 1...20)
                Divider()
                Stepper("\(item.reps) reps", value: $item.reps, in: 1...100)
            }
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}
