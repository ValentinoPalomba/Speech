//
//  SpeechTests.swift
//  SpeechTests
//
//  Created by Valentino Palomba on 30/06/26.
//

import Testing
import Foundation
@testable import Speech

@MainActor
struct SpeechTests {

    private func makeVM(
        timers: [SavedTimer] = [],
        session: ActiveSession? = nil,
        notifications: MockNotificationService = MockNotificationService()
    ) -> (TimerViewModel, MockPersistenceService, MockNotificationService) {
        let persistence = MockPersistenceService(timers: timers, session: session)
        let vm = TimerViewModel(persistence: persistence, notifications: notifications)
        return (vm, persistence, notifications)
    }

    // MARK: - TimeFormat

    @Test func clockFormatsAsMMSS() {
        #expect(TimeFormat.clock(seconds: 0) == "00:00")
        #expect(TimeFormat.clock(seconds: 61) == "01:01")
        #expect(TimeFormat.clock(seconds: 599) == "09:59")
        #expect(TimeFormat.clock(minutes: 7) == "07:00")
    }

    @Test func clockRoundsUpPartialSeconds() {
        // A countdown should show 00:01 until it truly reaches zero.
        #expect(TimeFormat.clock(seconds: 0.2) == "00:01")
        #expect(TimeFormat.clock(seconds: 30.2) == "00:31")
    }

    // MARK: - Milestones

    @Test func milestoneToggleAddsAndRemoves() {
        let (vm, _, _) = makeVM()
        vm.selectedMinutes = 10
        vm.toggleMilestone(atMinutes: 3)
        #expect(vm.milestones.count == 1)
        vm.toggleMilestone(atMinutes: 3)
        #expect(vm.milestones.isEmpty)
    }

    @Test func milestoneClampsToOpenInterval() {
        let (vm, _, _) = makeVM()
        vm.selectedMinutes = 10
        vm.toggleMilestone(atMinutes: 0)   // boundary
        vm.toggleMilestone(atMinutes: 10)  // == total
        vm.toggleMilestone(atMinutes: 15)  // > total
        #expect(vm.milestones.isEmpty)
    }

    @Test func milestonesStayOrdered() {
        let (vm, _, _) = makeVM()
        vm.selectedMinutes = 20
        vm.toggleMilestone(atMinutes: 9)
        vm.toggleMilestone(atMinutes: 3)
        vm.toggleMilestone(atMinutes: 15)
        #expect(vm.milestones.map { Int($0.minutes) } == [3, 9, 15])
    }

    // MARK: - Run lifecycle

    @Test func startSchedulesNotificationsAndPersistsSession() {
        let (vm, persistence, notifications) = makeVM()
        vm.selectedMinutes = 5
        vm.toggleMilestone(atMinutes: 2)
        vm.start()
        #expect(vm.runState == .running)
        #expect(notifications.scheduleCallCount == 1)
        #expect(notifications.scheduledTotal == 300)
        #expect(persistence.session?.totalSeconds == 300)
    }

    @Test func stopClearsSessionAndCancels() {
        let (vm, persistence, notifications) = makeVM()
        vm.selectedMinutes = 5
        vm.start()
        vm.stop()
        #expect(vm.runState == .idle)
        #expect(persistence.session == nil)
        #expect(notifications.cancelCallCount >= 1)
    }

    @Test func progressIsZeroWhenNoSession() {
        let (vm, _, _) = makeVM()
        #expect(vm.progress == 0) // no divide-by-zero
    }

    // MARK: - Presets

    @Test func selectPresetLoadsDurationAndMilestones() {
        let preset = SavedTimer(name: "Talk", durationSeconds: 360, colorIndex: 2,
                                milestones: [Milestone(minutes: 2)])
        let (vm, _, _) = makeVM(timers: [preset])
        vm.selectPreset(preset)
        #expect(vm.selectedMinutes == 6)
        #expect(vm.milestones.count == 1)
    }

    @Test func savePresetCreatesThenEditsInPlace() {
        let (vm, persistence, _) = makeVM()
        vm.selectedMinutes = 8
        vm.savePreset(name: "Pitch", colorIndex: 1)
        #expect(vm.savedTimers.count == 1)
        #expect(persistence.timers.first?.durationSeconds == 480)

        let created = vm.savedTimers[0]
        vm.beginEditing(created)
        vm.selectedMinutes = 12
        vm.savePreset(name: "Pitch v2", colorIndex: 3)
        #expect(vm.savedTimers.count == 1) // updated, not appended
        #expect(vm.savedTimers[0].name == "Pitch v2")
        #expect(vm.savedTimers[0].durationSeconds == 720)
    }

    @Test func savePresetRejectsBlankName() {
        let (vm, _, _) = makeVM()
        vm.selectedMinutes = 5
        vm.savePreset(name: "   ", colorIndex: 0)
        #expect(vm.savedTimers.isEmpty)
    }

    @Test func deletePresetRemovesIt() {
        let a = SavedTimer(name: "A", durationSeconds: 60)
        let b = SavedTimer(name: "B", durationSeconds: 120)
        let (vm, persistence, _) = makeVM(timers: [a, b])
        vm.deletePreset(a)
        #expect(vm.savedTimers.map(\.name) == ["B"])
        #expect(persistence.timers.count == 1)
    }

    // MARK: - Authorization

    @Test func authorizationDeniedIsReflected() async {
        let notifications = MockNotificationService()
        notifications.status = .denied
        let (vm, _, _) = makeVM(notifications: notifications)
        await vm.requestNotificationAuthorizationIfNeeded()
        #expect(vm.notificationsDenied)
    }

    @Test func authorizationGrantedIsReflected() async {
        let notifications = MockNotificationService()
        notifications.status = .notDetermined
        notifications.grant = true
        let (vm, _, _) = makeVM(notifications: notifications)
        await vm.requestNotificationAuthorizationIfNeeded()
        #expect(!vm.notificationsDenied)
    }

    // MARK: - Session restoration

    @Test func futureSessionIsRestoredOnce() {
        let session = ActiveSession(endDate: Date().addingTimeInterval(120),
                                    totalSeconds: 300, milestones: [Milestone(minutes: 2)])
        let (vm, _, _) = makeVM(session: session)
        #expect(vm.runState == .running)
        #expect(vm.sessionTotalSeconds == 300)
        #expect(vm.consumeRestoredSession() == true)
        #expect(vm.consumeRestoredSession() == false) // consumed once
    }

    @Test func expiredSessionIsNotRestored() {
        let session = ActiveSession(endDate: Date().addingTimeInterval(-10),
                                    totalSeconds: 300, milestones: [])
        let (vm, persistence, _) = makeVM(session: session)
        #expect(vm.runState == .idle)
        #expect(persistence.session == nil) // cleared
    }

    // MARK: - Persistence round-trip (real service)

    @Test func persistenceRoundTrips() throws {
        let defaults = try #require(UserDefaults(suiteName: "test.\(UUID().uuidString)"))
        let service = PersistenceService(defaults: defaults)

        let timers = [SavedTimer(name: "A", durationSeconds: 600, colorIndex: 1,
                                 milestones: [Milestone(minutes: 3)])]
        service.saveTimers(timers)
        #expect(service.loadTimers() == timers)

        let session = ActiveSession(endDate: Date(timeIntervalSince1970: 1000),
                                    totalSeconds: 300, milestones: [])
        service.saveActiveSession(session)
        #expect(service.loadActiveSession() == session)

        service.saveActiveSession(nil)
        #expect(service.loadActiveSession() == nil)
    }
}
