import SwiftUI

struct ExerciseIllustration: View {
    let exercise: Exercise
    let compact: Bool
    @ScaledMetric(relativeTo: .title) private var compactSymbolSize = 38.0
    @ScaledMetric(relativeTo: .largeTitle) private var heroSymbolSize = 92.0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .fill(illustrationColor.opacity(0.12))

            Image(systemName: exercise.illustrationSymbol)
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: compact ? compactSymbolSize : heroSymbolSize))
                .foregroundStyle(illustrationColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Image(systemName: exercise.equipmentSymbol)
                .font(compact ? .caption : .title3)
                .foregroundStyle(AppTheme.onAccent)
                .frame(width: compact ? 26 : 42, height: compact ? 26 : 42)
                .background(illustrationColor)
                .clipShape(.circle)
                .padding(compact ? 6 : 12)
        }
        .clipShape(.rect(cornerRadius: compact ? AppTheme.smallRadius : AppTheme.cardRadius))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Illustration of \(exercise.name) using \(exercise.equipment)")
    }

    private var illustrationColor: Color {
        switch exercise.muscleGroup {
        case "Cardio": AppTheme.blue
        case "Mobility": AppTheme.teal
        case "Core": AppTheme.blue
        case "Legs", "Glutes", "Hamstrings", "Calves": AppTheme.accent
        case "Chest", "Back": AppTheme.teal
        case "Shoulders", "Arms": AppTheme.blue
        default: AppTheme.accent
        }
    }
}
