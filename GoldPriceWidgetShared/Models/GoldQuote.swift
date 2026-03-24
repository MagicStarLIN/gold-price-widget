import Foundation

enum PriceDirection: String, Codable {
    case up
    case down
    case flat
}

struct GoldQuote: Codable, Equatable, Identifiable {
    let symbol: String
    let displayName: String
    let price: Double
    let changeValue: Double
    let changePercent: Double
    let updatedAt: Date
    let currency: String
    let sourceName: String
    let unit: String

    var id: String { symbol }

    var direction: PriceDirection {
        if changeValue > 0 {
            return .up
        }

        if changeValue < 0 {
            return .down
        }

        return .flat
    }
}
