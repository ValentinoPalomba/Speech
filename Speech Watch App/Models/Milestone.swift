//
//  Milestone.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import Foundation

/// A checkpoint during a speech, expressed in minutes elapsed from the start,
/// at which the speaker receives a haptic notification ("stop").
struct Milestone: Identifiable, Hashable, Codable {

    let id: UUID

    /// Minutes elapsed from the start of the timer at which the milestone fires.
    var minutes: Double

    init(id: UUID = UUID(), minutes: Double) {
        self.id = id
        self.minutes = minutes
    }

    /// Stable identifier used for the scheduled local notification, so a
    /// milestone can be cancelled/updated without relying on array position.
    var notificationID: String { id.uuidString }
}
