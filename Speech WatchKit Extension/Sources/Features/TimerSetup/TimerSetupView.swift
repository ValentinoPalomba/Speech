import SwiftUI

struct TimerSetupView: View {
    @Environment(AppNavigationModel.self) private var navigationModel
    @Environment(TimerSessionModel.self) private var session

    @State private var durationMinutes: Double = 0

    var body: some View {
        VStack {
            Text("Set time")
                .font(.headline)

            Text(Duration.seconds(Int(durationMinutes) * 60), format: .time(pattern: .minuteSecond))
                .font(.title2)
                .bold()
                .focusable(true)
                .digitalCrownRotation(
                    $durationMinutes,
                    from: 0,
                    through: 120,
                    by: 1,
                    sensitivity: .low,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )

            Button("Next") {
                let minutes = Int(durationMinutes)
                guard minutes > 0 else { return }

                session.configure(totalMinutes: minutes)
                navigationModel.push(.milestones)
            }
            .buttonStyle(.borderedProminent)
            .disabled(durationMinutes < 1)

            Button("Save timer", systemImage: "tray.and.arrow.down") {
                let minutes = Int(durationMinutes)
                guard minutes > 0 else { return }

                session.configure(totalMinutes: minutes)
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
