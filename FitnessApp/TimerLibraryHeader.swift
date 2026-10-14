import SwiftUI

struct TimerLibraryHeader: View {
    let addTimer: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("TRAIN")
                .font(.caption.bold())
                .tracking(2.6)
                .foregroundStyle(AppTheme.secondaryInk)

            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Timers")
                        .font(AppTheme.displayFont(size: 36, relativeTo: .largeTitle))
                        .tracking(-0.8)
                        .foregroundStyle(AppTheme.ink)

                    Text("Simple. Focused. Get to work.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryInk)
                }

                Spacer(minLength: 4)

                Button(action: addTimer) {
                    Label("Custom Timer", systemImage: "plus")
                        .font(.subheadline.bold())
                        .labelStyle(.titleAndIcon)
                        .padding(.horizontal, 11)
                        .frame(minHeight: 48)
                        .foregroundStyle(AppTheme.accent)
                        .background(AppTheme.backgroundRaised)
                        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                                .stroke(AppTheme.accent.opacity(0.8), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
                .accessibilityHint("Creates a custom countdown or interval timer")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
    }
}
