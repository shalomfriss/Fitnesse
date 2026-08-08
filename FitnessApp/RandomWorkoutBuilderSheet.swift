import SwiftUI

struct RandomWorkoutBuilderSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppStore.self) private var store
    @State private var name = "Random Workout"
    @State private var exercises: [WorkoutExercise] = []
    @State private var showingExercisePicker = false

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Workout name") {
                    TextField("Workout name", text: $name)
                }

                Section("Exercises") {
                    if exercises.isEmpty {
                        ContentUnavailableView {
                            Label("No exercises yet", systemImage: "dumbbell")
                        } description: {
                            Text("Tap the plus button to select an exercise or add one manually.")
                        }
                    } else {
                        ForEach($exercises) { $item in
                            WorkoutExerciseEditor(item: $item)
                        }
                        .onDelete(perform: removeExercises)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button("Add random exercise", systemImage: "plus", action: openExercisePicker)
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(AppTheme.accent)
                    .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                    .padding()
            }
            .scrollContentBackground(.hidden)
            .background(ScreenBackground())
            .navigationTitle("Random Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveWorkout)
                        .disabled(trimmedName.isEmpty || exercises.isEmpty)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePicker(selectedExercises: $exercises)
            }
        }
    }

    private func openExercisePicker() {
        showingExercisePicker = true
    }

    private func removeExercises(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }

    private func saveWorkout() {
        store.addWorkout(WorkoutPlan(name: trimmedName, exercises: exercises))
        dismiss()
    }
}
