import SwiftUI

struct WorkoutCard: View {
    let workout: WorkoutPlan
    let start: () -> Void
    let edit: () -> Void
    let delete: () -> Void

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(workout.name)
                            .font(.title3)
                            .bold()
                        Text("\(workout.exercises.count) exercises • \(workout.totalSets) total sets")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Menu("Workout options", systemImage: "ellipsis.circle") {
                        Button("Edit workout", systemImage: "pencil", action: edit)
                        Button("Delete workout", systemImage: "trash", role: .destructive, action: delete)
                    }
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .foregroundStyle(AppTheme.accent)
                }

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(workout.exercises.prefix(4)) { item in
                            Text(item.exercise.name)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(AppTheme.surfaceStrong)
                                .clipShape(.capsule)
                        }
                    }
                }
                .scrollIndicators(.hidden)

                Button("Start workout", systemImage: "play.fill", action: start)
                    .bold()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(AppTheme.accent)
                    .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
            }
        }
    }
}
