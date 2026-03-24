import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let snapshot: QuoteSnapshot

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [Color.black.opacity(0.95), Color(red: 0.18, green: 0.14, blue: 0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("沪金")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))

                if let quote = snapshot.quote {
                    Text(DisplayFormatter.price(quote.price))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text(quote.unit)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))

                    Text(DisplayFormatter.signedPercent(quote.changePercent))
                        .font(.headline)
                        .foregroundStyle(color(for: quote.direction))

                    Spacer(minLength: 0)

                    Text(DisplayFormatter.shortTime(quote.updatedAt))
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                } else {
                    Spacer()

                    Text("等待配置")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(snapshot.errorMessage ?? "请在宿主应用中填写 AppKey")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.75))
                        .lineLimit(3)
                }
            }
            .padding(14)
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

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(snapshot: MockQuote.snapshot)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
