import Foundation

struct Milestone: Identifiable, Hashable, Codable, Sendable {
    var id: UUID = UUID()
    var minutesFromStart: Int = 0
    var title: String = ""

    init(id: UUID = UUID(), minutesFromStart: Int, title: String = "") {
        self.id = id
        self.minutesFromStart = minutesFromStart
        self.title = title
    }
}
