import AVFoundation

@MainActor
enum TimerSound {
    private static var audioEngine: AVAudioEngine?
    private static var playerNode: AVAudioPlayerNode?
    private static var stopTask: Task<Void, Never>?

    static func playBeep() {
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

        let duration = 0.35
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        guard format.sampleRate > 0,
              format.channelCount > 0,
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channels = buffer.floatChannelData else {
            deactivateAudioSession()
            return
        }

        buffer.frameLength = frameCount

        let frequency = 880.0
        let angularStep = 2.0 * Double.pi * frequency / format.sampleRate
        let fadeFrameCount = max(1, Int(format.sampleRate * 0.02))

        for frame in 0..<Int(frameCount) {
            let fadeIn = min(1.0, Double(frame) / Double(fadeFrameCount))
            let fadeOut = min(1.0, Double(Int(frameCount) - frame) / Double(fadeFrameCount))
            let sample = Float(sin(angularStep * Double(frame)) * 0.45 * min(fadeIn, fadeOut))

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
