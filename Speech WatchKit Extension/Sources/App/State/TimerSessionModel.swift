import Foundation
import Observation

@MainActor
@Observable
final class TimerSessionModel {
    private let notificationScheduler: any TimerNotificationScheduling
    private var countdownTask: Task<Void, Never>?

    var totalMinutes: Int = 0
    var remainingMinutes: Int = 0
    var milestones: [Milestone] = []
    var isRunning: Bool = false

    init(notificationScheduler: any TimerNotificationScheduling) {
        self.notificationScheduler = notificationScheduler
    }

    func configure(totalMinutes: Int) {
        stop()

        self.totalMinutes = max(0, totalMinutes)
        remainingMinutes = self.totalMinutes
        milestones.removeAll()
    }

    func addMilestone(minutesFromStart: Int) {
        guard totalMinutes > 0 else { return }
        guard minutesFromStart > 0 else { return }
        guard minutesFromStart < totalMinutes else { return }

        let milestone = Milestone(minutesFromStart: minutesFromStart)
        milestones.append(milestone)
        milestones.sort { $0.minutesFromStart < $1.minutesFromStart }
    }

    func deleteMilestones(at offsets: IndexSet) {
        milestones.remove(atOffsets: offsets)
    }

    func start() {
        guard totalMinutes > 0 else { return }
        guard !isRunning else { return }

        stop()

        remainingMinutes = totalMinutes
        isRunning = true

        countdownTask = Task { @MainActor in
            await notificationScheduler.scheduleNotifications(for: milestones)

            while !Task.isCancelled, remainingMinutes > 0 {
                do {
                    try await Task.sleep(for: .seconds(60))
                } catch {
                    break
                }

                guard !Task.isCancelled else { break }
                remainingMinutes -= 1
            }

            isRunning = false
        }
    }

    func stop() {
        countdownTask?.cancel()
        countdownTask = nil
        isRunning = false
        let scheduler = notificationScheduler
        Task {
            await scheduler.cancelAllNotifications()
        }
    }
}
