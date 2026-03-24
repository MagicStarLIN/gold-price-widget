import XCTest

final class ShgoldProviderTests: XCTestCase {
    func testParseQuoteExtractsPreferredInstrument() throws {
        let payload = """
        {
          "status": 0,
          "msg": "ok",
          "result": [
            {
              "type": "Au(T+D)",
              "typename": "黄金延期",
              "price": "588.10",
              "changepercent": "-0.90%",
              "lastclosingprice": "593.45",
              "updatetime": "2026-03-24 09:30:00"
            },
            {
              "type": "Au99.99",
              "typename": "沪金 99.99",
              "price": "728.36",
              "changepercent": "0.42%",
              "lastclosingprice": "725.31",
              "updatetime": "2026-03-24 09:31:15"
            }
          ]
        }
        """

        let quote = try ShgoldProvider.parseQuote(from: Data(payload.utf8), instrument: .au9999)

        XCTAssertEqual(quote.symbol, "Au99.99")
        XCTAssertEqual(quote.displayName, "沪金 99.99")
        XCTAssertEqual(quote.price, 728.36, accuracy: 0.001)
        XCTAssertEqual(quote.changeValue, 3.05, accuracy: 0.001)
        XCTAssertEqual(quote.changePercent, 0.42, accuracy: 0.001)
    }

    func testParseQuoteThrowsForMissingInstrument() {
        let payload = """
        {
          "status": 0,
          "msg": "ok",
          "result": []
        }
        """

        XCTAssertThrowsError(try ShgoldProvider.parseQuote(from: Data(payload.utf8), instrument: .au9999))
    }
}
