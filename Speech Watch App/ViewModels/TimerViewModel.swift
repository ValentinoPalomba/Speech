import Foundation
import Combine
import UserNotifications
import SwiftUI

/// Represents the different screens in the app for navigation.
enum AppScreen: Hashable {
    case setMilestones
    case timerActive
    case saveTimer(timerValue: Double)
    case editTimers
    case selectTimer
}

/// The single source of truth for all timer-related data and logic.
final class TimerViewModel: ObservableObject {
    
    // MARK: - Navigation
    
    @Published var navigationPath = NavigationPath()
    
    // MARK: - Timer State
    
    @Published var maxMinutes: Double = 120.0
    @Published var selectedTime: Double = 0.0
    @Published var currentTime: Double = 0.0
    @Published var isTimerRunning: Bool = false
    
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Milestones
    
    @Published var milestones: [Double] = []
    @Published var notificationRequests: [UNNotificationRequest] = []
    
    // MARK: - Saved Timers
    
    @Published var savedTimers: [ListElementSaved] = []
    
    private let persistenceService: PersistenceServiceProtocol
    private let notificationService: NotificationServiceProtocol
    
    init(
        persistenceService: PersistenceServiceProtocol = PersistenceService(),
        notificationService: NotificationServiceProtocol = NotificationService()
    ) {
        self.persistenceService = persistenceService
        self.notificationService = notificationService
        self.savedTimers = persistenceService.loadTimers()
    }
    
    // MARK: - Navigation Helpers
    
    func navigate(to screen: AppScreen) {
        navigationPath.append(screen)
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    // MARK: - Timer Logic
    
    func startTimer() {
        if !isTimerRunning {
            currentTime = selectedTime
            isTimerRunning = true
            
            // Schedule notifications using the service
            notificationService.removeAllNotifications()
            notificationService.scheduleNotifications(for: notificationRequests)
            
            // Start Timer (ticks every second to show countdown)
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    if self.currentTime > 0 {
                        // Decrement by 1 second (expressed in minutes)
                        self.currentTime -= (1.0 / 60.0)
                    } else {
                        self.currentTime = 0
                        self.stopTimer()
                    }
                }
        }
    }
    
    func formatTime(_ minutes: Double) -> String {
        let totalSeconds = Int(ceil(minutes * 60))
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    func stopTimer() {
        isTimerRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
        notificationService.removeAllNotifications()
    }
    
    func resetTimer() {
        stopTimer()
        selectedTime = 0.0
        currentTime = 0.0
        milestones = []
        notificationRequests = []
    }
    
    // MARK: - Milestone Logic
    
    func hasMilestone(at time: Double) -> Bool {
        milestones.contains(time)
    }
    
    func removeMilestone(at time: Double) {
        if let index = milestones.firstIndex(of: time) {
            milestones.remove(at: index)
            // Remove the associated notification request
            // Note: In a real app, we might want to use identifiers linked to the time
            // to be more precise, but for now we'll just remove the one at the same index
            if index < notificationRequests.count {
                notificationRequests.remove(at: index)
            }
            print("Removed milestone at \(time)")
        }
    }
    
    func addMilestone(at time: Double) {
        guard !hasMilestone(at: time) else { return }
        
        milestones.append(time)
        
        notificationService.requestAuthorization()
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Sono passati \(Int(time)) minuti"
        notificationContent.body = "Mancano \(Int(selectedTime - time)) minuti alla fine"
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.sound = UNNotificationSound.default
        
        if let url = Bundle.main.url(forResource: "dune", withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune", url: url, options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time * 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        notificationRequests.append(request)
        print("Added milestone at \(time)")
    }
    
    // MARK: - Persistence Logic
    
    func saveNewTimer(name: String, time: Double) {
        let newTimer = ListElementSaved(name: name, timerString: "\(Int(time)):00", timerDouble: time)
        savedTimers.append(newTimer)
        persistenceService.saveTimers(savedTimers)
    }
    
    func loadTimers() {
        savedTimers = persistenceService.loadTimers()
    }
}
