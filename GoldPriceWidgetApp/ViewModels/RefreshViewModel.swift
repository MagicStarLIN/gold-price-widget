import Foundation
import WidgetKit

@MainActor
final class RefreshViewModel: ObservableObject {
    @Published var snapshot: QuoteSnapshot
    @Published var apiKey: String
    @Published var instrument: ShgoldInstrument
    @Published var isRefreshing = false

    private let repository: QuoteRepository

    init(repository: QuoteRepository = QuoteRepository()) {
        self.repository = repository
        self.snapshot = repository.loadSnapshot()
        self.apiKey = repository.loadAPIKey()
        self.instrument = repository.loadInstrument()
    }

    func loadCachedData() {
        snapshot = repository.loadSnapshot()
        apiKey = repository.loadAPIKey()
        instrument = repository.loadInstrument()
    }

    func refresh() async {
        guard isRefreshing == false else { return }

        isRefreshing = true
        repository.saveAPIKey(apiKey)
        let repository = repository

        let snapshot = await withCheckedContinuation { continuation in
            repository.refreshQuote { snapshot in
                continuation.resume(returning: snapshot)
            }
        }
        self.snapshot = snapshot
        WidgetCenter.shared.reloadAllTimelines()
        isRefreshing = false
    }
}
