import SwiftUI

struct LandingFeatureRow: View {
    let title: String
    let detail: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 48, height: 48)
                .background(color.opacity(0.12))
                .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .bold()
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
        .background(AppTheme.backgroundRaised)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                .stroke(AppTheme.stroke, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    LandingFeatureRow(
        title: "Train with purpose",
        detail: "Build routines and stay on top of every set.",
        systemImage: "dumbbell.fill",
        color: AppTheme.accent
    )
    .padding()
    .background(AppTheme.background)
    .preferredColorScheme(.dark)
}
