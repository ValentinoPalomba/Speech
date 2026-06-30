//
//  NotificationService.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import Foundation
import UserNotifications
import os

protocol NotificationServiceProtocol {
    /// Requests authorisation once and returns whether it was granted.
    func requestAuthorization() async -> Bool
    /// The current authorisation status.
    func currentStatus() async -> UNAuthorizationStatus
    /// Schedules milestone notifications plus the end-of-timer notification,
    /// all relative to "now" (i.e. the moment the timer starts).
    func schedule(milestones: [Milestone], totalSeconds: Int)
    /// Removes every pending Speech notification.
    func cancelAll()
}

/// Wraps `UNUserNotificationCenter`: builds the milestone/end requests and
/// presents them (with haptic) even while the app is in the foreground.
nonisolated final class NotificationService: NSObject, NotificationServiceProtocol, UNUserNotificationCenterDelegate {

    static let endIdentifier = "speech.timer.end"

    private let center = UNUserNotificationCenter.current()
    private let log = Logger(subsystem: "com.valentinopalomba.speech", category: "Notifications")

    override init() {
        super.init()
        center.delegate = self
    }

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            log.error("Authorization request failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    func currentStatus() async -> UNAuthorizationStatus {
        await center.notificationSettings().authorizationStatus
    }

    func schedule(milestones: [Milestone], totalSeconds: Int) {
        cancelAll()
        guard totalSeconds > 0 else { return }
        let totalMinutes = Int((Double(totalSeconds) / 60).rounded())

        for milestone in milestones {
            let interval = milestone.minutes * 60
            // A valid trigger must be strictly in the future and before the end.
            guard interval > 0, interval < Double(totalSeconds) else { continue }

            let elapsed = Int(milestone.minutes.rounded())
            let remaining = max(0, totalMinutes - elapsed)

            let content = UNMutableNotificationContent()
            content.title = String(localized: "notification.milestone.title \(elapsed)")
            content.body = String(localized: "notification.milestone.body \(remaining)")
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let request = UNNotificationRequest(identifier: milestone.notificationID, content: content, trigger: trigger)
            center.add(request) { [log] error in
                if let error { log.error("Failed to schedule milestone: \(error.localizedDescription, privacy: .public)") }
            }
        }

        let endContent = UNMutableNotificationContent()
        endContent.title = String(localized: "notification.end.title")
        endContent.body = String(localized: "notification.end.body")
        endContent.sound = .default
        let endTrigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(totalSeconds), repeats: false)
        let endRequest = UNNotificationRequest(identifier: Self.endIdentifier, content: endContent, trigger: endTrigger)
        center.add(endRequest) { [log] error in
            if let error { log.error("Failed to schedule end notification: \(error.localizedDescription, privacy: .public)") }
        }
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }

    // MARK: - UNUserNotificationCenterDelegate

    /// Present milestone/end alerts (and their haptic) even when the user is
    /// looking at the timer, so a checkpoint reached in-app is still felt.
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }
}
