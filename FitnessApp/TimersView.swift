import SwiftUI

struct TimersView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedFilter: TimerLibraryFilter = .all
    @State private var selectedTimerID: UUID?
    @State private var remainingSeconds = 30
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var endDate: Date?
    @State private var countUpStartedAt: Date?
    @State private var countUpElapsedBase = 0
    @State private var showingAddTimer = false
    @State private var showingPlayer = false
    @State private var editingTimer: TimerPreset?
    @State private var completionFeedback = false
    @State private var phaseFeedback = false
    @State private var lapFeedback = false
    @State private var lapCumulativeTimes: [Int] = []
    @State private var currentRound = 1
    @State private var isRestPeriod = false
    @State private var showingNotificationWarning = false
    @State private var soundEnabled = true
    @State private var hapticsEnabled = true
    @AppStorage("timerSoundStyle") private var soundStyleRawValue = TimerSoundStyle.classic.rawValue
    @AppStorage("timerSoundOverrideEnabled") private var soundOverrideEnabled = false
    @AppStorage("timerSoundOverrideStyle") private var soundOverrideStyleRawValue = TimerSoundStyle.classic.rawValue
    @AppStorage("favoriteTimerKeys") private var favoriteTimerStorage = ""

    private let popularTimerNames: Set<String> = ["Tabata", "Boxing", "HIIT", "EMOM", "AMRAP", "For Time"]

    private var favoriteKeys: Set<String> {
        Set(favoriteTimerStorage.split(separator: "\n").map(String.init))
    }

    private var selectedTimer: TimerPreset? {
        store.timerPresets.first { $0.id == selectedTimerID } ?? store.timerPresets.first
    }

    private var quickTimers: [TimerPreset] {
        store.timerPresets.filter {
            !$0.isCustom && !$0.isCompound && !popularTimerNames.contains($0.name)
                && $0.name != "Stopwatch" && $0.name != "Lap Timer" && $0.name != "Rest Timer"
        }
    }

    private var popularTimers: [TimerPreset] {
        store.timerPresets.filter { popularTimerNames.contains($0.name) }
    }

    private var specialtyTimers: [TimerPreset] {
        store.timerPresets.filter {
            !$0.isCustom && ($0.name == "Stopwatch" || $0.isLapTimer || $0.name == "Rest Timer")
        }
    }

    private var customTimers: [TimerPreset] {
        store.timerPresets.filter(\.isCustom)
    }

    private var filteredTimers: [TimerPreset] {
        switch selectedFilter {
        case .all:
            store.timerPresets
        case .predefined:
            store.timerPresets.filter { !$0.isCustom }
        case .intervals:
            store.timerPresets.filter(\.isCompound)
        case .favorites:
            store.timerPresets.filter { favoriteKeys.contains(TimerLibrarySection.favoriteKey(for: $0)) }
        }
    }

    private var isCountUp: Bool {
        selectedTimer?.isCountUp == true
    }

    private var soundStyle: TimerSoundStyle {
        let rawValue = soundOverrideEnabled
            ? soundOverrideStyleRawValue
            : selectedTimerSoundStyleRawValue
        return TimerSoundStyle(rawValue: rawValue) ?? .classic
    }

    private var overrideSoundStyle: TimerSoundStyle {
        TimerSoundStyle(rawValue: soundOverrideStyleRawValue) ?? .classic
    }

    private var selectedTimerSoundStyleRawValue: String {
        selectedTimer?.soundStyleRawValue ?? soundStyleRawValue
    }

    private var selectedTimerSoundStyleBinding: Binding<String> {
        Binding(
            get: { selectedTimerSoundStyleRawValue },
            set: { rawValue in
                guard var timer = selectedTimer else {
                    soundStyleRawValue = rawValue
                    return
                }
                timer.soundStyleRawValue = rawValue
                store.updateTimer(timer)
            }
        )
    }

    private var totalRounds: Int? {
        selectedTimer?.isCompound == true ? selectedTimer?.rounds : nil
    }

    private var totalSeconds: Int? {
        guard let selectedTimer, !selectedTimer.isCountUp else { return nil }
        if selectedTimer.isCompound,
           let rounds = selectedTimer.rounds,
           let workSeconds = selectedTimer.workSeconds,
           let restSeconds = selectedTimer.restSeconds {
            return rounds * workSeconds + max(rounds - 1, 0) * restSeconds
        }
        return selectedTimer.initialSeconds
    }

    private var elapsedSeconds: Int {
        guard let selectedTimer else { return 0 }
        if selectedTimer.isCountUp { return remainingSeconds }
        if selectedTimer.isCompound,
           let workSeconds = selectedTimer.workSeconds,
           let restSeconds = selectedTimer.restSeconds {
            let completedRounds = max(currentRound - 1, 0)
            let priorTime = completedRounds * (workSeconds + restSeconds)
            let currentPhaseTime = isRestPeriod
                ? workSeconds + max(restSeconds - remainingSeconds, 0)
                : max(workSeconds - remainingSeconds, 0)
            return min(priorTime + currentPhaseTime, totalSeconds ?? Int.max)
        }
        return max(selectedTimer.initialSeconds - remainingSeconds, 0)
    }

    private var remainingSessionSeconds: Int? {
        guard let totalSeconds else { return nil }
        return max(totalSeconds - elapsedSeconds, 0)
    }

    private var currentPhaseDuration: Int {
        guard let timer = selectedTimer else { return 1 }
        guard timer.isCompound else { return max(timer.initialSeconds, 1) }
        return isRestPeriod ? timer.restSeconds ?? 1 : timer.workSeconds ?? 1
    }

    private var phaseProgress: Double {
        if isCountUp { return Double(remainingSeconds % 60) / 60 }
        let duration = max(currentPhaseDuration, 1)
        return min(max(1 - Double(remainingSeconds) / Double(duration), 0), 1)
    }

    private var nextPhase: (label: String, seconds: Int)? {
        guard let selectedTimer, selectedTimer.isCompound,
              let workSeconds = selectedTimer.workSeconds,
              let restSeconds = selectedTimer.restSeconds else { return nil }
        if isRestPeriod { return ("Work", workSeconds) }
        guard restSeconds > 0 else { return nil }
        return ("Rest", restSeconds)
    }

    private var timerSoundOverrideSection: some View {
        VStack(spacing: 11) {
            HStack(spacing: 11) {
                Image(systemName: "waveform")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 36, height: 36)
                    .background(AppTheme.accent.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 3) {
                    Text("Timer sound")
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.ink)
                    Text(soundOverrideEnabled ? "One sound for every timer" : "Each timer uses its own sound")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondaryInk)
                }

                Spacer(minLength: 6)

                Toggle("Use one sound for every timer", isOn: $soundOverrideEnabled)
                    .labelsHidden()
                    .tint(AppTheme.accent)
                    .accessibilityLabel("Use one sound for every timer")
            }

            if soundOverrideEnabled {
                Divider()
                    .overlay(AppTheme.stroke)

                HStack {
                    Picker("Override sound", selection: $soundOverrideStyleRawValue) {
                        ForEach(TimerSoundStyle.allCases) { style in
                            Text(style.title).tag(style.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(AppTheme.accent)

                    Spacer()

                    Button {
                        TimerSound.play(overrideSoundStyle)
                    } label: {
                        Label("Preview", systemImage: "play.fill")
                            .font(.caption.bold())
                            .foregroundStyle(AppTheme.accent)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Preview override sound")
                }
            }
        }
        .padding(13)
        .background(AppTheme.backgroundRaised)
        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                .stroke(AppTheme.stroke, lineWidth: 1)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        TimerLibraryHeader(addTimer: showAddTimer)
                        timerSoundOverrideSection
                        TimerLibraryFilterBar(selection: $selectedFilter)

                        if isRunning || isPaused, let selectedTimer {
                            TimerActiveBanner(
                                timerName: selectedTimer.name,
                                remainingSeconds: remainingSeconds,
                                isCountUp: selectedTimer.isCountUp,
                                isRunning: isRunning,
                                open: { showingPlayer = true }
                            )
                        }

                        if selectedFilter == .all || selectedFilter == .predefined {
                            TimerLibrarySection(
                                title: "Quick Timers",
                                timers: quickTimers,
                                style: .quick,
                                favoriteKeys: favoriteKeys,
                                showsSeeAll: false,
                                timerAction: handleTimerTap,
                                favoriteAction: toggleFavorite,
                                editAction: editTimer,
                                deleteAction: deleteTimer,
                                seeAllAction: showAllPredefined
                            )

                            TimerLibrarySection(
                                title: "Popular Workout Timers",
                                timers: popularTimers,
                                style: .workout,
                                favoriteKeys: favoriteKeys,
                                showsSeeAll: true,
                                timerAction: handleTimerTap,
                                favoriteAction: toggleFavorite,
                                editAction: editTimer,
                                deleteAction: deleteTimer,
                                seeAllAction: showAllPredefined
                            )

                            if !specialtyTimers.isEmpty {
                                TimerSpecialtySection(
                                    timers: specialtyTimers,
                                    favoriteKeys: favoriteKeys,
                                    timerAction: handleTimerTap,
                                    favoriteAction: toggleFavorite,
                                    editAction: editTimer,
                                    deleteAction: deleteTimer,
                                    countdownAction: showAddTimer,
                                    seeAllAction: showAllPredefined
                                )
                            }

                            if selectedFilter == .all, !customTimers.isEmpty {
                                TimerLibrarySection(
                                    title: "Your Custom Timers",
                                    timers: customTimers,
                                    style: .mixed,
                                    favoriteKeys: favoriteKeys,
                                    showsSeeAll: false,
                                    timerAction: handleTimerTap,
                                    favoriteAction: toggleFavorite,
                                    editAction: editTimer,
                                    deleteAction: deleteTimer,
                                    seeAllAction: showAllPredefined
                                )
                            }
                        } else {
                            TimerLibrarySection(
                                title: selectedFilter.rawValue,
                                timers: filteredTimers,
                                style: .mixed,
                                favoriteKeys: favoriteKeys,
                                showsSeeAll: false,
                                timerAction: handleTimerTap,
                                favoriteAction: toggleFavorite,
                                editAction: editTimer,
                                deleteAction: deleteTimer,
                                seeAllAction: showAllPredefined
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 28)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showingAddTimer) {
            AddTimerSheet()
        }
        .sheet(item: $editingTimer) { timer in
            AddTimerSheet(timer: timer)
        }
        .fullScreenCover(isPresented: $showingPlayer) {
            if let selectedTimer {
                TimerRunView(
                    timer: selectedTimer,
                    remainingSeconds: remainingSeconds,
                    elapsedSeconds: elapsedSeconds,
                    remainingSessionSeconds: remainingSessionSeconds,
                    totalSeconds: totalSeconds,
                    phaseProgress: phaseProgress,
                    currentRound: selectedTimer.isCompound ? currentRound : nil,
                    totalRounds: totalRounds,
                    isRestPeriod: isRestPeriod,
                    isCountUp: selectedTimer.isCountUp,
                    isRunning: isRunning,
                    isPaused: isPaused,
                    nextPhaseLabel: nextPhase?.label,
                    nextPhaseSeconds: nextPhase?.seconds,
                    lapCumulativeTimes: lapCumulativeTimes,
                    soundEnabled: $soundEnabled,
                    hapticsEnabled: $hapticsEnabled,
                    timerSoundStyleRawValue: selectedTimerSoundStyleBinding,
                    back: { showingPlayer = false },
                    togglePause: toggleTimer,
                    skipPrevious: skipPrevious,
                    skipNext: skipNext,
                    recordLap: recordLap,
                    restart: restartSelectedTimer,
                    reset: resetTimer,
                    end: endTimer
                )
            }
        }
        .alert("Check notification sound settings", isPresented: $showingNotificationWarning) {
            Button("Open Settings", action: TimerNotificationManager.openAppSettings)
            Button("Not Now", role: .cancel) { }
        } message: {
            Text("To hear timer alarms outside the app, allow notifications and sounds for Total Training Tools in Settings. iOS can silence alerts when notification sounds are disabled.")
        }
        .task(id: isRunning) {
            guard isRunning else { return }
            await runTimer()
        }
        .sensoryFeedback(.success, trigger: completionFeedback)
        .sensoryFeedback(.impact(weight: .heavy), trigger: phaseFeedback)
        .sensoryFeedback(.selection, trigger: lapFeedback)
        .onAppear(perform: setInitialTimer)
        .onChange(of: store.timerPresets, syncSelectedTimer)
        .onChange(of: soundEnabled, refreshCompletionNotification)
        .onChange(of: soundOverrideEnabled, refreshCompletionNotification)
        .onChange(of: soundOverrideStyleRawValue, refreshCompletionNotification)
        .onChange(of: selectedTimer?.soundStyleRawValue, refreshCompletionNotification)
    }

    private func setInitialTimer() {
        guard selectedTimerID == nil, let first = store.timerPresets.first else { return }
        selectedTimerID = first.id
        remainingSeconds = first.initialSeconds
    }

    private func showAddTimer() {
        showingAddTimer = true
    }

    private func showAllPredefined() {
        selectedFilter = .predefined
    }

    private func start(_ timer: TimerPreset) {
        selectedTimerID = timer.id
        currentRound = 1
        isRestPeriod = false
        isPaused = false
        lapCumulativeTimes = []
        if timer.isCountUp {
            remainingSeconds = 0
            countUpElapsedBase = 0
            countUpStartedAt = .now
            endDate = nil
        } else {
            countUpElapsedBase = 0
            countUpStartedAt = nil
            beginPeriod(seconds: timer.initialSeconds)
        }
        isRunning = true
        showingPlayer = true
        if !timer.isCountUp {
            scheduleCompletionNotification(for: timer)
        }
    }

    private func handleTimerTap(_ timer: TimerPreset) {
        start(timer)
    }

    private func recordLap() {
        guard selectedTimer?.isLapTimer == true,
              isRunning,
              let countUpStartedAt else { return }

        let elapsed = countUpElapsedBase + max(0, Int(Date.now.timeIntervalSince(countUpStartedAt)))
        lapCumulativeTimes.append(max(elapsed, lapCumulativeTimes.last ?? 0))
        if hapticsEnabled { lapFeedback.toggle() }
    }

    private func toggleTimer() {
        if isRunning {
            pauseTimer()
        } else if isPaused {
            resumeTimer()
        } else if let selectedTimer {
            start(selectedTimer)
        }
    }

    private func pauseTimer() {
        guard isRunning else { return }
        if isCountUp {
            if let countUpStartedAt {
                remainingSeconds = countUpElapsedBase + max(0, Int(Date.now.timeIntervalSince(countUpStartedAt)))
            }
            countUpElapsedBase = remainingSeconds
            countUpStartedAt = nil
        } else if let endDate {
            remainingSeconds = max(0, Int(ceil(endDate.timeIntervalSinceNow)))
        }
        endDate = nil
        isRunning = false
        isPaused = isCountUp || remainingSeconds > 0
        TimerNotificationManager.cancelCompletion()
    }

    private func resumeTimer() {
        guard isPaused else { return }
        if isCountUp {
            countUpStartedAt = .now
            isPaused = false
            isRunning = true
            return
        }
        guard remainingSeconds > 0 else { return }
        endDate = .now.addingTimeInterval(Double(remainingSeconds))
        isPaused = false
        isRunning = true
        if let selectedTimer {
            scheduleCompletionNotification(for: selectedTimer)
        }
    }

    private func editTimer(_ timer: TimerPreset) {
        editingTimer = timer
    }

    private func toggleFavorite(_ timer: TimerPreset) {
        var updatedKeys = favoriteKeys
        let key = TimerLibrarySection.favoriteKey(for: timer)
        if updatedKeys.contains(key) {
            updatedKeys.remove(key)
        } else {
            updatedKeys.insert(key)
        }
        favoriteTimerStorage = updatedKeys.sorted().joined(separator: "\n")
    }

    private func removeFavorite(_ timer: TimerPreset) {
        var updatedKeys = favoriteKeys
        updatedKeys.remove(TimerLibrarySection.favoriteKey(for: timer))
        favoriteTimerStorage = updatedKeys.sorted().joined(separator: "\n")
    }

    private func syncSelectedTimer() {
        guard !isRunning, !isPaused, let selectedTimer else { return }
        currentRound = 1
        isRestPeriod = false
        remainingSeconds = selectedTimer.initialSeconds
    }

    private func deleteTimer(_ timer: TimerPreset) {
        let wasSelected = selectedTimerID == timer.id
        if wasSelected {
            TimerNotificationManager.cancelCompletion()
        }
        removeFavorite(timer)
        store.deleteTimer(timer)
        if wasSelected, let first = store.timerPresets.first {
            selectedTimerID = first.id
            currentRound = 1
            isRestPeriod = false
            remainingSeconds = first.initialSeconds
            isRunning = false
            isPaused = false
            endDate = nil
            countUpStartedAt = nil
            countUpElapsedBase = 0
        }
    }

    private func resetTimer() {
        isRunning = false
        isPaused = false
        endDate = nil
        countUpStartedAt = nil
        countUpElapsedBase = 0
        currentRound = 1
        isRestPeriod = false
        remainingSeconds = selectedTimer?.initialSeconds ?? 30
        lapCumulativeTimes = []
        TimerNotificationManager.cancelCompletion()
    }

    private func endTimer() {
        resetTimer()
        showingPlayer = false
    }

    private func restartSelectedTimer() {
        guard let selectedTimer else { return }
        start(selectedTimer)
    }

    private func beginPeriod(seconds: Int, startingAt date: Date = .now) {
        remainingSeconds = seconds
        endDate = date.addingTimeInterval(Double(seconds))
    }

    private func skipPrevious() {
        guard let selectedTimer else { return }
        if !selectedTimer.isCompound {
            start(selectedTimer)
            return
        }

        guard let workSeconds = selectedTimer.workSeconds,
              let restSeconds = selectedTimer.restSeconds else { return }
        if isRestPeriod {
            isRestPeriod = false
            beginPeriod(seconds: workSeconds)
        } else if currentRound > 1, restSeconds > 0 {
            currentRound -= 1
            isRestPeriod = true
            beginPeriod(seconds: restSeconds)
        } else {
            currentRound = max(currentRound, 1)
            isRestPeriod = false
            beginPeriod(seconds: workSeconds)
        }
        isPaused = false
        isRunning = true
        TimerNotificationManager.cancelCompletion()
        scheduleCompletionNotification(for: selectedTimer)
    }

    private func skipNext() {
        guard let selectedTimer else { return }
        if selectedTimer.isCompound {
            if advanceCompoundTimer(selectedTimer, from: .now) {
                isPaused = false
                isRunning = true
                TimerNotificationManager.cancelCompletion()
                scheduleCompletionNotification(for: selectedTimer)
            } else {
                finishTimer()
            }
        } else {
            finishTimer()
        }
    }

    private func finishTimer() {
        remainingSeconds = 0
        endDate = nil
        countUpStartedAt = nil
        isRunning = false
        isPaused = false
        TimerNotificationManager.cancelCompletion()
        if hapticsEnabled { completionFeedback.toggle() }
        if soundEnabled { TimerSound.play(soundStyle) }
    }

    private func advanceCompoundTimer(_ timer: TimerPreset, from completedEndDate: Date) -> Bool {
        guard timer.isCompound,
              let rounds = timer.rounds,
              let workSeconds = timer.workSeconds,
              let restSeconds = timer.restSeconds else { return false }

        if isRestPeriod {
            guard currentRound < rounds else { return false }
            currentRound += 1
            isRestPeriod = false
            beginPeriod(seconds: workSeconds, startingAt: completedEndDate)
        } else if restSeconds > 0 {
            isRestPeriod = true
            beginPeriod(seconds: restSeconds, startingAt: completedEndDate)
        } else if currentRound < rounds {
            currentRound += 1
            isRestPeriod = false
            beginPeriod(seconds: workSeconds, startingAt: completedEndDate)
        } else {
            return false
        }
        if hapticsEnabled { phaseFeedback.toggle() }
        return true
    }

    private func runTimer() async {
        if isCountUp {
            while !Task.isCancelled, isRunning, let countUpStartedAt {
                remainingSeconds = countUpElapsedBase + max(0, Int(Date.now.timeIntervalSince(countUpStartedAt)))
                try? await Task.sleep(for: reduceMotion ? .seconds(1) : .milliseconds(200))
            }
            return
        }

        while !Task.isCancelled, isRunning, let endDate {
            let newRemaining = max(0, Int(ceil(endDate.timeIntervalSinceNow)))
            remainingSeconds = newRemaining
            if newRemaining == 0 {
                if let selectedTimer, advanceCompoundTimer(selectedTimer, from: endDate) {
                    continue
                }
                finishTimer()
                return
            }
            try? await Task.sleep(for: reduceMotion ? .seconds(1) : .milliseconds(200))
        }
    }

    private func scheduleCompletionNotification(for timer: TimerPreset) {
        guard !timer.isCountUp else { return }
        let delay = completionDelay(for: timer)
        Task {
            let didSchedule = await TimerNotificationManager.scheduleCompletion(
                for: timer,
                after: delay,
                soundStyle: soundStyle,
                soundEnabled: soundEnabled
            )
            let canPlaySound = await TimerNotificationManager.canPlayNotificationSound()
            if (!didSchedule || (soundEnabled && !canPlaySound)), isRunning, selectedTimerID == timer.id {
                showingNotificationWarning = true
            }
        }
    }

    private func refreshCompletionNotification() {
        guard isRunning, let selectedTimer else { return }
        scheduleCompletionNotification(for: selectedTimer)
    }

    private func completionDelay(for timer: TimerPreset) -> Int {
        guard timer.isCompound,
              let rounds = timer.rounds,
              let workSeconds = timer.workSeconds,
              let restSeconds = timer.restSeconds else {
            return remainingSeconds
        }

        let roundsAfterCurrent = max(rounds - currentRound, 0)
        if isRestPeriod {
            return remainingSeconds + roundsAfterCurrent * workSeconds
                + max(roundsAfterCurrent - 1, 0) * restSeconds
        }
        guard roundsAfterCurrent > 0 else { return remainingSeconds }
        return remainingSeconds + restSeconds + roundsAfterCurrent * workSeconds
            + max(roundsAfterCurrent - 1, 0) * restSeconds
    }
}
