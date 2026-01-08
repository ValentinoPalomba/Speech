import SwiftUI

struct AppRootView: View {
    @State private var navigationModel = AppNavigationModel()
    @State private var savedTimersModel: SavedTimersModel
    @State private var timerSessionModel: TimerSessionModel

    init() {
        let savedTimersRepository = UserDefaultsSavedTimersRepository()
        let notificationScheduler = UserNotificationScheduler()

        _savedTimersModel = State(initialValue: SavedTimersModel(repository: savedTimersRepository))
        _timerSessionModel = State(initialValue: TimerSessionModel(notificationScheduler: notificationScheduler))
    }

    var body: some View {
        @Bindable var navigationModel = navigationModel

        NavigationStack(path: $navigationModel.path) {
            TimerSetupView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .milestones:
                        MilestoneSetupView()
                    case .timer:
                        TimerRunView()
                    case .saveTimer:
                        SaveTimerView()
                    case .savedTimersList:
                        SavedTimersListView()
                    case .savedTimersManage:
                        SavedTimersManageView()
                    }
                }
        }
        .environment(navigationModel)
        .environment(savedTimersModel)
        .environment(timerSessionModel)
    }
}

