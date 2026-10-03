import SwiftUI

struct FeatureHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(eyebrow.capitalized, systemImage: systemImage)
                .font(.custom("Avenir Next", size: 15, relativeTo: .subheadline))
                .bold()
                .tracking(0.2)
                .foregroundStyle(AppTheme.accent)

            Text(title)
                .font(AppTheme.displayFont(size: 38))
                .tracking(-0.8)

            Text(subtitle)
                .font(.custom("Avenir Next", size: 17, relativeTo: .body))
                .foregroundStyle(.secondary)
                .lineSpacing(2)
        }
        .accessibilityElement(children: .combine)
    }
}
