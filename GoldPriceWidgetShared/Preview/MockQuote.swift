import Foundation

enum MockQuote {
    static let sample = GoldQuote(
        symbol: "Au99.99",
        displayName: "沪金 99.99",
        price: 742.18,
        changeValue: 3.26,
        changePercent: 0.44,
        updatedAt: Date(),
        currency: "CNY",
        sourceName: "上海黄金交易所",
        unit: "元/克"
    )

    static let snapshot = QuoteSnapshot(
        quote: sample,
        fetchedAt: Date(),
        errorMessage: nil
    )

    static let staleSnapshot = QuoteSnapshot(
        quote: sample,
        fetchedAt: Date().addingTimeInterval(-3600),
        errorMessage: "接口刷新失败，当前展示缓存数据。"
    )
}
