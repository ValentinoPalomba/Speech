import Foundation

protocol PersistenceServiceProtocol {
    func loadTimers() -> [ListElementSaved]
    func saveTimers(_ timers: [ListElementSaved])
}

final class PersistenceService: PersistenceServiceProtocol {
    private let saveKey = "SavedData"
    
    func loadTimers() -> [ListElementSaved] {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([ListElementSaved].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    func saveTimers(_ timers: [ListElementSaved]) {
        if let encoded = try? JSONEncoder().encode(timers) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
