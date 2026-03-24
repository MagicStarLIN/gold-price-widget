import Foundation
import WidgetKit

struct GoldPriceEntry: TimelineEntry {
    let date: Date
    let snapshot: QuoteSnapshot
}

struct GoldPriceTimelineProvider: TimelineProvider {
    private let repository = QuoteRepository()

    func placeholder(in context: Context) -> GoldPriceEntry {
        GoldPriceEntry(date: Date(), snapshot: MockQuote.snapshot)
    }

    func getSnapshot(in context: Context, completion: @escaping (GoldPriceEntry) -> Void) {
        let snapshot = context.isPreview ? MockQuote.snapshot : repository.loadSnapshot()
        completion(GoldPriceEntry(date: Date(), snapshot: snapshot))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GoldPriceEntry>) -> Void) {
        repository.refreshQuote { refreshedSnapshot in
            let entry = GoldPriceEntry(date: Date(), snapshot: refreshedSnapshot)
            let refreshDate = Date().addingTimeInterval(AppConfig.defaultRefreshInterval)
            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
        }
    }
}
