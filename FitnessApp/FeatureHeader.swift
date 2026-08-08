import SwiftUI

struct FeatureHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(eyebrow, systemImage: systemImage)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(AppTheme.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(AppTheme.accent.opacity(0.10))
                    .clipShape(.capsule)

                Spacer()

                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 48, height: 48)
                    .background(AppTheme.surfaceStrong)
                    .clipShape(.circle)
                    .accessibilityHidden(true)
            }

            Text(title)
                .font(.largeTitle)
                .bold()
                .tracking(-0.8)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}
