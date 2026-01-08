import SwiftUI

struct TimerRunView: View {
    @Environment(AppNavigationModel.self) private var navigationModel
    @Environment(TimerSessionModel.self) private var session

    var body: some View {
        VStack {
            Text("Remaining")
                .font(.headline)

            Text(Duration.seconds(session.remainingMinutes * 60), format: .time(pattern: .minuteSecond))
                .font(.title)
                .bold()

            if session.isRunning {
                Button("Stop") {
                    session.stop()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Start") {
                    session.start()
                }
                .buttonStyle(.borderedProminent)
                .disabled(session.totalMinutes < 1)
            }

            Button("Save timer", systemImage: "tray.and.arrow.down") {
                navigationModel.push(.saveTimer)
            }
            .buttonStyle(.bordered)

            Button("Select saved timer", systemImage: "list.bullet") {
                navigationModel.push(.savedTimersList)
            }
            .buttonStyle(.bordered)

            Button("Manage saved timers", systemImage: "slider.horizontal.3") {
                navigationModel.push(.savedTimersManage)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    AppRootView()
}
