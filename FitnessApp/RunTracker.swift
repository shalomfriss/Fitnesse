import CoreLocation
import CoreMotion
import Foundation
import Observation

@MainActor
@Observable
final class RunTracker: NSObject, CLLocationManagerDelegate {
    private(set) var isTracking = false
    private(set) var isPaused = false
    private(set) var elapsedSeconds = 0
    private(set) var distanceMeters = 0.0
    private(set) var steps = 0
    private(set) var currentSpeedMetersPerSecond = 0.0
    private(set) var elevationGainMeters = 0.0
    private(set) var locations: [CLLocation] = []
    private(set) var statusMessage = "GPS and step tracking begin when you start a run."
    private(set) var locationAccessDenied = false

    private let locationManager = CLLocationManager()
    private let pedometer = CMPedometer()
    private var timerTask: Task<Void, Never>?
    private var segmentStartDate: Date?
    private var accumulatedDuration = 0.0
    private var stepBaseline = 0
    private var lastLocation: CLLocation?
    private var lastAltitude: Double?
    private var runStartDate: Date?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    var routeCoordinates: [CLLocationCoordinate2D] {
        locations.map(\.coordinate)
    }

    func start() {
        resetMeasurements()
        runStartDate = .now
        isTracking = true
        isPaused = false
        locationAccessDenied = false
        beginSegment()

        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            updateLocationTracking()
        }
    }

    func pause() {
        guard isTracking, !isPaused else { return }
        finalizeDurationSegment()
        stopSensors()
        isPaused = true
        statusMessage = "Run paused. Tap Resume when you are ready."
    }

    func resume() {
        guard isTracking, isPaused else { return }
        isPaused = false
        lastLocation = nil
        lastAltitude = nil
        beginSegment()
        updateLocationTracking()
    }

    func finish() -> RunSession? {
        guard isTracking else { return nil }
        if !isPaused {
            finalizeDurationSegment()
        }
        stopSensors()
        isTracking = false
        isPaused = false
        refreshDuration()
        statusMessage = "Run saved."

        guard elapsedSeconds > 0 else { return nil }
        let averageSpeed = distanceMeters / Double(elapsedSeconds)
        return RunSession(
            date: runStartDate ?? .now,
            durationSeconds: elapsedSeconds,
            distanceMeters: distanceMeters,
            steps: steps,
            elevationGainMeters: elevationGainMeters,
            averageSpeedMetersPerSecond: averageSpeed
        )
    }

    private func resetMeasurements() {
        timerTask?.cancel()
        elapsedSeconds = 0
        distanceMeters = 0
        steps = 0
        currentSpeedMetersPerSecond = 0
        elevationGainMeters = 0
        locations = []
        accumulatedDuration = 0
        stepBaseline = 0
        lastLocation = nil
        lastAltitude = nil
    }

    private func beginSegment() {
        segmentStartDate = .now
        statusMessage = locationAccessDenied ? "Location access is off; duration and available steps are still tracking." : "Tracking run with GPS and motion."
        startClock()
        startPedometer()
    }

    private func finalizeDurationSegment() {
        if let segmentStartDate {
            accumulatedDuration += Date.now.timeIntervalSince(segmentStartDate)
        }
        segmentStartDate = nil
        refreshDuration()
    }

    private func startClock() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                self.refreshDuration()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private func refreshDuration() {
        let currentSegment = segmentStartDate.map { Date.now.timeIntervalSince($0) } ?? 0
        elapsedSeconds = max(0, Int(accumulatedDuration + currentSegment))
    }

    private func startPedometer() {
        guard CMPedometer.isStepCountingAvailable() else {
            statusMessage = "Step counting is unavailable; GPS and duration are still tracking."
            return
        }
        let baseline = stepBaseline
        pedometer.startUpdates(from: .now) { [weak self] data, error in
            let segmentSteps = data?.numberOfSteps.intValue
            let failed = error != nil
            Task { @MainActor [weak self] in
                guard let self else { return }
                if let segmentSteps {
                    self.steps = baseline + segmentSteps
                } else if failed {
                    self.statusMessage = "Step data is unavailable; GPS and duration are still tracking."
                }
            }
        }
    }

    private func stopSensors() {
        timerTask?.cancel()
        timerTask = nil
        locationManager.stopUpdatingLocation()
        pedometer.stopUpdates()
        stepBaseline = steps
        currentSpeedMetersPerSecond = 0
    }

    private func updateLocationTracking() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationAccessDenied = false
            if isTracking && !isPaused {
                locationManager.startUpdatingLocation()
            }
        case .denied, .restricted:
            locationAccessDenied = true
            statusMessage = "Location access is off; duration and available steps are still tracking."
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateLocationTracking()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        guard isTracking, !isPaused else { return }
        for location in newLocations where location.horizontalAccuracy >= 0 && location.horizontalAccuracy <= 50 {
            if let lastLocation {
                let addedDistance = location.distance(from: lastLocation)
                if addedDistance >= 0 && addedDistance < 100 {
                    distanceMeters += addedDistance
                }
            }

            if location.verticalAccuracy >= 0 {
                if let lastAltitude {
                    elevationGainMeters += max(0, location.altitude - lastAltitude)
                }
                lastAltitude = location.altitude
            }

            currentSpeedMetersPerSecond = max(0, location.speed)
            lastLocation = location
            locations.append(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        guard isTracking else { return }
        statusMessage = "GPS signal is temporarily unavailable; duration and steps are still tracking."
    }
}
