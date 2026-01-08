import Foundation
import UserNotifications

actor UserNotificationScheduler: TimerNotificationScheduling {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestAuthorizationIfNeeded() async {
        do {
            _ = try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return
        }
    }

    func scheduleNotifications(for milestones: [Milestone]) async {
        await requestAuthorizationIfNeeded()

        let sortedMilestones = milestones.sorted { $0.minutesFromStart < $1.minutesFromStart }

        for milestone in sortedMilestones {
            guard milestone.minutesFromStart > 0 else { continue }

            let content = UNMutableNotificationContent()
            content.title = milestone.title.isEmpty ? "Milestone" : milestone.title
            content.body = "Reached at \(milestone.minutesFromStart) min"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(milestone.minutesFromStart * 60), repeats: false)
            let request = UNNotificationRequest(identifier: milestone.id.uuidString, content: content, trigger: trigger)

            _ = await withCheckedContinuation { continuation in
                center.add(request) { _ in
                    continuation.resume()
                }
            }
        }
    }

    func cancelAllNotifications() async {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
}
