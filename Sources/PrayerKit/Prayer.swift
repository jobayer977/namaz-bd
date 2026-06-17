import Foundation

public enum Prayer: String, CaseIterable, Identifiable, Sendable {
    case fajr
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case isha

    public var id: String { rawValue }

    public var englishName: String {
        switch self {
        case .fajr: return "Fajr"
        case .sunrise: return "Sunrise"
        case .dhuhr: return "Dhuhr"
        case .asr: return "Asr"
        case .maghrib: return "Maghrib"
        case .isha: return "Isha"
        }
    }

    public var banglaName: String {
        switch self {
        case .fajr: return "ফজর"
        case .sunrise: return "সূর্যোদয়"
        case .dhuhr: return "যোহর"
        case .asr: return "আসর"
        case .maghrib: return "মাগরিব"
        case .isha: return "এশা"
        }
    }

    public var isPrayer: Bool { self != .sunrise }

    public static var dailyOrder: [Prayer] {
        [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
    }
}
