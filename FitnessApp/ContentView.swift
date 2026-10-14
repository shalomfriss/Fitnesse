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
        .foregroundStyle(AppTheme.ink)
    }

    private var appTabs: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .dashboard) {
                DashboardView(selectedTab: $selectedTab)
            }

            Tab("Timers", systemImage: "timer", value: .timers) {
                TimersView()
            }

            Tab("Training", systemImage: "dumbbell.fill", value: .workouts) {
                WorkoutsView()
            }

            Tab("Nutrition", systemImage: "fork.knife", value: .nutrition) {
                NutritionView()
            }

            Tab("More", systemImage: "ellipsis", value: .tools) {
                MoreView()
            }
        }
        .tint(AppTheme.accent)
        .toolbarBackground(AppTheme.backgroundRaised.opacity(0.96), for: .tabBar)
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
