import Foundation

/// Keeps ambiguous submissions across app launches, including markers from older app versions.
struct MoyasarAttemptStore {
    private let key: String
    private let defaults: UserDefaults

    init(attemptId: String, defaults: UserDefaults = .standard) {
        key = "moyasar.pending." + attemptId.lowercased()
        self.defaults = defaults
    }

    var hasSubmitted: Bool { defaults.bool(forKey: key) }
    func markSubmitted() { defaults.set(true, forKey: key) }
    func clear() { defaults.removeObject(forKey: key) }
}
