import SwiftUI

struct TimerDurationSection: View {
    let title: String
    @Binding var minutes: Int
    @Binding var seconds: Int

    var body: some View {
        Section(title) {
            Stepper(value: $minutes, in: 0...60) {
                HStack {
                    Text("Minutes")
                    Spacer()
                    TextField("Minutes", value: $minutes, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                        .frame(minWidth: 44, idealWidth: 56, maxWidth: 72)
                        .accessibilityLabel("Minutes")
                }
            }
            .accessibilityLabel("Minutes, \(minutes)")
            .onChange(of: minutes) { _, newValue in
                minutes = min(max(newValue, 0), 60)
            }

            Stepper(value: $seconds, in: 0...59) {
                HStack {
                    Text("Seconds")
                    Spacer()
                    TextField("Seconds", value: $seconds, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                        .frame(minWidth: 44, idealWidth: 56, maxWidth: 72)
                        .accessibilityLabel("Seconds")
                }
            }
            .accessibilityLabel("Seconds, \(seconds)")
            .onChange(of: seconds) { _, newValue in
                seconds = min(max(newValue, 0), 59)
            }
        }
    }
}
