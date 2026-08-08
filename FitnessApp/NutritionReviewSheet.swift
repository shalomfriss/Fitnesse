import SwiftUI

struct NutritionReviewSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppStore.self) private var store
    @State var draft: NutritionDraft

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Label("Smart estimate ready", systemImage: "sparkles")
                        .foregroundStyle(AppTheme.accent)
                    Text("Review and adjust the estimate before adding it to today.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Section("Meal") {
                    TextField("Meal description", text: $draft.name, axis: .vertical).lineLimit(2...4)
                }
                Section("Estimated nutrition") {
                    LabeledContent("Calories") { NumberField(label: "Calories", value: $draft.calories) }
                    LabeledContent("Protein (g)") { NumberField(label: "Protein", value: $draft.protein) }
                    LabeledContent("Carbs (g)") { NumberField(label: "Carbs", value: $draft.carbs) }
                    LabeledContent("Fat (g)") { NumberField(label: "Fat", value: $draft.fat) }
                }
            }
            .navigationTitle("Review Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel", action: dismiss.callAsFunction) }
                ToolbarItem(placement: .confirmationAction) { Button("Add meal", action: addMeal) }
            }
        }
    }

    private func addMeal() {
        store.addNutrition(NutritionEntry(name: draft.name, calories: max(0, draft.calories), protein: max(0, draft.protein), carbs: max(0, draft.carbs), fat: max(0, draft.fat)))
        dismiss()
    }
}
