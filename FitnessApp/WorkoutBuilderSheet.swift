import SwiftUI

struct WorkoutBuilderSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppStore.self) private var store
    private let workout: WorkoutPlan?
    @State private var name: String
    @State private var selectedExercises: [WorkoutExercise]
    @State private var showingExercisePicker = false

    init(workout: WorkoutPlan? = nil) {
        self.workout = workout
        _name = State(initialValue: workout?.name ?? "")
        _selectedExercises = State(initialValue: workout?.exercises ?? [])
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Workout name") {
                    TextField(
                        "Workout name",
                        text: $name,
                        prompt: Text("e.g. Monday Strength")
                            .foregroundStyle(AppTheme.secondaryInk)
                    )
                        .foregroundStyle(AppTheme.ink)
                        .listRowBackground(AppTheme.backgroundRaised)
                }

                Section("Exercises") {
                    if selectedExercises.isEmpty {
                        Button("Add exercises", systemImage: "plus", action: openExercisePicker)
                            .foregroundStyle(AppTheme.accent)
                    } else {
                        ForEach($selectedExercises) { $item in
                            WorkoutExerciseEditor(item: $item)
                        }
                        .onDelete(perform: removeExercises)

                        Button("Add another exercise", systemImage: "plus", action: openExercisePicker)
                            .foregroundStyle(AppTheme.accent)
                    }
                }
                .listRowBackground(AppTheme.backgroundRaised)
            }
            .scrollContentBackground(.hidden)
            .background(ScreenBackground())
            .foregroundStyle(AppTheme.ink)
            .tint(AppTheme.accent)
            .navigationTitle(workout == nil ? "Build Workout" : "Edit Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbarBackground(AppTheme.backgroundRaised, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveWorkout)
                        .disabled(trimmedName.isEmpty || selectedExercises.isEmpty)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePicker(selectedExercises: $selectedExercises)
            }
        }
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func openExercisePicker() {
        showingExercisePicker = true
    }

    private func removeExercises(at offsets: IndexSet) {
        selectedExercises.remove(atOffsets: offsets)
    }

    private func saveWorkout() {
        if let workout {
            store.updateWorkout(
                WorkoutPlan(
                    id: workout.id,
                    name: trimmedName,
                    exercises: selectedExercises,
                    createdAt: workout.createdAt
                )
            )
        } else {
            store.addWorkout(WorkoutPlan(name: trimmedName, exercises: selectedExercises))
        }
        dismiss()
    }
}
