import Foundation

struct SavedTimer: Identifiable, Hashable, Codable, Sendable {
    var id: UUID = UUID()
    var name: String = ""
    var durationMinutes: Int = 0

    var duration: Duration {
        .seconds(durationMinutes * 60)
    }

    var formattedDuration: String {
        duration.formatted(.time(pattern: .minuteSecond))
    }

    init(id: UUID = UUID(), name: String, durationMinutes: Int) {
        self.id = id
        self.name = name
        self.durationMinutes = durationMinutes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""

        if let durationMinutes = try container.decodeIfPresent(Int.self, forKey: .durationMinutes) {
            self.durationMinutes = max(0, durationMinutes)
            return
        }

        if let timerDouble = try container.decodeIfPresent(Double.self, forKey: .timerDouble) {
            durationMinutes = max(0, Int(timerDouble.rounded()))
            return
        }

        if let timerString = try container.decodeIfPresent(String.self, forKey: .timerString),
           let parsedMinutes = Self.parseMinutes(fromLegacyTimerString: timerString)
        {
            durationMinutes = max(0, parsedMinutes)
            return
        }

        durationMinutes = 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(durationMinutes, forKey: .durationMinutes)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case durationMinutes

        case timerString
        case timerDouble
    }

    private static func parseMinutes(fromLegacyTimerString timerString: String) -> Int? {
        let parts = timerString.split(separator: ":")
        guard let minutesPart = parts.first else { return nil }
        return Int(minutesPart)
    }
}
