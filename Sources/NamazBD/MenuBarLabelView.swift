import SwiftUI
import PrayerKit

struct MenuBarLabelView: View {
    @ObservedObject var model: AppModel

    var body: some View {
        if let upcoming = model.upcoming, let countdown = model.countdownToNext {
            HStack(spacing: 4) {
                Image(systemName: upcoming.prayer.symbolName)
                Text("\(upcoming.prayer.englishName) in \(TimeFormatting.compactCountdown(countdown))")
            }
        } else {
            Image(systemName: "moon.stars")
        }
    }
}
