import SwiftUI

struct SavedTimersManageView: View {
    @Environment(SavedTimersModel.self) private var savedTimersModel

    var body: some View {
        List {
            if savedTimersModel.savedTimers.isEmpty {
                Text("No saved timers.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(savedTimersModel.savedTimers) { timer in
                    SavedTimerRowView(timer: timer)
                }
                .onDelete { offsets in
                    savedTimersModel.deleteTimers(at: offsets)
                }
            }
        }
    }
}

#Preview {
    AppRootView()
}
