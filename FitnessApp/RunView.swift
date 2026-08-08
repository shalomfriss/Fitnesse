import SwiftUI

struct RunView: View {
    @Environment(AppStore.self) private var store
    @State private var tracker = RunTracker()
    @State private var savedFeedback = false

    private var durationText: String {
        Duration.seconds(tracker.elapsedSeconds).formatted(.time(pattern: .hourMinuteSecond))
    }

    private var distanceText: String {
        "\((tracker.distanceMeters / 1_000).formatted(.number.precision(.fractionLength(2)))) km"
    }

    private var paceText: String {
        guard tracker.distanceMeters >= 10 else { return "--:-- /km" }
        let secondsPerKilometer = Int(Double(tracker.elapsedSeconds) / (tracker.distanceMeters / 1_000))
        return "\(Duration.seconds(secondsPerKilometer).formatted(.time(pattern: .minuteSecond))) /km"
    }

    private var speedText: String {
        "\((tracker.currentSpeedMetersPerSecond * 3.6).formatted(.number.precision(.fractionLength(1)))) km/h"
    }

    private var elevationText: String {
        "\(tracker.elevationGainMeters.formatted(.number.precision(.fractionLength(0)))) m"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        FeatureHeader(
                            eyebrow: "RUN TRACKER",
                            title: tracker.isTracking ? (tracker.isPaused ? "Run paused" : "Run in progress") : "Ready to run",
                            subtitle: tracker.statusMessage,
                            systemImage: "figure.run"
                        )

                        RunRouteMap(coordinates: tracker.routeCoordinates)

                        GlassCard {
                            VStack(spacing: 6) {
                                Text(durationText)
                                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                    .contentTransition(.numericText())
                                Text("DURATION")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        RunStatsGrid(
                            distance: distanceText,
                            steps: tracker.steps.formatted(),
                            pace: paceText,
                            speed: speedText,
                            elevation: elevationText
                        )

                        RunControls(
                            isTracking: tracker.isTracking,
                            isPaused: tracker.isPaused,
                            start: tracker.start,
                            pause: tracker.pause,
                            resume: tracker.resume,
                            finish: finishRun
                        )

                        if !store.runSessions.isEmpty {
                            Text("Recent runs")
                                .font(.title3)
                                .bold()
                            GlassCard {
                                VStack(spacing: 18) {
                                    ForEach(store.runSessions.prefix(6)) { run in
                                        RunHistoryRow(run: run)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sensoryFeedback(.success, trigger: savedFeedback)
    }

    private func finishRun() {
        guard let run = tracker.finish() else { return }
        store.addRun(run)
        savedFeedback.toggle()
    }
}
