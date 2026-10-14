import SwiftUI

struct MoreView: View {
    @State private var destination: MoreDestination?

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        FeatureHeader(
                            eyebrow: "TOTAL TRAINING TOOLS",
                            title: "More",
                            subtitle: "Your library, calculators, and app settings.",
                            systemImage: "ellipsis"
                        )

                        GlassCard {
                            VStack(spacing: 0) {
                                destinationRow(
                                    title: "Exercise library",
                                    detail: "Browse movements and training cues",
                                    symbol: "figure.strengthtraining.traditional",
                                    selection: .exercises
                                )
                                rowDivider
                                destinationRow(
                                    title: "Tools & calculators",
                                    detail: "Plan targets and training numbers",
                                    symbol: "wrench.and.screwdriver.fill",
                                    selection: .tools
                                )
                                rowDivider
                                destinationRow(
                                    title: "Settings",
                                    detail: "Profile, goals, and app preferences",
                                    symbol: "gearshape.fill",
                                    selection: .settings
                                )
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(item: $destination) { selection in
            Group {
                switch selection {
                case .exercises:
                    ExerciseLibraryView()
                case .tools:
                    ToolsView()
                case .settings:
                    SettingsView()
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(AppTheme.stroke)
            .frame(height: 1)
            .padding(.leading, 56)
    }

    private func destinationRow(
        title: String,
        detail: String,
        symbol: String,
        selection: MoreDestination
    ) -> some View {
        Button {
            destination = selection
        } label: {
            HStack(spacing: 13) {
                Image(systemName: symbol)
                    .font(.headline)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 42, height: 42)
                    .background(AppTheme.accent.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryInk)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(AppTheme.secondaryInk)
            }
            .frame(maxWidth: .infinity, minHeight: 68)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
