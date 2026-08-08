import Foundation

struct TimerPreset: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var seconds: Int
    var isCustom: Bool
    var rounds: Int?
    var workSeconds: Int?
    var restSeconds: Int?

    init(
        id: UUID = UUID(),
        name: String,
        seconds: Int,
        isCustom: Bool = false,
        rounds: Int? = nil,
        workSeconds: Int? = nil,
        restSeconds: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.seconds = seconds
        self.isCustom = isCustom
        self.rounds = rounds
        self.workSeconds = workSeconds
        self.restSeconds = restSeconds
    }

    var isCompound: Bool {
        guard let rounds, let workSeconds, let restSeconds else { return false }
        return rounds > 0 && workSeconds > 0 && restSeconds > 0
    }

    var initialSeconds: Int {
        if isCompound, let workSeconds {
            workSeconds
        } else {
            seconds
        }
    }

    var durationLabel: String {
        if isCompound, let rounds {
            return "\(rounds) rounds"
        }
        return Self.durationText(seconds)
    }

    var intervalLabel: String? {
        guard isCompound, let workSeconds, let restSeconds else { return nil }
        return "\(Self.durationText(workSeconds)) work • \(Self.durationText(restSeconds)) rest"
    }

    private static func durationText(_ seconds: Int) -> String {
        if seconds < 60 { return "\(seconds) sec" }
        let minutes = seconds / 60
        let remainder = seconds % 60
        return remainder == 0 ? "\(minutes) min" : "\(minutes)m \(remainder)s"
    }
}
