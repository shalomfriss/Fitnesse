import Foundation

struct RunSession: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let durationSeconds: Int
    let distanceMeters: Double
    let steps: Int
    let elevationGainMeters: Double
    let averageSpeedMetersPerSecond: Double

    init(
        id: UUID = UUID(),
        date: Date = .now,
        durationSeconds: Int,
        distanceMeters: Double,
        steps: Int,
        elevationGainMeters: Double,
        averageSpeedMetersPerSecond: Double
    ) {
        self.id = id
        self.date = date
        self.durationSeconds = durationSeconds
        self.distanceMeters = distanceMeters
        self.steps = steps
        self.elevationGainMeters = elevationGainMeters
        self.averageSpeedMetersPerSecond = averageSpeedMetersPerSecond
    }
}
