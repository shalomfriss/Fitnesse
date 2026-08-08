import Foundation
import Observation

@Observable
final class AppStore {
    var workoutPlans: [WorkoutPlan] { didSet { persist() } }
    var sessions: [WorkoutSession] { didSet { persist() } }
    var timerPresets: [TimerPreset] { didSet { persist() } }
    var nutritionEntries: [NutritionEntry] { didSet { persist() } }
    var runSessions: [RunSession] { didSet { persist() } }
    var dailyCalorieGoal: Int { didSet { persist() } }
    var dailyProteinGoal: Int { didSet { persist() } }
    var displayName: String { didSet { persist() } }

    private let defaults: UserDefaults
    private let storageKey = "pulse.app.data.v1"
    private var isLoading = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        workoutPlans = Self.starterPlans
        sessions = Self.starterSessions
        timerPresets = Self.defaultTimers
        nutritionEntries = Self.starterNutrition
        runSessions = []
        dailyCalorieGoal = 2_300
        dailyProteinGoal = 160
        displayName = "Athlete"
        load()
    }

    var todayNutrition: [NutritionEntry] {
        nutritionEntries.filter { Calendar.current.isDateInToday($0.date) }
    }

    var todayCalories: Int { todayNutrition.reduce(0) { $0 + $1.calories } }
    var todayProtein: Int { todayNutrition.reduce(0) { $0 + $1.protein } }

    func addWorkout(_ workout: WorkoutPlan) {
        workoutPlans.insert(workout, at: 0)
    }

    func updateWorkout(_ workout: WorkoutPlan) {
        guard let index = workoutPlans.firstIndex(where: { $0.id == workout.id }) else { return }
        workoutPlans[index] = workout
    }

    func deleteWorkouts(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            workoutPlans.remove(at: index)
        }
    }

    func logSession(for workout: WorkoutPlan, durationMinutes: Int) {
        sessions.insert(
            WorkoutSession(
                workoutName: workout.name,
                durationMinutes: max(1, durationMinutes),
                exerciseCount: workout.exercises.count,
                totalSets: workout.totalSets
            ),
            at: 0
        )
    }

    func addTimer(_ timer: TimerPreset) {
        timerPresets.append(timer)
    }

    func updateTimer(_ timer: TimerPreset) {
        guard let index = timerPresets.firstIndex(where: { $0.id == timer.id }) else { return }
        timerPresets[index] = timer
    }

    func deleteTimer(_ timer: TimerPreset) {
        guard timer.isCustom else { return }
        timerPresets.removeAll { $0.id == timer.id }
    }

    func addNutrition(_ entry: NutritionEntry) {
        nutritionEntries.insert(entry, at: 0)
    }

    func deleteNutrition(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            nutritionEntries.remove(at: index)
        }
    }

    func addRun(_ run: RunSession) {
        runSessions.insert(run, at: 0)
    }

    func resetSampleData() {
        workoutPlans = Self.starterPlans
        sessions = Self.starterSessions
        timerPresets = Self.defaultTimers
        nutritionEntries = Self.starterNutrition
        runSessions = []
        dailyCalorieGoal = 2_300
        dailyProteinGoal = 160
        displayName = "Athlete"
    }

    private func persist() {
        guard !isLoading else { return }
        let data = StoredData(
            workoutPlans: workoutPlans,
            sessions: sessions,
            timerPresets: timerPresets,
            nutritionEntries: nutritionEntries,
            runSessions: runSessions,
            dailyCalorieGoal: dailyCalorieGoal,
            dailyProteinGoal: dailyProteinGoal,
            displayName: displayName
        )
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = defaults.data(forKey: storageKey),
              let stored = try? JSONDecoder().decode(StoredData.self, from: data) else { return }
        isLoading = true
        workoutPlans = stored.workoutPlans
        sessions = stored.sessions
        timerPresets = stored.timerPresets
        nutritionEntries = stored.nutritionEntries
        runSessions = stored.runSessions ?? []
        dailyCalorieGoal = stored.dailyCalorieGoal
        dailyProteinGoal = stored.dailyProteinGoal
        displayName = stored.displayName
        isLoading = false
    }

    private static let defaultTimers = [30, 60, 120, 180, 240, 300].map {
        TimerPreset(name: $0 < 60 ? "Quick Reset" : "\($0 / 60) Minute", seconds: $0)
    }

    private static let starterPlans: [WorkoutPlan] = [
        WorkoutPlan(name: "Full Body Strength", exercises: [
            WorkoutExercise(exercise: ExerciseCatalog.all[0], sets: 4, reps: 6),
            WorkoutExercise(exercise: ExerciseCatalog.all[9], sets: 4, reps: 8),
            WorkoutExercise(exercise: ExerciseCatalog.all[14], sets: 3, reps: 10)
        ]),
        WorkoutPlan(name: "Fast Conditioning", exercises: [
            WorkoutExercise(exercise: ExerciseCatalog.all[28], sets: 3, reps: 10),
            WorkoutExercise(exercise: ExerciseCatalog.all[31], sets: 4, reps: 30),
            WorkoutExercise(exercise: ExerciseCatalog.all[34], sets: 3, reps: 12)
        ])
    ]

    private static let starterSessions: [WorkoutSession] = [
        WorkoutSession(workoutName: "Upper Body Push", date: .now.addingTimeInterval(-86_400), durationMinutes: 52, exerciseCount: 5, totalSets: 18),
        WorkoutSession(workoutName: "Morning Run", date: .now.addingTimeInterval(-259_200), durationMinutes: 34, exerciseCount: 1, totalSets: 1)
    ]

    private static let starterNutrition: [NutritionEntry] = [
        NutritionEntry(name: "Greek yogurt, berries & granola", calories: 430, protein: 30, carbs: 54, fat: 11)
    ]
}
