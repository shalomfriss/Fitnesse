import SwiftUI

struct WorkoutExerciseEditView: View {
    @Binding var item: WorkoutExercise
    @FocusState private var isWeightFocused: Bool

    var body: some View {
        Form {
            Section {
                HStack(spacing: 16) {
                    ExerciseIllustration(exercise: item.exercise, compact: true)
                        .frame(width: 72, height: 72)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.exercise.name)
                            .font(.headline)
                        Text("\(item.exercise.muscleGroup) • \(item.exercise.equipment)")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryInk)
                    }
                }
                .padding(.vertical, 4)
            }

            Section {
                LabeledContent("Weight") {
                    HStack(spacing: 8) {
                        TextField(
                            "0",
                            value: $item.weightPounds,
                            format: .number.precision(.fractionLength(0...1))
                        )
                        .keyboardType(.decimalPad)
                        .foregroundStyle(AppTheme.ink)
                        .multilineTextAlignment(.trailing)
                        .focused($isWeightFocused)
                        .frame(minWidth: 88, minHeight: 44)
                        .accessibilityLabel("Weight in pounds")

                        Text("lb")
                            .foregroundStyle(AppTheme.secondaryInk)
                    }
                }
            } header: {
                Text("Weight used")
            } footer: {
                Text("Enter the weight used for this exercise. Use 0 for bodyweight.")
            }

            Section("Sets and reps") {
                Stepper("\(item.sets) sets", value: $item.sets, in: 1...20)
                Stepper("\(item.reps) reps", value: $item.reps, in: 1...100)
            }
        }
        .scrollContentBackground(.hidden)
        .background(ScreenBackground())
        .foregroundStyle(AppTheme.ink)
        .tint(AppTheme.accent)
        .navigationTitle("Edit Exercise")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbarBackground(AppTheme.backgroundRaised, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done", action: dismissKeyboard)
            }
        }
    }

    private func dismissKeyboard() {
        isWeightFocused = false
    }
}
