import SwiftUI
import PrayerKit

struct MenuBarLabelView: View {
    @ObservedObject var model: AppModel

    var body: some View {
        if let upcoming = model.upcoming, let countdown = model.countdownToNext {
            Text("\(upcoming.prayer.englishName) \(TimeFormatting.compactCountdown(countdown))")
        } else {
            Text("Namaz BD")
        }
    }
}
