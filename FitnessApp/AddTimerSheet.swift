import SwiftUI

struct AddTimerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppStore.self) private var store
    private let timer: TimerPreset?
    @State private var name: String
    @State private var isCompound: Bool
    @State private var minutes: Int
    @State private var seconds: Int
    @State private var rounds: Int
    @State private var workMinutes: Int
    @State private var workSeconds: Int
    @State private var restMinutes: Int
    @State private var restSeconds: Int

    init(timer: TimerPreset? = nil) {
        let compound = timer?.isCompound ?? false
        let workDuration = timer?.workSeconds ?? 40
        let restDuration = timer?.restSeconds ?? 20
        self.timer = timer
        _name = State(initialValue: timer?.name ?? "My Timer")
        _isCompound = State(initialValue: compound)
        _minutes = State(initialValue: compound ? 1 : (timer?.seconds ?? 60) / 60)
        _seconds = State(initialValue: compound ? 0 : (timer?.seconds ?? 60) % 60)
        _rounds = State(initialValue: timer?.rounds ?? 5)
        _workMinutes = State(initialValue: workDuration / 60)
        _workSeconds = State(initialValue: workDuration % 60)
        _restMinutes = State(initialValue: restDuration / 60)
        _restSeconds = State(initialValue: restDuration % 60)
    }

    private var totalSeconds: Int { minutes * 60 + seconds }
    private var totalWorkSeconds: Int { workMinutes * 60 + workSeconds }
    private var totalRestSeconds: Int { restMinutes * 60 + restSeconds }
    private var compoundTotalSeconds: Int { rounds * (totalWorkSeconds + totalRestSeconds) }
    private var configuredTotalSeconds: Int { isCompound ? compoundTotalSeconds : totalSeconds }
    private var isValid: Bool {
        let hasName = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return hasName && (isCompound ? totalWorkSeconds > 0 && totalRestSeconds > 0 : totalSeconds > 0)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Timer name", text: $name)
                    Picker("Timer type", selection: $isCompound) {
                        Text("Single").tag(false)
                        Text("Rounds").tag(true)
                    }
                    .pickerStyle(.segmented)
                }

                if isCompound {
                    Section("Rounds") {
                        Stepper("\(rounds) rounds", value: $rounds, in: 1...99)
                    }
                    TimerDurationSection(title: "Work period", minutes: $workMinutes, seconds: $workSeconds)
                    TimerDurationSection(title: "Rest period", minutes: $restMinutes, seconds: $restSeconds)
                } else {
                    TimerDurationSection(title: "Duration", minutes: $minutes, seconds: $seconds)
                }

                Section {
                    LabeledContent("Total time", value: Duration.seconds(configuredTotalSeconds).formatted(.time(pattern: .minuteSecond)))
                }
            }
            .navigationTitle(timer == nil ? "New Timer" : "Edit Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(timer == nil ? "Add" : "Save", action: saveTimer)
                        .disabled(!isValid)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func saveTimer() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let savedTimer = TimerPreset(
            id: timer?.id ?? UUID(),
            name: trimmedName,
            seconds: configuredTotalSeconds,
            isCustom: timer?.isCustom ?? true,
            rounds: isCompound ? rounds : nil,
            workSeconds: isCompound ? totalWorkSeconds : nil,
            restSeconds: isCompound ? totalRestSeconds : nil
        )
        if timer != nil {
            store.updateTimer(savedTimer)
        } else {
            store.addTimer(savedTimer)
        }
        dismiss()
    }
}
