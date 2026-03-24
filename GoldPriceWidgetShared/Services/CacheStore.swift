import Foundation

struct CacheStore {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = AppConfig.sharedDefaults) {
        self.defaults = defaults
    }

    func loadSnapshot() -> QuoteSnapshot? {
        guard let data = defaults.data(forKey: AppConfig.snapshotCacheKey) else {
            return nil
        }

        return try? decoder.decode(QuoteSnapshot.self, from: data)
    }

    func save(snapshot: QuoteSnapshot) throws {
        let data = try encoder.encode(snapshot)
        defaults.set(data, forKey: AppConfig.snapshotCacheKey)
    }

    func loadAPIKey() -> String {
        defaults.string(forKey: AppConfig.apiKeyDefaultsKey) ?? ""
    }

    func saveAPIKey(_ apiKey: String) {
        defaults.set(apiKey.trimmingCharacters(in: .whitespacesAndNewlines), forKey: AppConfig.apiKeyDefaultsKey)
    }

    func loadInstrument() -> ShgoldInstrument {
        guard
            let rawValue = defaults.string(forKey: AppConfig.preferredInstrumentKey),
            let instrument = ShgoldInstrument(rawValue: rawValue)
        else {
            return AppConfig.defaultInstrument
        }

        return instrument
    }

    func saveInstrument(_ instrument: ShgoldInstrument) {
        defaults.set(instrument.rawValue, forKey: AppConfig.preferredInstrumentKey)
    }
}
