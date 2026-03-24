import Foundation

protocol GoldPriceProvider {
    func fetchQuote() async throws -> GoldQuote
}

enum GoldPriceProviderError: LocalizedError {
    case missingAPIKey
    case invalidPayload
    case instrumentNotFound(String)
    case invalidNumber(String)
    case invalidTimestamp(String)
    case serverMessage(String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "请先在宿主应用中填写 AppKey。"
        case .invalidPayload:
            return "金价接口返回了无法识别的数据。"
        case let .instrumentNotFound(symbol):
            return "接口返回中未找到 \(symbol) 对应的品种。"
        case let .invalidNumber(value):
            return "接口字段数值格式无效：\(value)。"
        case let .invalidTimestamp(value):
            return "接口更新时间格式无效：\(value)。"
        case let .serverMessage(message):
            return message.isEmpty ? "金价接口返回了错误信息。" : message
        }
    }
}
