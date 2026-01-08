import SwiftUI

struct SavedTimersListView: View {
    @Environment(AppNavigationModel.self) private var navigationModel
    @Environment(SavedTimersModel.self) private var savedTimersModel
    @Environment(TimerSessionModel.self) private var session

    var body: some View {
        List {
            if savedTimersModel.savedTimers.isEmpty {
                Text("No saved timers.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(savedTimersModel.savedTimers) { timer in
                    Button {
                        session.configure(totalMinutes: timer.durationMinutes)
                        navigationModel.push(.milestones)
                    } label: {
                        SavedTimerRowView(timer: timer)
                    }
                }
            }
        }
    }
}

#Preview {
    AppRootView()
}
