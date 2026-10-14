import Foundation

struct TimerPreset: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var seconds: Int
    var isCustom: Bool
    var rounds: Int?
    var workSeconds: Int?
    var restSeconds: Int?
    var soundStyleRawValue: String?
    var tracksLaps: Bool?

    init(
        id: UUID = UUID(),
        name: String,
        seconds: Int,
        isCustom: Bool = false,
        rounds: Int? = nil,
        workSeconds: Int? = nil,
        restSeconds: Int? = nil,
        soundStyleRawValue: String? = nil,
        tracksLaps: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.seconds = seconds
        self.isCustom = isCustom
        self.rounds = rounds
        self.workSeconds = workSeconds
        self.restSeconds = restSeconds
        self.soundStyleRawValue = soundStyleRawValue
        self.tracksLaps = tracksLaps
    }

    var isCompound: Bool {
        guard let rounds, let workSeconds, let restSeconds else { return false }
        return rounds > 0 && workSeconds > 0 && restSeconds >= 0
    }

    var isCountUp: Bool {
        !isCustom && !isCompound && seconds == 0
    }

    var isLapTimer: Bool {
        tracksLaps == true
    }

    var initialSeconds: Int {
        if isCompound, let workSeconds {
            workSeconds
        } else {
            seconds
        }
    }

    var durationLabel: String {
        if isCountUp {
            return name == "Continuous" ? "Continuous" : "Count up"
        }
        if isCompound, let rounds {
            return "\(rounds) rounds"
        }
        return Self.durationText(seconds)
    }

    var compactDurationLabel: String {
        if isCountUp { return "∞" }
        if seconds < 60 { return "\(seconds)s" }
        let minutes = seconds / 60
        let remainder = seconds % 60
        if remainder == 0 {
            if minutes == 60 { return "1 hour" }
            return minutes == 1 ? "1 min" : "\(minutes) min"
        }
        return "\(minutes)m \(remainder)s"
    }

    var expandedDurationLabel: String {
        if isCountUp { return name == "Continuous" ? "Count up" : "Count up, no limit" }
        return Self.durationText(seconds)
    }

    var intervalLabel: String? {
        guard isCompound, let workSeconds, let restSeconds else { return nil }
        if restSeconds == 0 {
            return "Every \(Self.durationText(workSeconds))"
        }
        return "\(Self.durationText(workSeconds)) work • \(Self.durationText(restSeconds)) rest"
    }

    private static func durationText(_ seconds: Int) -> String {
        if seconds < 60 { return "\(seconds) sec" }
        let minutes = seconds / 60
        let remainder = seconds % 60
        return remainder == 0 ? "\(minutes) min" : "\(minutes)m \(remainder)s"
    }
}
