import Foundation

struct WorkoutSession: Identifiable, Codable, Hashable {
    let id: UUID
    let workoutName: String
    let date: Date
    let durationMinutes: Int
    let exerciseCount: Int
    let totalSets: Int

    init(id: UUID = UUID(), workoutName: String, date: Date = .now, durationMinutes: Int, exerciseCount: Int, totalSets: Int) {
        self.id = id
        self.workoutName = workoutName
        self.date = date
        self.durationMinutes = durationMinutes
        self.exerciseCount = exerciseCount
        self.totalSets = totalSets
    }
}
