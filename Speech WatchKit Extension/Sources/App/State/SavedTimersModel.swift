import Foundation
import Observation

@MainActor
@Observable
final class SavedTimersModel {
    private let repository: any SavedTimersRepository

    var savedTimers: [SavedTimer]

    init(repository: any SavedTimersRepository) {
        self.repository = repository
        self.savedTimers = repository.loadSavedTimers()
    }

    func save() {
        repository.saveSavedTimers(savedTimers)
    }

    func addTimer(name: String, durationMinutes: Int) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        guard durationMinutes > 0 else { return }

        savedTimers.append(SavedTimer(name: trimmedName, durationMinutes: durationMinutes))
        save()
    }

    func deleteTimers(at offsets: IndexSet) {
        savedTimers.remove(atOffsets: offsets)
        save()
    }
}
