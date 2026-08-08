import SwiftUI

struct TimerDurationSection: View {
    let title: String
    @Binding var minutes: Int
    @Binding var seconds: Int

    var body: some View {
        Section(title) {
            Stepper("Minutes: \(minutes)", value: $minutes, in: 0...60)
            Stepper("Seconds: \(seconds)", value: $seconds, in: 0...59)
        }
    }
}
