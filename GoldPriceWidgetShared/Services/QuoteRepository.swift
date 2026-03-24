import Foundation

struct QuoteRepository {
    private let cacheStore: CacheStore
    private let client: APIClient

    init(
        cacheStore: CacheStore = CacheStore(),
        client: APIClient = APIClient()
    ) {
        self.cacheStore = cacheStore
        self.client = client
    }

    func loadSnapshot() -> QuoteSnapshot {
        cacheStore.loadSnapshot() ?? .empty
    }

    func loadAPIKey() -> String {
        cacheStore.loadAPIKey()
    }

    func saveAPIKey(_ apiKey: String) {
        cacheStore.saveAPIKey(apiKey)
    }

    func loadInstrument() -> ShgoldInstrument {
        cacheStore.loadInstrument()
    }

    func refreshQuote() async -> QuoteSnapshot {
        let existingSnapshot = cacheStore.loadSnapshot()
        let provider = ShgoldProvider(
            apiKey: cacheStore.loadAPIKey(),
            instrument: cacheStore.loadInstrument(),
            client: client
        )

        do {
            let quote = try await provider.fetchQuote()
            let snapshot = QuoteSnapshot(
                quote: quote,
                fetchedAt: Date(),
                errorMessage: nil
            )

            try cacheStore.save(snapshot: snapshot)
            return snapshot
        } catch {
            let fallbackSnapshot = QuoteSnapshot(
                quote: existingSnapshot?.quote,
                fetchedAt: existingSnapshot?.fetchedAt ?? Date(),
                errorMessage: error.localizedDescription
            )

            try? cacheStore.save(snapshot: fallbackSnapshot)
            return fallbackSnapshot
        }
    }

    func refreshQuote(completion: @escaping (QuoteSnapshot) -> Void) {
        let existingSnapshot = cacheStore.loadSnapshot()
        let provider = ShgoldProvider(
            apiKey: cacheStore.loadAPIKey(),
            instrument: cacheStore.loadInstrument(),
            client: client
        )

        provider.fetchQuote { result in
            let snapshot: QuoteSnapshot

            switch result {
            case let .success(quote):
                snapshot = QuoteSnapshot(
                    quote: quote,
                    fetchedAt: Date(),
                    errorMessage: nil
                )
            case let .failure(error):
                snapshot = QuoteSnapshot(
                    quote: existingSnapshot?.quote,
                    fetchedAt: existingSnapshot?.fetchedAt ?? Date(),
                    errorMessage: error.localizedDescription
                )
            }

            try? cacheStore.save(snapshot: snapshot)
            completion(snapshot)
        }
    }
}
