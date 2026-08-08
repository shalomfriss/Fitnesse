import SwiftUI

struct DashboardHeader: View {
    let name: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(AppTheme.accent)
                    .textCase(.uppercase)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(AppTheme.accent.opacity(0.10))
                    .clipShape(.capsule)
                Spacer()
                Image(systemName: "bolt.heart.fill")
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 50, height: 50)
                    .background(AppTheme.surfaceStrong)
                    .clipShape(.circle)
                    .accessibilityHidden(true)
            }

            Text("Ready, \(name)?")
                .font(.largeTitle)
                .bold()
                .tracking(-0.8)
            Text("Your next strong day starts here.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.top)
        .accessibilityElement(children: .combine)
    }
}
