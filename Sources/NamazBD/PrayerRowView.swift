import SwiftUI
import PrayerKit

struct PrayerRowView: View {
    let prayer: Prayer
    let time: Date
    let isCurrent: Bool
    let isNext: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(accent)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 1) {
                Text(prayer.englishName)
                    .font(.system(size: 13, weight: isHighlighted ? .semibold : .regular))
                Text(prayer.banglaName)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isNext {
                Text("NEXT")
                    .font(.system(size: 9, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.accentColor))
            }

            Text(TimeFormatting.clock(time))
                .font(.system(size: 13, weight: isHighlighted ? .semibold : .regular))
                .monospacedDigit()
                .foregroundStyle(isHighlighted ? Color.primary : .secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHighlighted ? Color.accentColor.opacity(0.10) : Color.clear)
        )
    }

    private var isHighlighted: Bool { isCurrent || isNext }

    private var accent: Color {
        isHighlighted ? Color.accentColor : Color.secondary
    }

    private var iconName: String {
        switch prayer {
        case .fajr: return "sunrise"
        case .sunrise: return "sun.max"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "sun.min"
        case .maghrib: return "sunset"
        case .isha: return "moon.stars"
        }
    }
}
