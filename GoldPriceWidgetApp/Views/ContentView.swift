import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RefreshViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            configurationCard
            latestSnapshotCard
            Spacer()
        }
        .padding(24)
        .frame(minWidth: 520, minHeight: 420)
        .task {
            viewModel.loadCachedData()
        }
    }
}

private extension ContentView {
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("沪金桌面小组件")
                .font(.largeTitle.bold())

            Text("展示上海黄金交易所/沪金口径，桌面 Widget 自动刷新，宿主应用支持手动拉取。")
                .foregroundStyle(.secondary)
        }
    }

    var configurationCard: some View {
        GroupBox("接口配置") {
            VStack(alignment: .leading, spacing: 12) {
                SecureField("请输入极速数据 AppKey", text: $viewModel.apiKey)
                    .textFieldStyle(.roundedBorder)

                LabeledContent("数据口径", value: "上海黄金交易所 / \(viewModel.instrument.displayName)")
                LabeledContent("接口地址", value: AppConfig.shgoldEndpoint.absoluteString)
                    .font(.caption)

                HStack(spacing: 12) {
                    Button(viewModel.isRefreshing ? "刷新中..." : "立即刷新") {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isRefreshing)

                    Text("小组件会优先读取缓存，再按系统策略刷新时间线。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var latestSnapshotCard: some View {
        GroupBox("最新数据") {
            VStack(alignment: .leading, spacing: 10) {
                if let quote = viewModel.snapshot.quote {
                    Text(quote.displayName)
                        .font(.headline)

                    Text("\(DisplayFormatter.price(quote.price)) \(quote.unit)")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))

                    Text("\(DisplayFormatter.signedPriceChange(quote.changeValue)) | \(DisplayFormatter.signedPercent(quote.changePercent))")
                        .foregroundStyle(color(for: quote.direction))

                    Text("更新时间：\(DisplayFormatter.fullTimestamp(quote.updatedAt))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("暂无可展示数据")
                        .font(.headline)
                    Text(viewModel.snapshot.errorMessage ?? "请填写 AppKey 后手动刷新。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let errorMessage = viewModel.snapshot.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func color(for direction: PriceDirection) -> Color {
        switch direction {
        case .up:
            return .red
        case .down:
            return .green
        case .flat:
            return .secondary
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
