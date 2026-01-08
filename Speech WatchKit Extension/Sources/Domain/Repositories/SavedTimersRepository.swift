protocol SavedTimersRepository {
    func loadSavedTimers() -> [SavedTimer]
    func saveSavedTimers(_ timers: [SavedTimer])
}

