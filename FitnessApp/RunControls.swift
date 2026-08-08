import SwiftUI

struct RunControls: View {
    let isTracking: Bool
    let isPaused: Bool
    let start: () -> Void
    let pause: () -> Void
    let resume: () -> Void
    let finish: () -> Void

    var body: some View {
        if isTracking {
            HStack(spacing: 12) {
                Button(isPaused ? "Resume" : "Pause", systemImage: isPaused ? "play.fill" : "pause.fill", action: isPaused ? resume : pause)
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.accent)
                    .foregroundStyle(.black)

                Button("Finish", systemImage: "flag.checkered", action: finish)
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.coral)
            }
        } else {
            Button("Start run", systemImage: "figure.run", action: start)
                .font(.title3)
                .bold()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, minHeight: 64)
                .background(AppTheme.accent)
                .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        }
    }
}
