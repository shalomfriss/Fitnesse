import SwiftUI

struct DashboardView: View {
    @Environment(AppStore.self) private var store
    @Binding var selectedTab: AppTab

    private var recentSessions: [WorkoutSession] {
        Array(store.sessions.sorted { $0.date > $1.date }.prefix(3))
    }

    private var weeklyMinutes: Int {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .distantPast
        return store.sessions.filter { $0.date >= cutoff }.reduce(0) { $0 + $1.durationMinutes }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 22) {
                        DashboardHeader(name: store.displayName)

                        HStack(spacing: 12) {
                            MetricCard(icon: "flame.fill", value: "\(store.sessions.count)", label: "Workouts", color: AppTheme.coral)
                            MetricCard(icon: "clock.fill", value: "\(weeklyMinutes)", label: "Minutes this week", color: AppTheme.blue)
                        }

                        DashboardNutritionCard(
                            calories: store.todayCalories,
                            goal: store.dailyCalorieGoal,
                            protein: store.todayProtein,
                            proteinGoal: store.dailyProteinGoal,
                            openNutrition: openNutrition
                        )

                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Recent activity")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                                Button("See workouts", action: openWorkouts)
                                    .foregroundStyle(AppTheme.accent)
                            }

                            if recentSessions.isEmpty {
                                ContentUnavailableView("No workouts yet", systemImage: "dumbbell", description: Text("Complete a workout to see it here."))
                            } else {
                                GlassCard {
                                    VStack(spacing: 18) {
                                        ForEach(recentSessions) { session in
                                            SessionRow(session: session)
                                            if session.id != recentSessions.last?.id {
                                                Divider()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func openWorkouts() {
        selectedTab = .workouts
    }

    private func openNutrition() {
        selectedTab = .nutrition
    }
}
