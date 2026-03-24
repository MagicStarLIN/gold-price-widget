import Foundation

private final class CompletionBox<T>: @unchecked Sendable {
    let value: T

    init(_ value: T) {
        self.value = value
    }
}

enum APIClientError: LocalizedError {
    case invalidResponse
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "接口返回了无效响应。"
        case let .httpStatus(statusCode):
            return "接口请求失败，状态码 \(statusCode)。"
        }
    }
}

struct APIClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from url: URL, headers: [String: String] = [:]) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.cachePolicy = .reloadIgnoringLocalCacheData

        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            throw APIClientError.httpStatus(httpResponse.statusCode)
        }

        return data
    }

    func get(
        from url: URL,
        headers: [String: String] = [:],
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let completionBox = CompletionBox(completion)
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.cachePolicy = .reloadIgnoringLocalCacheData

        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                completionBox.value(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completionBox.value(.failure(APIClientError.invalidResponse))
                return
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                completionBox.value(.failure(APIClientError.httpStatus(httpResponse.statusCode)))
                return
            }

            guard let data else {
                completionBox.value(.failure(APIClientError.invalidResponse))
                return
            }

            completionBox.value(.success(data))
        }

        task.resume()
    }
}
