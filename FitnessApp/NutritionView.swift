import SwiftUI

struct NutritionView: View {
    @Environment(AppStore.self) private var store
    @State private var mealDescription = ""
    @State private var reviewDraft: NutritionDraft?

    private var caloriesProgress: Double {
        Double(store.todayCalories) / Double(max(store.dailyCalorieGoal, 1))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        FeatureHeader(
                            eyebrow: "AI NUTRITION",
                            title: "Track food naturally",
                            subtitle: "Describe what you ate. Smart Log estimates the macros for you.",
                            systemImage: "sparkles"
                        )

                        GlassCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 18) {
                                    ProgressRing(progress: caloriesProgress, color: AppTheme.teal, centerText: "\(store.todayCalories)")
                                        .frame(width: 96, height: 96)
                                    VStack(alignment: .leading, spacing: 7) {
                                        Text("Today's nutrition").font(.headline)
                                        Text("\(max(store.dailyCalorieGoal - store.todayCalories, 0)) calories left").font(.title3).bold()
                                        Text("\(store.todayProtein) / \(store.dailyProteinGoal) g protein").font(.subheadline).foregroundStyle(.secondary)
                                    }
                                }
                                ProgressView(value: Double(store.todayProtein), total: Double(max(store.dailyProteinGoal, 1)))
                                    .tint(AppTheme.accent)
                            }
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Label("Smart Log", systemImage: "sparkles").font(.title3).bold().foregroundStyle(AppTheme.accent)
                                TextField("e.g. grilled chicken, rice, avocado and salad", text: $mealDescription, axis: .vertical)
                                    .lineLimit(3...6)
                                    .padding()
                                    .background(AppTheme.surfaceStrong)
                                    .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                                Button("Estimate with AI", systemImage: "wand.and.stars", action: analyzeMeal)
                                    .bold()
                                    .foregroundStyle(AppTheme.onAccent)
                                    .frame(maxWidth: .infinity, minHeight: 54)
                                    .background(AppTheme.accent)
                                    .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                                    .disabled(mealDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                Text("Estimates are for tracking convenience and may not match exact portions or ingredients.")
                                    .font(.footnote)
                                    .foregroundStyle(.tertiary)
                            }
                        }

                        Text("Today's meals").font(.title3).bold()
                        if store.todayNutrition.isEmpty {
                            ContentUnavailableView("No meals logged", systemImage: "fork.knife", description: Text("Describe a meal above to add your first entry."))
                        } else {
                            ForEach(store.todayNutrition) { entry in
                                GlassCard { NutritionEntryRow(entry: entry) }
                                    .contextMenu {
                                        Button("Delete meal", systemImage: "trash", role: .destructive) { delete(entry) }
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
        .sheet(item: $reviewDraft) { NutritionReviewSheet(draft: $0) }
    }

    private func analyzeMeal() {
        reviewDraft = NutritionEstimator.estimate(mealDescription)
        mealDescription = ""
    }

    private func delete(_ entry: NutritionEntry) {
        store.nutritionEntries.removeAll { $0.id == entry.id }
    }
}
