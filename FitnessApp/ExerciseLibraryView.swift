import SwiftUI

struct ExerciseLibraryView: View {
    @State private var searchText = ""
    @State private var selectedMuscle = "All"

    private let muscleGroups = ["All", "Chest", "Back", "Legs", "Glutes", "Hamstrings", "Shoulders", "Arms", "Core", "Full Body", "Cardio", "Mobility"]

    private var filteredExercises: [Exercise] {
        ExerciseCatalog.all.filter { exercise in
            let matchesMuscle = selectedMuscle == "All" || exercise.muscleGroup == selectedMuscle
            let matchesSearch = searchText.isEmpty || exercise.name.localizedStandardContains(searchText) || exercise.equipment.localizedStandardContains(searchText) || exercise.muscleGroup.localizedStandardContains(searchText)
            return matchesMuscle && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        FeatureHeader(
                            eyebrow: "EXERCISE LIBRARY",
                            title: "Learn every movement",
                            subtitle: "Search by name, muscle, or equipment.",
                            systemImage: "figure.strengthtraining.traditional"
                        )

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(muscleGroups, id: \.self) { muscle in
                                    Button(muscle) { selectedMuscle = muscle }
                                        .buttonStyle(.bordered)
                                        .tint(selectedMuscle == muscle ? AppTheme.accent : .secondary)
                                        .foregroundStyle(selectedMuscle == muscle ? .black : .primary)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)

                        if filteredExercises.isEmpty {
                            ContentUnavailableView.search
                        } else {
                            Text("^[\(filteredExercises.count) movement](inflect: true)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            ForEach(filteredExercises) { exercise in
                                NavigationLink(value: exercise) { ExerciseRow(exercise: exercise) }
                                    .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .searchable(text: $searchText, prompt: "Search exercises")
            .navigationDestination(for: Exercise.self) { ExerciseDetailView(exercise: $0) }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
