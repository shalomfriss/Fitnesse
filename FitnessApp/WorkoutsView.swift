import SwiftUI

struct WorkoutsView: View {
    @Environment(AppStore.self) private var store
    @State private var showingBuilder = false
    @State private var showingRandomBuilder = false
    @State private var editingWorkout: WorkoutPlan?
    @State private var activeWorkout: WorkoutPlan?

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        FeatureHeader(
                            eyebrow: "WORKOUT BUILDER",
                            title: "Your training",
                            subtitle: "Build a plan. Track every set.",
                            systemImage: "dumbbell.fill"
                        )

                        Button("Build workout", systemImage: "square.and.pencil", action: showBuilder)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(AppTheme.accent)
                            .clipShape(.rect(cornerRadius: AppTheme.smallRadius))

                        Button("Add random workout", systemImage: "plus", action: showRandomBuilder)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(AppTheme.accent)
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(AppTheme.backgroundRaised)
                            .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                            .overlay {
                                RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                                    .stroke(AppTheme.accent, lineWidth: 1)
                            }

                        if store.workoutPlans.isEmpty {
                            ContentUnavailableView {
                                Label("No workouts", systemImage: "dumbbell")
                            } description: {
                                Text("Build your first routine to get started.")
                            } actions: {
                                Button("Build a workout", action: showBuilder)
                                    .buttonStyle(.borderedProminent)
                            }
                        } else {
                            ForEach(store.workoutPlans) { workout in
                                WorkoutCard(
                                    workout: workout,
                                    start: { start(workout) },
                                    edit: { edit(workout) },
                                    delete: { delete(workout) }
                                )
                            }
                        }

                        if !store.sessions.isEmpty {
                            Text("Workout history")
                                .font(.title3)
                                .bold()
                                .padding(.top, 6)
                            GlassCard {
                                VStack(spacing: 18) {
                                    ForEach(store.sessions.prefix(8)) { session in
                                        SessionRow(session: session)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showingBuilder) {
            WorkoutBuilderSheet()
        }
        .sheet(isPresented: $showingRandomBuilder) {
            RandomWorkoutBuilderSheet()
        }
        .sheet(item: $editingWorkout) { workout in
            WorkoutBuilderSheet(workout: workout)
        }
        .fullScreenCover(item: $activeWorkout) { workout in
            ActiveWorkoutView(workout: workout)
        }
    }

    private func showBuilder() {
        showingBuilder = true
    }

    private func showRandomBuilder() {
        showingRandomBuilder = true
    }

    private func start(_ workout: WorkoutPlan) {
        activeWorkout = workout
    }

    private func edit(_ workout: WorkoutPlan) {
        editingWorkout = workout
    }

    private func delete(_ workout: WorkoutPlan) {
        store.workoutPlans.removeAll { $0.id == workout.id }
    }
}
