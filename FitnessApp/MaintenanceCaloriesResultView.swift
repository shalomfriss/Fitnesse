import SwiftUI

struct MaintenanceCaloriesResultView: View {
    let maintenanceCalories: Int
    let restingCalories: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Estimated maintenance")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(maintenanceCalories, format: .number)
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(AppTheme.accent)
                .contentTransition(.numericText())

            Text("calories per day")
                .font(.headline)

            Divider()
                .padding(.vertical, 6)

            LabeledContent("Resting calories") {
                Text("\(restingCalories) cal/day")
                    .bold()
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}
