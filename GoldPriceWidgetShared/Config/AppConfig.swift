import Foundation

enum AppConfig {
    static let appGroupIdentifier = "group.com.liuchanglin.gold-price-widget"
    static let snapshotCacheKey = "cachedQuoteSnapshot"
    static let apiKeyDefaultsKey = "jisuAPIKey"
    static let preferredInstrumentKey = "preferredShgoldInstrument"
    static let defaultRefreshInterval: TimeInterval = 15 * 60
    static let shgoldEndpoint = URL(string: "https://api.jisuapi.com/gold/shgold")!
    static let defaultInstrument: ShgoldInstrument = .au9999

    static var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }
}
