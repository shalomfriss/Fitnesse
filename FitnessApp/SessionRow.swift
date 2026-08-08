import SwiftUI

struct SessionRow: View {
    let session: WorkoutSession

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark")
                .bold()
                .foregroundStyle(.black)
                .frame(width: 42, height: 42)
                .background(AppTheme.accent)
                .clipShape(.circle)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(session.workoutName)
                    .font(.headline)
                Text(session.date, format: .relative(presentation: .named))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(session.durationMinutes) min")
                    .bold()
                Text("\(session.totalSets) sets")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
