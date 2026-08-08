import Foundation

struct StoredData: Codable {
    let workoutPlans: [WorkoutPlan]
    let sessions: [WorkoutSession]
    let timerPresets: [TimerPreset]
    let nutritionEntries: [NutritionEntry]
    let runSessions: [RunSession]?
    let dailyCalorieGoal: Int
    let dailyProteinGoal: Int
    let displayName: String
}
