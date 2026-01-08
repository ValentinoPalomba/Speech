import SwiftUI

struct SavedTimerRowView: View {
    let timer: SavedTimer

    var body: some View {
        HStack {
            Text(timer.name.isEmpty ? "Timer" : timer.name)
            Spacer()
            Text(timer.duration, format: .time(pattern: .minuteSecond))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    AppRootView()
}
