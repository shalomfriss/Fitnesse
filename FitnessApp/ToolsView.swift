import SwiftUI

struct ToolsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Calculators") {
                    NavigationLink(value: ToolDestination.maintenanceCalories) {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Maintenance Calories")
                                    .font(.headline)

                                Text("Estimate the calories needed to maintain your weight")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(AppTheme.accent)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(ScreenBackground())
            .navigationTitle("Tools")
            .navigationDestination(for: ToolDestination.self) { destination in
                switch destination {
                case .maintenanceCalories:
                    MaintenanceCaloriesCalculatorView()
                }
            }
        }
    }
}
