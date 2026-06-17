import SwiftUI
import PrayerKit

extension Prayer {
    var symbolName: String {
        switch self {
        case .fajr: return "cloud.moon"
        case .sunrise: return "sunrise"
        case .dhuhr: return "sun.max"
        case .asr: return "sun.min"
        case .maghrib: return "sunset"
        case .isha: return "moon.stars"
        }
    }

    var symbolTint: Color {
        switch self {
        case .fajr: return .indigo
        case .sunrise: return .orange
        case .dhuhr: return .yellow
        case .asr: return .orange
        case .maghrib: return .pink
        case .isha: return .indigo
        }
    }
}
