import Foundation

enum ShgoldInstrument: String, Codable, CaseIterable, Identifiable {
    case au9999 = "Au99.99"
    case auTD = "Au(T+D)"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .au9999:
            return "沪金 99.99"
        case .auTD:
            return "黄金延期"
        }
    }

    var preferredSymbols: [String] {
        switch self {
        case .au9999:
            return ["Au99.99", "AU9999", "Au9999", "Au99.9"]
        case .auTD:
            return ["Au(T+D)", "AUT+D"]
        }
    }
}
