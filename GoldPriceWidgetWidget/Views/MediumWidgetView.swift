import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let snapshot: QuoteSnapshot

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black.opacity(0.96), Color(red: 0.24, green: 0.18, blue: 0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("上海黄金交易所")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.75))

                    if let quote = snapshot.quote {
                        Text(quote.displayName)
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("\(DisplayFormatter.price(quote.price)) \(quote.unit)")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("\(DisplayFormatter.signedPriceChange(quote.changeValue)) | \(DisplayFormatter.signedPercent(quote.changePercent))")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(color(for: quote.direction))
                    } else {
                        Text("等待配置 AppKey")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text(snapshot.errorMessage ?? "请打开宿主应用进行配置")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.75))
                            .lineLimit(3)
                    }
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: 8) {
                    Text("更新")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.65))

                    Text(snapshot.quote.map { DisplayFormatter.shortTime($0.updatedAt) } ?? "--:--")
                        .font(.title3.monospacedDigit())
                        .foregroundStyle(.white)

                    if let errorMessage = snapshot.errorMessage {
                        Text(errorMessage)
                            .font(.caption2)
                            .foregroundStyle(.orange.opacity(0.95))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(4)
                    } else {
                        Text("缓存与时间线同步")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .padding(18)
        }
    }

    private func color(for direction: PriceDirection) -> Color {
        switch direction {
        case .up:
            return Color.red
        case .down:
            return Color.green
        case .flat:
            return Color.white.opacity(0.8)
        }
    }
}

struct MediumWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetView(snapshot: MockQuote.staleSnapshot)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
