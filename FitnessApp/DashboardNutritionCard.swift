import SwiftUI

struct DashboardNutritionCard: View {
    let calories: Int
    let goal: Int
    let protein: Int
    let proteinGoal: Int
    let openNutrition: () -> Void

    var body: some View {
        Button(action: openNutrition) {
            GlassCard {
                HStack(spacing: 18) {
                    ProgressRing(
                        progress: Double(calories) / Double(max(goal, 1)),
                        color: AppTheme.teal,
                        centerText: "\(calories)"
                    )
                    .frame(width: 86, height: 86)

                    VStack(alignment: .leading, spacing: 7) {
                        Label("Today's fuel", systemImage: "leaf.fill")
                            .font(.headline)
                            .foregroundStyle(AppTheme.teal)
                        Text("\(max(goal - calories, 0)) calories remaining")
                            .font(.title3)
                            .bold()
                        Text("Protein \(protein) / \(proteinGoal) g")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens nutrition tracking")
    }
}
