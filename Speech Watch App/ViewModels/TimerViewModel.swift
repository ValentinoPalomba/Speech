//
//  TimerViewModel.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import Foundation
import Combine
import SwiftUI

/// Screens reachable through the navigation stack.
enum AppScreen: Hashable {
    case setMilestones
    case timerActive
    case savePreset
    case editPresets
    case selectPreset
}

/// Lifecycle of the countdown.
enum RunState: Equatable {
    case idle       // configured, not started
    case running    // counting down
    case finished   // reached zero
}

/// Single source of truth for all timer data and logic.
///
/// The countdown is **date-based**: `endDate` is the authority and `remaining`
/// is always derived from the wall clock, so suspension/relaunch never causes
/// drift. The on-screen ticker only triggers redraws.
@MainActor
final class TimerViewModel: ObservableObject {

    // MARK: - Navigation

    @Published var navigationPath = NavigationPath()

    // MARK: - Setup state

    let maxMinutes: Double = 120
    @Published var selectedMinutes: Double = 0
    @Published var milestones: [Milestone] = []

    // MARK: - Run state

    @Published private(set) var runState: RunState = .idle
    @Published private(set) var remaining: TimeInterval = 0
    @Published private(set) var sessionTotalSeconds: Int = 0
    private var endDate: Date?

    // MARK: - Presets

    @Published private(set) var savedTimers: [SavedTimer] = []
    @Published var editingPresetID: UUID?

    // MARK: - Notifications

    @Published private(set) var notificationsDenied = false

    // MARK: - Dependencies

    private let persistence: PersistenceServiceProtocol
    private let notifications: NotificationServiceProtocol
    private var ticker: AnyCancellable?

    /// True when a running timer was restored from a previous launch and the
    /// UI still has to navigate to the active screen.
    private(set) var pendingRestoredSession = false

    init(
        persistence: PersistenceServiceProtocol = PersistenceService(),
        notifications: NotificationServiceProtocol = NotificationService()
    ) {
        self.persistence = persistence
        self.notifications = notifications
        self.savedTimers = persistence.loadTimers()
        restoreSessionIfNeeded()
    }

    // MARK: - Derived values

    var selectedSeconds: Int { Int(selectedMinutes.rounded()) * 60 }
    var sessionMinutes: Double { Double(sessionTotalSeconds) / 60 }

    /// Fraction of time left, 0...1, for the progress ring.
    var progress: Double {
        sessionTotalSeconds > 0 ? max(0, min(1, remaining / Double(sessionTotalSeconds))) : 0
    }

    var remainingClock: String { TimeFormat.clock(seconds: remaining) }

    var editingPreset: SavedTimer? {
        guard let editingPresetID else { return nil }
        return savedTimers.first { $0.id == editingPresetID }
    }

    // MARK: - Navigation helpers

    func navigate(to screen: AppScreen) { navigationPath.append(screen) }

    func popToRoot() { navigationPath.removeLast(navigationPath.count) }

    // MARK: - Milestones (setup)

    func hasMilestone(atMinutes minutes: Double) -> Bool {
        milestones.contains { abs($0.minutes - minutes.rounded()) < 0.5 }
    }

    /// Adds or removes a milestone at the given minute, clamped to `0 < m < total`.
    func toggleMilestone(atMinutes minutes: Double) {
        let rounded = minutes.rounded()
        guard rounded > 0, rounded < selectedMinutes else { return }
        if let existing = milestones.first(where: { abs($0.minutes - rounded) < 0.5 }) {
            milestones.removeAll { $0.id == existing.id }
        } else {
            milestones.append(Milestone(minutes: rounded))
            milestones.sort { $0.minutes < $1.minutes }
        }
    }

    // MARK: - Timer lifecycle

    /// Prepares the active screen without starting (called when it appears).
    func prepareActiveIfNeeded() {
        guard runState != .running else { return }
        // Drop any milestone that no longer fits the (possibly reduced) duration,
        // so the dial and the scheduled notifications stay consistent.
        milestones = milestones.filter { $0.minutes > 0 && $0.minutes < selectedMinutes }
        sessionTotalSeconds = selectedSeconds
        remaining = Double(selectedSeconds)
        runState = .idle
    }

    func start() {
        guard selectedSeconds > 0, runState != .running else { return }
        let total = selectedSeconds
        let end = Date().addingTimeInterval(Double(total))
        sessionTotalSeconds = total
        endDate = end
        remaining = Double(total)
        runState = .running
        persistence.saveActiveSession(ActiveSession(endDate: end, totalSeconds: total, milestones: milestones))
        notifications.schedule(milestones: milestones, totalSeconds: total)
        startTicker()
    }

    /// User-initiated stop: returns to the ready state, clears notifications.
    func stop() {
        ticker?.cancel(); ticker = nil
        endDate = nil
        remaining = Double(sessionTotalSeconds)
        runState = .idle
        notifications.cancelAll()
        persistence.saveActiveSession(nil)
    }

    /// Finishes (reached zero), then clears the configuration and returns home.
    func finishAndReset() {
        stop()
        selectedMinutes = 0
        milestones = []
        sessionTotalSeconds = 0
        remaining = 0
        editingPresetID = nil
        popToRoot()
    }

    private func reachedZero() {
        ticker?.cancel(); ticker = nil
        endDate = nil
        remaining = 0
        runState = .finished
        persistence.saveActiveSession(nil)
    }

    private func startTicker() {
        ticker?.cancel()
        ticker = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick() }
    }

    private func tick() {
        guard let endDate else { return }
        remaining = max(0, endDate.timeIntervalSinceNow)
        if remaining <= 0 { reachedZero() }
    }

    // MARK: - Scene phase

    /// Reconcile the countdown against the wall clock when returning to foreground.
    func onScenePhaseActive() {
        guard runState == .running, let endDate else { return }
        remaining = max(0, endDate.timeIntervalSinceNow)
        if remaining <= 0 {
            reachedZero()
        } else {
            startTicker()
        }
    }

    /// Stop the UI ticker while backgrounded; `endDate` keeps the truth.
    func onScenePhaseInactive() {
        ticker?.cancel(); ticker = nil
    }

    private func restoreSessionIfNeeded() {
        guard let session = persistence.loadActiveSession() else { return }
        guard session.endDate.timeIntervalSinceNow > 0 else {
            persistence.saveActiveSession(nil)
            return
        }
        sessionTotalSeconds = session.totalSeconds
        selectedMinutes = Double(session.totalSeconds) / 60
        milestones = session.milestones
        endDate = session.endDate
        remaining = max(0, session.endDate.timeIntervalSinceNow)
        runState = .running
        pendingRestoredSession = true
        // Notifications were scheduled at the original start and are still pending.
        // Drive the on-screen countdown: scenePhase `.onChange` does NOT fire for
        // the initial `.active` value on a cold launch, so without this the
        // restored timer would freeze on screen and never reach zero in-app.
        startTicker()
    }

    /// Consumes the restored-session flag after the UI has navigated to it.
    func consumeRestoredSession() -> Bool {
        defer { pendingRestoredSession = false }
        return pendingRestoredSession
    }

    // MARK: - Notification authorization

    func requestNotificationAuthorizationIfNeeded() async {
        switch await notifications.currentStatus() {
        case .notDetermined:
            notificationsDenied = !(await notifications.requestAuthorization())
        case .denied:
            notificationsDenied = true
        default:
            notificationsDenied = false
        }
    }

    // MARK: - Presets

    func selectPreset(_ preset: SavedTimer) {
        guard preset.durationSeconds > 0 else { return }
        selectedMinutes = preset.minutes
        milestones = preset.milestones
        editingPresetID = nil
        navigate(to: .setMilestones)
    }

    func beginNewPreset() {
        editingPresetID = nil
        navigate(to: .savePreset)
    }

    func beginEditing(_ preset: SavedTimer) {
        editingPresetID = preset.id
        selectedMinutes = preset.minutes
        milestones = preset.milestones
        navigate(to: .savePreset)
    }

    /// Suggested defaults for the save screen.
    var draftName: String { editingPreset?.name ?? String(localized: "preset.defaultName \(savedTimers.count + 1)") }
    var draftColorIndex: Int { editingPreset?.colorIndex ?? (savedTimers.count % TimerPalette.count) }

    func savePreset(name: String, colorIndex: Int) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, selectedSeconds > 0 else { return }

        // Never persist milestones that fall outside the saved duration.
        let totalMinutes = Double(selectedSeconds) / 60
        let validMilestones = milestones.filter { $0.minutes > 0 && $0.minutes < totalMinutes }

        if let editingPresetID, let index = savedTimers.firstIndex(where: { $0.id == editingPresetID }) {
            savedTimers[index].name = trimmed
            savedTimers[index].durationSeconds = selectedSeconds
            savedTimers[index].colorIndex = colorIndex
            savedTimers[index].milestones = validMilestones
        } else {
            savedTimers.append(
                SavedTimer(
                    name: trimmed,
                    durationSeconds: selectedSeconds,
                    colorIndex: colorIndex,
                    milestones: validMilestones
                )
            )
        }
        persistence.saveTimers(savedTimers)
        editingPresetID = nil
        popToRoot()
    }

    func deletePreset(_ preset: SavedTimer) {
        savedTimers.removeAll { $0.id == preset.id }
        persistence.saveTimers(savedTimers)
    }

    func deletePresets(at offsets: IndexSet) {
        savedTimers.remove(atOffsets: offsets)
        persistence.saveTimers(savedTimers)
    }

    // MARK: - Screenshot support (Debug only)

    #if DEBUG
    /// The screen requested through the launch environment for automated
    /// App Store screenshots (`SPEECH_UITEST=1`, `SPEECH_SCREEN=...`).
    var uiTestScreen: String? {
        let env = ProcessInfo.processInfo.environment
        guard env["SPEECH_UITEST"] == "1" else { return nil }
        return env["SPEECH_SCREEN"] ?? "setMinute"
    }

    /// Seeds representative data so screenshots show a realistic, full app.
    func applyUITestSetup() {
        selectedMinutes = 15
        milestones = [Milestone(minutes: 5), Milestone(minutes: 10)]
        savedTimers = [
            SavedTimer(name: "Keynote", durationSeconds: 1200, colorIndex: 0,
                       milestones: [Milestone(minutes: 5), Milestone(minutes: 15)]),
            SavedTimer(name: "Pitch", durationSeconds: 600, colorIndex: 1,
                       milestones: [Milestone(minutes: 3)]),
            SavedTimer(name: "Lightning", durationSeconds: 300, colorIndex: 2, milestones: []),
            SavedTimer(name: "Webinar", durationSeconds: 2700, colorIndex: 3, milestones: []),
        ]
        if uiTestScreen == "active" {
            sessionTotalSeconds = 15 * 60
            remaining = 7 * 60 + 23
            runState = .running
        }
    }
    #endif
}
