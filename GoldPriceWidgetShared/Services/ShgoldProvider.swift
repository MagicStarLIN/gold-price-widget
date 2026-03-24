import Foundation

struct ShgoldProvider: GoldPriceProvider {
    private let apiKey: String
    private let instrument: ShgoldInstrument
    private let client: APIClient

    init(
        apiKey: String,
        instrument: ShgoldInstrument = AppConfig.defaultInstrument,
        client: APIClient = APIClient()
    ) {
        self.apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        self.instrument = instrument
        self.client = client
    }

    func fetchQuote() async throws -> GoldQuote {
        guard apiKey.isEmpty == false else {
            throw GoldPriceProviderError.missingAPIKey
        }

        var components = URLComponents(url: AppConfig.shgoldEndpoint, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "appkey", value: apiKey)
        ]

        guard let url = components?.url else {
            throw GoldPriceProviderError.invalidPayload
        }

        let data = try await client.get(from: url)
        return try Self.parseQuote(from: data, instrument: instrument)
    }

    func fetchQuote(completion: @escaping (Result<GoldQuote, Error>) -> Void) {
        guard apiKey.isEmpty == false else {
            completion(.failure(GoldPriceProviderError.missingAPIKey))
            return
        }

        var components = URLComponents(url: AppConfig.shgoldEndpoint, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "appkey", value: apiKey)
        ]

        guard let url = components?.url else {
            completion(.failure(GoldPriceProviderError.invalidPayload))
            return
        }

        client.get(from: url) { result in
            switch result {
            case let .success(data):
                do {
                    let quote = try Self.parseQuote(from: data, instrument: instrument)
                    completion(.success(quote))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    static func parseQuote(from data: Data, instrument: ShgoldInstrument) throws -> GoldQuote {
        let response = try JSONDecoder().decode(Response.self, from: data)
        guard response.status == 0 else {
            throw GoldPriceProviderError.serverMessage(response.msg)
        }

        guard let item = response.result.first(where: { instrument.matches(symbol: $0.type) || instrument.matches(symbol: $0.typename) }) else {
            throw GoldPriceProviderError.instrumentNotFound(instrument.rawValue)
        }

        let price = try parseDouble(item.price)
        let lastClosingPrice = try parseDouble(item.lastclosingprice)
        let changePercent = try parsePercent(item.changepercent)
        let updatedAt = try parseDate(item.updatetime)

        return GoldQuote(
            symbol: item.type,
            displayName: item.typename,
            price: price,
            changeValue: price - lastClosingPrice,
            changePercent: changePercent,
            updatedAt: updatedAt,
            currency: "CNY",
            sourceName: "上海黄金交易所",
            unit: "元/克"
        )
    }
}

private extension ShgoldProvider {
    struct Response: Decodable {
        let status: Int
        let msg: String
        let result: [Item]
    }

    struct Item: Decodable {
        let type: String
        let typename: String
        let price: String
        let changepercent: String
        let lastclosingprice: String
        let updatetime: String
    }

    static func parseDouble(_ value: String) throws -> Double {
        guard let parsed = Double(value) else {
            throw GoldPriceProviderError.invalidNumber(value)
        }

        return parsed
    }

    static func parsePercent(_ value: String) throws -> Double {
        let sanitized = value.replacingOccurrences(of: "%", with: "")
        return try parseDouble(sanitized)
    }

    static func parseDate(_ value: String) throws -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let date = formatter.date(from: value) else {
            throw GoldPriceProviderError.invalidTimestamp(value)
        }

        return date
    }
}

private extension ShgoldInstrument {
    func matches(symbol: String) -> Bool {
        let normalizedSymbol = symbol.replacingOccurrences(of: " ", with: "").lowercased()
        return preferredSymbols.contains { preferred in
            preferred.replacingOccurrences(of: " ", with: "").lowercased() == normalizedSymbol
        }
    }
}
