import SwiftUI

struct CountdownShortcutCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 5) {
                    Text("Countdown")
                        .font(.subheadline.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                    Spacer(minLength: 0)
                    Image(systemName: "timer")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.accent)
                }
                Text("Simple countdown")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryInk)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 63, alignment: .leading)
            .padding(11)
            .background(AppTheme.backgroundRaised)
            .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                    .stroke(AppTheme.stroke, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Create a countdown timer")
        .accessibilityHint("Opens the custom timer form")
    }
}
