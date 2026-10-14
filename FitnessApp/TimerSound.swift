import AVFoundation

enum TimerSoundStyle: String, CaseIterable, Identifiable {
    case classic
    case doubleBeep
    case bell
    case rising
    case tripleBeep
    case lowPulse
    case digitalSweep
    case descending
    case softChime
    case alertPulse

    var id: String { rawValue }

    var title: String {
        switch self {
        case .classic: "Classic Beep"
        case .doubleBeep: "Double Beep"
        case .bell: "Bell"
        case .rising: "Rising Chime"
        case .tripleBeep: "Triple Beep"
        case .lowPulse: "Low Pulse"
        case .digitalSweep: "Digital Sweep"
        case .descending: "Descending Chime"
        case .softChime: "Soft Chime"
        case .alertPulse: "Alert Pulse"
        }
    }

    var duration: TimeInterval {
        switch self {
        case .classic: 0.38
        case .doubleBeep: 0.5
        case .bell: 0.85
        case .rising: 0.45
        case .tripleBeep: 0.65
        case .lowPulse: 0.62
        case .digitalSweep: 0.72
        case .descending: 0.58
        case .softChime: 0.92
        case .alertPulse: 0.72
        }
    }

    var notificationFileName: String {
        switch self {
        case .classic: "timer-classic.wav"
        case .doubleBeep: "timer-double-beep.wav"
        case .bell: "timer-bell.wav"
        case .rising: "timer-rising.wav"
        case .tripleBeep: "timer-triple-beep.wav"
        case .lowPulse: "timer-low-pulse.wav"
        case .digitalSweep: "timer-digital-sweep.wav"
        case .descending: "timer-descending.wav"
        case .softChime: "timer-soft-chime.wav"
        case .alertPulse: "timer-alert-pulse.wav"
        }
    }

    func sample(at time: TimeInterval) -> Float {
        switch self {
        case .classic:
            tone(frequency: 880, time: time, start: 0, duration: 0.36)
        case .doubleBeep:
            tone(frequency: 880, time: time, start: 0, duration: 0.15)
                + tone(frequency: 880, time: time, start: 0.27, duration: 0.15)
        case .bell:
            bellSample(at: time, frequency: 660, volume: 0.48, decayRate: 3.2)
        case .rising:
            tone(frequency: 660, time: time, start: 0, duration: 0.18)
                + tone(frequency: 990, time: time, start: 0.22, duration: 0.2)
        case .tripleBeep:
            tone(frequency: 880, time: time, start: 0, duration: 0.1)
                + tone(frequency: 880, time: time, start: 0.2, duration: 0.1)
                + tone(frequency: 880, time: time, start: 0.4, duration: 0.1)
        case .lowPulse:
            tone(frequency: 440, time: time, start: 0, duration: 0.22)
                + tone(frequency: 440, time: time, start: 0.34, duration: 0.22)
        case .digitalSweep:
            sweepSample(at: time)
        case .descending:
            tone(frequency: 1_046.5, time: time, start: 0, duration: 0.14)
                + tone(frequency: 831, time: time, start: 0.18, duration: 0.14)
                + tone(frequency: 659.3, time: time, start: 0.36, duration: 0.14)
        case .softChime:
            bellSample(at: time, frequency: 880, volume: 0.3, decayRate: 4.4)
        case .alertPulse:
            tone(frequency: 740, time: time, start: 0, duration: 0.08)
                + tone(frequency: 740, time: time, start: 0.18, duration: 0.08)
                + tone(frequency: 740, time: time, start: 0.36, duration: 0.08)
                + tone(frequency: 1_046.5, time: time, start: 0.52, duration: 0.14)
        }
    }

    private func tone(
        frequency: Double,
        time: TimeInterval,
        start: TimeInterval,
        duration: TimeInterval
    ) -> Float {
        let localTime = time - start
        guard localTime >= 0, localTime < duration else { return 0 }

        let fadeIn = min(1, localTime / 0.012)
        let fadeOut = min(1, (duration - localTime) / 0.02)
        let amplitude = 0.42 * min(fadeIn, fadeOut)
        return Float(sin(2 * Double.pi * frequency * localTime) * amplitude)
    }

    private func sweepSample(at time: TimeInterval) -> Float {
        let sweepDuration = 0.58
        guard time >= 0, time < sweepDuration else { return 0 }
        let startingFrequency = 460.0
        let endingFrequency = 1_360.0
        let slope = (endingFrequency - startingFrequency) / sweepDuration
        let phase = 2 * Double.pi * (startingFrequency * time + 0.5 * slope * time * time)
        let attack = min(1, time / 0.015)
        let release = min(1, (sweepDuration - time) / 0.06)
        return Float(sin(phase) * 0.4 * attack * release)
    }

    private func bellSample(
        at time: TimeInterval,
        frequency: Double,
        volume: Double,
        decayRate: Double
    ) -> Float {
        guard time >= 0, time < 0.82 else { return 0 }
        let attack = min(1, time / 0.01)
        let release = min(1, (0.82 - time) / 0.04)
        let decay = exp(-decayRate * time)
        let harmonics = sin(2 * Double.pi * frequency * time) * 0.55
            + sin(2 * Double.pi * frequency * 2 * time) * 0.3
            + sin(2 * Double.pi * frequency * 3 * time) * 0.15
        return Float(harmonics * volume * attack * release * decay)
    }
}

@MainActor
enum TimerSound {
    private static var audioEngine: AVAudioEngine?
    private static var playerNode: AVAudioPlayerNode?
    private static var stopTask: Task<Void, Never>?

    static func play(_ style: TimerSoundStyle) {
        stopPlayback(deactivateAudioSession: false)

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers, .duckOthers]
            )
            try audioSession.setActive(true)
        } catch {
            return
        }

        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        let mixer = engine.mainMixerNode
        let format = mixer.outputFormat(forBus: 0)

        let duration = style.duration
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        guard format.sampleRate > 0,
              format.channelCount > 0,
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channels = buffer.floatChannelData else {
            deactivateAudioSession()
            return
        }

        buffer.frameLength = frameCount

        for frame in 0..<Int(frameCount) {
            let sample = style.sample(at: Double(frame) / format.sampleRate)

            for channel in 0..<Int(format.channelCount) {
                channels[channel][frame] = sample
            }
        }

        engine.attach(player)
        engine.connect(player, to: mixer, format: format)
        engine.prepare()

        do {
            try engine.start()
        } catch {
            engine.detach(player)
            deactivateAudioSession()
            return
        }

        audioEngine = engine
        playerNode = player
        player.scheduleBuffer(buffer)
        player.play()

        stopTask = Task {
            do {
                try await Task.sleep(for: .seconds(duration + 0.1))
            } catch {
                return
            }
            stopPlayback()
        }
    }

    private static func stopPlayback(deactivateAudioSession: Bool = true) {
        stopTask?.cancel()
        stopTask = nil
        playerNode?.stop()
        audioEngine?.stop()

        if let playerNode, let audioEngine {
            audioEngine.detach(playerNode)
        }

        playerNode = nil
        audioEngine = nil

        if deactivateAudioSession {
            Self.deactivateAudioSession()
        }
    }

    private static func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }
}
