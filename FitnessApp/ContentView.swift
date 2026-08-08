import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedTab = AppTab.dashboard

    var body: some View {
        ZStack {
            if hasCompletedWelcome {
                appTabs
                    .transition(.opacity)
            } else {
                LandingView(continueAction: completeWelcome)
                    .transition(reduceMotion ? .opacity : .move(edge: .bottom).combined(with: .opacity))
            }
        }
        .preferredColorScheme(.dark)
    }

    private var appTabs: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "chart.bar.fill", value: .dashboard) {
                DashboardView(selectedTab: $selectedTab)
            }

            Tab("Timers", systemImage: "timer", value: .timers) {
                TimersView()
            }

            Tab("Workouts", systemImage: "dumbbell.fill", value: .workouts) {
                WorkoutsView()
            }

            Tab("Run", systemImage: "figure.run", value: .run) {
                RunView()
            }

            Tab("Nutrition", systemImage: "fork.knife", value: .nutrition) {
                NutritionView()
            }

            Tab("Exercises", systemImage: "figure.strengthtraining.traditional", value: .exercises) {
                ExerciseLibraryView()
            }

            Tab("Tools", systemImage: "wrench.and.screwdriver.fill", value: .tools) {
                ToolsView()
            }

            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
                SettingsView()
            }
        }
        .tint(AppTheme.accent)
        .toolbarBackground(AppTheme.backgroundRaised, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }

    private func completeWelcome() {
        withAnimation(reduceMotion ? .easeOut(duration: 0.15) : .smooth(duration: 0.45)) {
            hasCompletedWelcome = true
        }
    }
}

#Preview {
    ContentView()
        .environment(AppStore(defaults: UserDefaults(suiteName: "preview") ?? .standard))
}
