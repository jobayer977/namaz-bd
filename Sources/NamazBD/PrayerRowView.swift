import SwiftUI
import PrayerKit

enum PrayerRowState {
    case past
    case next
    case upcoming
}

struct PrayerRowView: View {
    let prayer: Prayer
    let time: Date
    let state: PrayerRowState
    let countdownText: String?

    var body: some View {
        HStack(spacing: 11) {
            Image(systemName: prayer.symbolName)
                .font(.system(size: 13))
                .foregroundStyle(iconColor)
                .frame(width: 18)

            Text(prayer.englishName)
                .font(.system(size: 13, weight: state == .next ? .semibold : .regular))
                .foregroundStyle(nameColor)

            Spacer(minLength: 8)

            if state == .next, let countdownText {
                Text(countdownText)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(BrandTheme.accent)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(BrandTheme.accent.opacity(0.18)))
            }

            Text(TimeFormatting.clock(time))
                .font(.system(size: 13, weight: state == .next ? .semibold : .regular))
                .monospacedDigit()
                .foregroundStyle(timeColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(state == .next ? BrandTheme.accent.opacity(0.12) : Color.clear)
        )
    }

    private var faded: Color { Color.secondary.opacity(0.55) }

    private var iconColor: Color {
        switch state {
        case .past: return faded
        case .next: return BrandTheme.accent
        case .upcoming: return prayer.symbolTint
        }
    }

    private var nameColor: Color {
        state == .past ? .secondary : .primary
    }

    private var timeColor: Color {
        switch state {
        case .past: return faded
        case .next: return BrandTheme.accent
        case .upcoming: return .secondary
        }
    }
}
