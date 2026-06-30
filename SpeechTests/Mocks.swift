//
//  Mocks.swift
//  SpeechTests
//
//  Created by Valentino Palomba on 30/06/26.
//

import Foundation
import UserNotifications
@testable import Speech

/// In-memory persistence for tests.
nonisolated final class MockPersistenceService: PersistenceServiceProtocol {
    var timers: [SavedTimer]
    var session: ActiveSession?
    private(set) var saveTimersCallCount = 0

    init(timers: [SavedTimer] = [], session: ActiveSession? = nil) {
        self.timers = timers
        self.session = session
    }

    func loadTimers() -> [SavedTimer] { timers }
    func saveTimers(_ timers: [SavedTimer]) { self.timers = timers; saveTimersCallCount += 1 }
    func loadActiveSession() -> ActiveSession? { session }
    func saveActiveSession(_ session: ActiveSession?) { self.session = session }
}

/// Records scheduling/authorisation calls for tests.
nonisolated final class MockNotificationService: NotificationServiceProtocol {
    var status: UNAuthorizationStatus = .notDetermined
    var grant = true

    private(set) var scheduledMilestones: [Milestone] = []
    private(set) var scheduledTotal = 0
    private(set) var scheduleCallCount = 0
    private(set) var cancelCallCount = 0

    func requestAuthorization() async -> Bool {
        status = grant ? .authorized : .denied
        return grant
    }

    func currentStatus() async -> UNAuthorizationStatus { status }

    func schedule(milestones: [Milestone], totalSeconds: Int) {
        scheduledMilestones = milestones
        scheduledTotal = totalSeconds
        scheduleCallCount += 1
    }

    func cancelAll() { cancelCallCount += 1 }
}
