import Foundation
import UserNotifications
import UIKit

@MainActor
enum TimerNotificationManager {
    private static let completionIdentifierPrefix = "active-timer-completion"
    private static let activeIdentifierKey = "activeTimerNotificationIdentifier"

    private static var activeIdentifier: String? {
        get { UserDefaults.standard.string(forKey: activeIdentifierKey) }
        set { UserDefaults.standard.set(newValue, forKey: activeIdentifierKey) }
    }

    static func scheduleCompletion(
        for timer: TimerPreset,
        after seconds: Int,
        soundStyle: TimerSoundStyle,
        soundEnabled: Bool
    ) async -> Bool {
        let identifier = "\(completionIdentifierPrefix)-\(UUID().uuidString)"
        if let activeIdentifier {
            removePendingRequest(identifier: activeIdentifier)
        }
        activeIdentifier = identifier

        guard await hasAuthorization(), activeIdentifier == identifier else {
            clearActiveIdentifier(ifMatching: identifier)
            return false
        }

        let content = UNMutableNotificationContent()
        content.title = "\(timer.name) complete"
        content.body = "Your timer has finished."
        content.sound = soundEnabled
            ? UNNotificationSound(named: UNNotificationSoundName(rawValue: soundStyle.notificationFileName))
            : nil
        content.interruptionLevel = .timeSensitive

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(max(seconds, 1)),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
            guard activeIdentifier == identifier else {
                removePendingRequest(identifier: identifier)
                return false
            }
            return true
        } catch {
            clearActiveIdentifier(ifMatching: identifier)
            return false
        }
    }

    static func cancelCompletion() {
        if let activeIdentifier {
            removePendingRequest(identifier: activeIdentifier)
        }
        activeIdentifier = nil
    }

    static func canPlayNotificationSound() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.soundSetting == .enabled
    }

    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private static func hasAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .sound])) == true
        case .denied:
            return false
        @unknown default:
            return false
        }
    }

    private static func removePendingRequest(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [identifier]
        )
    }

    private static func clearActiveIdentifier(ifMatching identifier: String) {
        if activeIdentifier == identifier {
            activeIdentifier = nil
        }
    }
}
