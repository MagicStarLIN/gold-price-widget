import SwiftUI
import WidgetKit

struct GoldPriceWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    let entry: GoldPriceTimelineProvider.Entry

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                MediumWidgetView(snapshot: entry.snapshot)
            default:
                SmallWidgetView(snapshot: entry.snapshot)
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct GoldPriceWidget: Widget {
    private let kind = "GoldPriceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GoldPriceTimelineProvider()) { entry in
            GoldPriceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("沪金追踪")
        .description("在桌面显示上海黄金交易所/沪金价格与更新时间。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
