import SwiftUI

struct SettingsView: View {
    @Environment(AppStore.self) private var store
    @State private var showingResetConfirmation = false

    var body: some View {
        @Bindable var store = store

        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Display name", text: $store.displayName)
                    LabeledContent("Training level", value: "Intermediate")
                }
                Section("Daily goals") {
                    Stepper(value: $store.dailyCalorieGoal, in: 1_000...5_000, step: 50) {
                        LabeledContent("Calories", value: "\(store.dailyCalorieGoal) cal")
                    }
                    Stepper(value: $store.dailyProteinGoal, in: 40...300, step: 5) {
                        LabeledContent("Protein", value: "\(store.dailyProteinGoal) g")
                    }
                }
                Section("App") {
                    LabeledContent("Theme", value: "Midnight")
                    LabeledContent("Units", value: "US")
                    LabeledContent("Version", value: "1.0")
                }
                Section {
                    Button("Restore sample data", systemImage: "arrow.counterclockwise", role: .destructive, action: confirmReset)
                } footer: {
                    Text("Pulse stores your workouts, timers, meals, and preferences on this device.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(ScreenBackground())
            .navigationTitle("Settings")
            .confirmationDialog("Restore sample data?", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
                Button("Restore", role: .destructive, action: resetData)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This replaces your current workouts, history, custom timers, and meal log.")
            }
        }
    }

    private func confirmReset() { showingResetConfirmation = true }
    private func resetData() { store.resetSampleData() }
}
