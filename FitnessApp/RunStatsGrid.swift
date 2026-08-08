import SwiftUI

struct RunStatsGrid: View {
    let distance: String
    let steps: String
    let pace: String
    let speed: String
    let elevation: String
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            MetricCard(icon: "location.fill", value: distance, label: "Distance", color: AppTheme.accent)
            MetricCard(icon: "shoeprints.fill", value: steps, label: "Steps", color: AppTheme.coral)
            MetricCard(icon: "speedometer", value: pace, label: "Average pace", color: .cyan)
            MetricCard(icon: "gauge.with.dots.needle.33percent", value: speed, label: "Current speed", color: .orange)
            MetricCard(icon: "mountain.2.fill", value: elevation, label: "Elevation gain", color: .green)
        }
    }
}
