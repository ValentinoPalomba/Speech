import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorization()
    func scheduleNotifications(for requests: [UNNotificationRequest])
    func removeAllNotifications()
}

final class NotificationService: NotificationServiceProtocol {
    
    func requestAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Notification Authorization Error: \(error)")
            }
        }
    }
    
    func scheduleNotifications(for requests: [UNNotificationRequest]) {
        let center = UNUserNotificationCenter.current()
        for request in requests {
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
