import Foundation

struct UserDefaultsSavedTimersRepository: SavedTimersRepository {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let savedTimersKey: String

    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder(),
        savedTimersKey: String = "SavedData"
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
        self.savedTimersKey = savedTimersKey
    }

    func loadSavedTimers() -> [SavedTimer] {
        guard let data = userDefaults.data(forKey: savedTimersKey) else {
            return []
        }

        do {
            return try decoder.decode([SavedTimer].self, from: data)
        } catch {
            return []
        }
    }

    func saveSavedTimers(_ timers: [SavedTimer]) {
        do {
            let encoded = try encoder.encode(timers)
            userDefaults.set(encoded, forKey: savedTimersKey)
        } catch {
            return
        }
    }
}

