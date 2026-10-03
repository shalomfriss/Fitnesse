import Foundation

struct WorkoutExercise: Identifiable, Codable, Hashable {
    let id: UUID
    let exercise: Exercise
    var sets: Int
    var reps: Int
    var weightPounds: Double

    init(
        id: UUID = UUID(),
        exercise: Exercise,
        sets: Int = 3,
        reps: Int = 10,
        weightPounds: Double = 0
    ) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.reps = reps
        self.weightPounds = weightPounds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        exercise = try container.decode(Exercise.self, forKey: .exercise)
        sets = try container.decode(Int.self, forKey: .sets)
        reps = try container.decode(Int.self, forKey: .reps)
        weightPounds = try container.decodeIfPresent(Double.self, forKey: .weightPounds) ?? 0
    }
}
