import Foundation

struct WorkoutPlan: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var exercises: [WorkoutExercise]
    let createdAt: Date

    init(id: UUID = UUID(), name: String, exercises: [WorkoutExercise], createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.createdAt = createdAt
    }

    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets }
    }
}
