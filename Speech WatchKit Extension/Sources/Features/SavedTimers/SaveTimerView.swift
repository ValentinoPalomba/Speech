import SwiftUI

struct SaveTimerView: View {
    @Environment(AppNavigationModel.self) private var navigationModel
    @Environment(SavedTimersModel.self) private var savedTimersModel
    @Environment(TimerSessionModel.self) private var session

    @State private var name: String = ""

    var body: some View {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        VStack {
            Text("Save timer")
                .font(.headline)

            Text(Duration.seconds(session.totalMinutes * 60), format: .time(pattern: .minuteSecond))
                .font(.title3)
                .bold()

            TextField("Name", text: $name)

            Button("Save") {
                savedTimersModel.addTimer(name: trimmedName, durationMinutes: session.totalMinutes)
                navigationModel.popToRoot()
            }
            .buttonStyle(.borderedProminent)
            .disabled(trimmedName.isEmpty || session.totalMinutes < 1)
        }
    }
}

#Preview {
    AppRootView()
}
