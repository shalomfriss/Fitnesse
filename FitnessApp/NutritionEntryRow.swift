import SwiftUI

struct NutritionEntryRow: View {
    let entry: NutritionEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.name).font(.headline)
                    Text(entry.date, format: .dateTime.hour().minute()).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(entry.calories) cal").bold().foregroundStyle(AppTheme.accent)
            }
            HStack(spacing: 0) {
                MacroPill(value: entry.protein, unit: "g", label: "Protein", color: AppTheme.teal)
                MacroPill(value: entry.carbs, unit: "g", label: "Carbs", color: AppTheme.blue)
                MacroPill(value: entry.fat, unit: "g", label: "Fat", color: AppTheme.coral)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
