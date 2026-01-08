protocol TimerNotificationScheduling: Sendable {
    func requestAuthorizationIfNeeded() async
    func scheduleNotifications(for milestones: [Milestone]) async
    func cancelAllNotifications() async
}
