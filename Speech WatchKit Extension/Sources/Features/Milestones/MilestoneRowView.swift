import SwiftUI

struct MilestoneRowView: View {
    let minutesFromStart: Int
    @Binding var title: String

    var body: some View {
        HStack {
            Text(Duration.seconds(minutesFromStart * 60), format: .time(pattern: .minuteSecond))
                .foregroundStyle(.secondary)
            TextField("Milestone", text: $title)
        }
    }
}

#Preview {
    AppRootView()
}
