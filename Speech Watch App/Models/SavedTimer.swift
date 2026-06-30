//
//  SavedTimer.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import Foundation

/// A user-saved timer preset: a named duration plus its milestones.
struct SavedTimer: Identifiable, Hashable, Codable {

    let id: UUID
    var name: String

    /// Total duration in seconds (single source of truth; display is derived).
    var durationSeconds: Int

    /// Index into the preset colour palette used to tint the list row.
    var colorIndex: Int

    var milestones: [Milestone]

    init(
        id: UUID = UUID(),
        name: String,
        durationSeconds: Int,
        colorIndex: Int = 0,
        milestones: [Milestone] = []
    ) {
        self.id = id
        self.name = name
        self.durationSeconds = durationSeconds
        self.colorIndex = colorIndex
        self.milestones = milestones
    }

    /// Duration expressed in minutes (the unit used by the Digital Crown).
    var minutes: Double { Double(durationSeconds) / 60.0 }

    /// "MM:SS" display string derived from the stored duration.
    var displayTime: String { TimeFormat.clock(seconds: durationSeconds) }
}
