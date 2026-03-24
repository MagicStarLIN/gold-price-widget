import Foundation

enum DisplayFormatter {
    static func price(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(2)))
    }

    static func signedPriceChange(_ value: Double) -> String {
        String(format: "%+.2f", value)
    }

    static func signedPercent(_ value: Double) -> String {
        String(format: "%+.2f%%", value)
    }

    static func shortTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    static func fullTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
