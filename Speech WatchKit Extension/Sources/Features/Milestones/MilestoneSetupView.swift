import SwiftUI

struct MilestoneSetupView: View {
    @Environment(AppNavigationModel.self) private var navigationModel
    @Environment(TimerSessionModel.self) private var session

    @State private var milestoneMinutes: Double = 0

    var body: some View {
        @Bindable var session = session

        List {
            Section {
                Text("Total time")
                    .font(.headline)

                Text(Duration.seconds(session.totalMinutes * 60), format: .time(pattern: .minuteSecond))
                    .font(.title3)
                    .bold()
            }

            Section {
                Text("Milestone time")
                    .font(.headline)

                Text(Duration.seconds(Int(milestoneMinutes) * 60), format: .time(pattern: .minuteSecond))
                    .font(.title3)
                    .bold()
                    .focusable(true)
                    .digitalCrownRotation(
                        $milestoneMinutes,
                        from: 0,
                        through: Double(session.totalMinutes),
                        by: 1,
                        sensitivity: .low,
                        isContinuous: false,
                        isHapticFeedbackEnabled: true
                    )

                Button("Add milestone") {
                    session.addMilestone(minutesFromStart: Int(milestoneMinutes))
                }
                .buttonStyle(.bordered)
            }

            if session.milestones.isEmpty {
                Section {
                    Text("No milestones yet.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } else {
                Section("Milestones") {
                    ForEach($session.milestones) { $milestone in
                        MilestoneRowView(minutesFromStart: milestone.minutesFromStart, title: $milestone.title)
                    }
                    .onDelete { offsets in
                        session.deleteMilestones(at: offsets)
                    }
                }
            }

            Section {
                Button("Start") {
                    navigationModel.push(.timer)
                }
                .buttonStyle(.borderedProminent)
                .disabled(session.totalMinutes < 1)
            }
        }
    }
}

#Preview {
    AppRootView()
}
