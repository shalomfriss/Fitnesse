import SwiftUI

struct ExercisePicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedExercises: [WorkoutExercise]
    @State private var searchText = ""
    @State private var customExerciseName = ""

    private var trimmedCustomExerciseName: String {
        customExerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var filteredExercises: [Exercise] {
        if searchText.isEmpty { return ExerciseCatalog.all }
        return ExerciseCatalog.all.filter {
            $0.name.localizedStandardContains(searchText) ||
            $0.muscleGroup.localizedStandardContains(searchText) ||
            $0.equipment.localizedStandardContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Add manually") {
                    CustomExerciseEntryView(
                        name: $customExerciseName,
                        canAdd: !trimmedCustomExerciseName.isEmpty,
                        add: addCustomExercise
                    )
                }

                Section("Exercise library") {
                    if filteredExercises.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    } else {
                        ForEach(filteredExercises) { exercise in
                            Button(action: { toggle(exercise) }) {
                                HStack {
                                    ExerciseIllustration(exercise: exercise, compact: true)
                                        .frame(width: 54, height: 54)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(exercise.name)
                                            .foregroundStyle(.primary)
                                        Text("\(exercise.muscleGroup) • \(exercise.equipment)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: isSelected(exercise) ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(isSelected(exercise) ? AppTheme.accent : .secondary)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Exercise, muscle, or equipment")
            .navigationTitle("Choose Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
    }

    private func isSelected(_ exercise: Exercise) -> Bool {
        selectedExercises.contains { $0.exercise.id == exercise.id }
    }

    private func toggle(_ exercise: Exercise) {
        if let index = selectedExercises.firstIndex(where: { $0.exercise.id == exercise.id }) {
            selectedExercises.remove(at: index)
        } else {
            selectedExercises.append(WorkoutExercise(exercise: exercise))
        }
    }

    private func addCustomExercise() {
        guard !trimmedCustomExerciseName.isEmpty else { return }
        let exercise = Exercise(
            name: trimmedCustomExerciseName,
            muscleGroup: "Custom",
            equipment: "Other",
            instructions: "Perform this custom exercise with controlled form."
        )
        selectedExercises.append(WorkoutExercise(exercise: exercise))
        customExerciseName = ""
    }
}
