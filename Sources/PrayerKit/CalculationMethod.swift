import Foundation

public enum AsrJuristic: String, CaseIterable, Sendable, Codable {
    case standard
    case hanafi

    public var shadowFactor: Double {
        switch self {
        case .standard: return 1
        case .hanafi: return 2
        }
    }

    public var displayName: String {
        switch self {
        case .standard: return "Standard (Shafi/Maliki/Hanbali)"
        case .hanafi: return "Hanafi"
        }
    }
}

public enum CalculationMethod: String, CaseIterable, Sendable, Codable {
    case islamicFoundationBangladesh
    case karachi
    case muslimWorldLeague
    case egyptian

    public var fajrAngle: Double {
        switch self {
        case .islamicFoundationBangladesh: return 18
        case .karachi: return 18
        case .muslimWorldLeague: return 18
        case .egyptian: return 19.5
        }
    }

    public var ishaAngle: Double {
        switch self {
        case .islamicFoundationBangladesh: return 18
        case .karachi: return 18
        case .muslimWorldLeague: return 17
        case .egyptian: return 17.5
        }
    }

    public var displayName: String {
        switch self {
        case .islamicFoundationBangladesh: return "Islamic Foundation Bangladesh"
        case .karachi: return "University of Islamic Sciences, Karachi"
        case .muslimWorldLeague: return "Muslim World League"
        case .egyptian: return "Egyptian General Authority"
        }
    }

    public static var bangladeshDefault: CalculationMethod { .islamicFoundationBangladesh }
}
