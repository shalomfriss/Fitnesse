import SwiftUI

struct TimerResetButton: View {
    let reset: () -> Void

    var body: some View {
        Button(action: reset) {
            Label("Reset timer", systemImage: "arrow.counterclockwise")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 68)
                .background(AppTheme.coral)
                .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .accessibilityHint("Stops the countdown and restores the selected duration")
    }
}
