import Foundation

struct WorkoutExercise: Identifiable, Codable, Hashable {
    let id: UUID
    let exercise: Exercise
    var sets: Int
    var reps: Int

    init(id: UUID = UUID(), exercise: Exercise, sets: Int = 3, reps: Int = 10) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.reps = reps
    }
}
