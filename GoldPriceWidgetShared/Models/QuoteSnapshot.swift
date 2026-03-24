import Foundation

struct QuoteSnapshot: Codable, Equatable {
    let quote: GoldQuote?
    let fetchedAt: Date
    let errorMessage: String?

    static let empty = QuoteSnapshot(
        quote: nil,
        fetchedAt: .distantPast,
        errorMessage: "请先在宿主应用中配置沪金数据接口 AppKey。"
    )
}
