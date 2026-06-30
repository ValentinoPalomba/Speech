//
//  PersistenceService.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import Foundation

/// A timer that is currently running, persisted so it can be restored if the
/// app is suspended/relaunched mid-speech (very common on watchOS).
struct ActiveSession: Codable, Equatable {
    var endDate: Date
    var totalSeconds: Int
    var milestones: [Milestone]
}

protocol PersistenceServiceProtocol {
    func loadTimers() -> [SavedTimer]
    func saveTimers(_ timers: [SavedTimer])
    func loadActiveSession() -> ActiveSession?
    func saveActiveSession(_ session: ActiveSession?)
}

/// Stores presets and the in-progress session in `UserDefaults` as JSON.
nonisolated final class PersistenceService: PersistenceServiceProtocol {

    private let defaults: UserDefaults
    private let timersKey = "speech.savedTimers.v1"
    private let sessionKey = "speech.activeSession.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadTimers() -> [SavedTimer] {
        guard let data = defaults.data(forKey: timersKey),
              let decoded = try? JSONDecoder().decode([SavedTimer].self, from: data) else {
            return []
        }
        return decoded
    }

    func saveTimers(_ timers: [SavedTimer]) {
        guard let data = try? JSONEncoder().encode(timers) else { return }
        defaults.set(data, forKey: timersKey)
    }

    func loadActiveSession() -> ActiveSession? {
        guard let data = defaults.data(forKey: sessionKey),
              let session = try? JSONDecoder().decode(ActiveSession.self, from: data) else {
            return nil
        }
        return session
    }

    func saveActiveSession(_ session: ActiveSession?) {
        if let session, let data = try? JSONEncoder().encode(session) {
            defaults.set(data, forKey: sessionKey)
        } else {
            defaults.removeObject(forKey: sessionKey)
        }
    }
}
