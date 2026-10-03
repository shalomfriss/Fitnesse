import SwiftUI

struct ActiveWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppStore.self) private var store
    let workout: WorkoutPlan
    @State private var completedExerciseIDs: Set<UUID> = []
    @State private var startDate = Date.now
    @State private var showingFinishConfirmation = false

    private var progress: Double {
        Double(completedExerciseIDs.count) / Double(max(workout.exercises.count, 1))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ACTIVE WORKOUT")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.accent)
                            Text(workout.name)
                                .font(.largeTitle)
                                .bold()
                            ProgressView(value: progress)
                                .tint(AppTheme.accent)
                            Text("\(completedExerciseIDs.count) of \(workout.exercises.count) exercises complete")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        ForEach(workout.exercises) { item in
                            ActiveExerciseCard(
                                item: item,
                                isComplete: completedExerciseIDs.contains(item.id),
                                toggle: { toggle(item) }
                            )
                        }

                        Button("Finish workout", systemImage: "flag.checkered", action: confirmFinish)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(AppTheme.onAccent)
                            .frame(maxWidth: .infinity, minHeight: 64)
                            .background(AppTheme.accent)
                            .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark", action: dismiss.callAsFunction)
                }
            }
        }
        .confirmationDialog("Finish this workout?", isPresented: $showingFinishConfirmation, titleVisibility: .visible) {
            Button("Save workout", action: finish)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your completed session will appear on the dashboard.")
        }
    }

    private func toggle(_ item: WorkoutExercise) {
        if completedExerciseIDs.contains(item.id) {
            completedExerciseIDs.remove(item.id)
        } else {
            completedExerciseIDs.insert(item.id)
        }
    }

    private func confirmFinish() {
        showingFinishConfirmation = true
    }

    private func finish() {
        let duration = max(1, Int(Date.now.timeIntervalSince(startDate) / 60))
        store.logSession(for: workout, durationMinutes: duration)
        dismiss()
    }
}
