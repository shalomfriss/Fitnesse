import SwiftUI

struct TimersView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedTimerID: UUID?
    @State private var remainingSeconds = 30
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var endDate: Date?
    @State private var showingAddTimer = false
    @State private var editingTimer: TimerPreset?
    @State private var completionFeedback = false
    @State private var phaseFeedback = false
    @State private var currentRound = 1
    @State private var isRestPeriod = false
    private let timerColumns = [GridItem(.flexible()), GridItem(.flexible())]

    private var selectedTimer: TimerPreset? {
        store.timerPresets.first { $0.id == selectedTimerID } ?? store.timerPresets.first
    }

    private var phaseText: String? {
        guard let selectedTimer, selectedTimer.isCompound, let rounds = selectedTimer.rounds else {
            return isPaused ? "PAUSED" : nil
        }
        let phase = "\(isRestPeriod ? "REST" : "WORK") • ROUND \(currentRound) OF \(rounds)"
        return isPaused ? "PAUSED • \(phase)" : phase
    }

    private var activeRoundNumber: Int? {
        guard isRunning, selectedTimer?.isCompound == true else { return nil }
        return currentRound
    }

    private var isActiveRestPeriod: Bool {
        activeRoundNumber != nil && isRestPeriod
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                VStack(spacing: 0) {
                    TimerDisplayView(
                        remainingSeconds: remainingSeconds,
                        isRunning: isRunning,
                        phaseText: phaseText,
                        roundNumber: activeRoundNumber,
                        isRestPeriod: isActiveRestPeriod
                    )

                    ScrollView {
                        LazyVGrid(columns: timerColumns, spacing: 12) {
                            ForEach(store.timerPresets) { timer in
                                TimerCard(
                                    timer: timer,
                                    isActive: (isRunning || isPaused) && timer.id == selectedTimer?.id,
                                    isRunning: isRunning && timer.id == selectedTimer?.id,
                                    timerAction: { handleTimerTap(timer) },
                                    edit: { editTimer(timer) },
                                    delete: { deleteTimer(timer) }
                                )
                            }

                            Button("Add custom timer", systemImage: "plus", action: showAddTimer)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 138, maxHeight: .infinity)
                                .foregroundStyle(AppTheme.accent)
                                .background(AppTheme.backgroundRaised)
                                .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
                                .overlay {
                                    RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                                        .stroke(AppTheme.stroke, lineWidth: 1)
                                }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .scrollIndicators(.hidden)

                    TimerResetButton(reset: resetTimer)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showingAddTimer) {
            AddTimerSheet()
        }
        .sheet(item: $editingTimer) { timer in
            AddTimerSheet(timer: timer)
        }
        .task(id: isRunning) {
            guard isRunning else { return }
            await runTimer()
        }
        .sensoryFeedback(.success, trigger: completionFeedback)
        .sensoryFeedback(.impact(weight: .heavy), trigger: phaseFeedback)
        .onAppear(perform: setInitialTimer)
        .onChange(of: store.timerPresets, syncSelectedTimer)
    }

    private func setInitialTimer() {
        guard selectedTimerID == nil, let first = store.timerPresets.first else { return }
        selectedTimerID = first.id
        remainingSeconds = first.initialSeconds
    }

    private func showAddTimer() {
        showingAddTimer = true
    }

    private func start(_ timer: TimerPreset) {
        selectedTimerID = timer.id
        currentRound = 1
        isRestPeriod = false
        beginPeriod(seconds: timer.initialSeconds)
        isPaused = false
        isRunning = true
    }

    private func handleTimerTap(_ timer: TimerPreset) {
        if timer.id == selectedTimerID {
            if isRunning {
                pauseTimer()
                return
            }
            if isPaused {
                resumeTimer()
                return
            }
        }
        start(timer)
    }

    private func pauseTimer() {
        guard isRunning else { return }
        if let endDate {
            remainingSeconds = max(0, Int(ceil(endDate.timeIntervalSinceNow)))
        }
        endDate = nil
        isRunning = false
        isPaused = remainingSeconds > 0
    }

    private func resumeTimer() {
        guard isPaused, remainingSeconds > 0 else { return }
        endDate = .now.addingTimeInterval(Double(remainingSeconds))
        isPaused = false
        isRunning = true
    }

    private func editTimer(_ timer: TimerPreset) {
        editingTimer = timer
    }

    private func syncSelectedTimer() {
        guard !isRunning, !isPaused, let selectedTimer else { return }
        currentRound = 1
        isRestPeriod = false
        remainingSeconds = selectedTimer.initialSeconds
    }

    private func deleteTimer(_ timer: TimerPreset) {
        let wasSelected = selectedTimerID == timer.id
        store.deleteTimer(timer)
        if wasSelected, let first = store.timerPresets.first {
            selectedTimerID = first.id
            currentRound = 1
            isRestPeriod = false
            remainingSeconds = first.initialSeconds
            isRunning = false
            isPaused = false
            endDate = nil
        }
    }

    private func resetTimer() {
        isRunning = false
        isPaused = false
        endDate = nil
        currentRound = 1
        isRestPeriod = false
        remainingSeconds = selectedTimer?.initialSeconds ?? 30
    }

    private func beginPeriod(seconds: Int) {
        remainingSeconds = seconds
        endDate = .now.addingTimeInterval(Double(seconds))
    }

    private func advanceCompoundTimer(_ timer: TimerPreset) -> Bool {
        guard timer.isCompound,
              let rounds = timer.rounds,
              let workSeconds = timer.workSeconds,
              let restSeconds = timer.restSeconds else { return false }

        if !isRestPeriod {
            isRestPeriod = true
            beginPeriod(seconds: restSeconds)
        } else if currentRound < rounds {
            currentRound += 1
            isRestPeriod = false
            beginPeriod(seconds: workSeconds)
        } else {
            return false
        }
        phaseFeedback.toggle()
        return true
    }

    private func runTimer() async {
        while !Task.isCancelled, isRunning, let endDate {
            let newRemaining = max(0, Int(ceil(endDate.timeIntervalSinceNow)))
            remainingSeconds = newRemaining
            if newRemaining == 0 {
                if let selectedTimer, advanceCompoundTimer(selectedTimer) {
                    continue
                }
                isRunning = false
                isPaused = false
                self.endDate = nil
                completionFeedback.toggle()
                return
            }
            try? await Task.sleep(for: reduceMotion ? .seconds(1) : .milliseconds(200))
        }
    }
}
