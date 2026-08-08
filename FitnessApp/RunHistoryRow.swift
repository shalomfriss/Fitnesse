import SwiftUI

struct RunHistoryRow: View {
    let run: RunSession

    private var distanceText: String {
        "\((run.distanceMeters / 1_000).formatted(.number.precision(.fractionLength(2)))) km"
    }

    private var durationText: String {
        Duration.seconds(run.durationSeconds).formatted(.time(pattern: .hourMinuteSecond))
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "figure.run.circle.fill")
                .font(.title)
                .foregroundStyle(AppTheme.accent)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(run.date, format: .dateTime.month(.abbreviated).day().hour().minute())
                    .bold()
                Text("\(distanceText) • \(durationText) • \(run.steps.formatted()) steps")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
    }
}
