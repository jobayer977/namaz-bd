import SwiftUI
import PrayerKit

struct PrayerPanelView: View {
    @ObservedObject var model: AppModel
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            header
            if showingSettings {
                Divider().opacity(0.35)
                SettingsView(model: model)
            } else {
                hero
                Divider().opacity(0.35).padding(.horizontal, 12)
                prayerList
                Divider().opacity(0.35).padding(.horizontal, 12)
                infoBlock
            }
            Divider().opacity(0.35)
            menu
        }
        .frame(width: BrandTheme.panelWidth)
        .tint(BrandTheme.accent)
    }

    private var header: some View {
        Text(TimeFormatting.longDate(model.now).uppercased())
            .font(.system(size: 10, weight: .semibold))
            .tracking(0.8)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)
    }

    @ViewBuilder
    private var hero: some View {
        if let upcoming = model.upcoming, let countdown = model.countdownToNext {
            HStack(alignment: .center, spacing: 11) {
                Image(systemName: upcoming.prayer.symbolName)
                    .font(.system(size: 20))
                    .foregroundStyle(upcoming.prayer.symbolTint)
                    .frame(width: 26)
                VStack(alignment: .leading, spacing: 2) {
                    Text(upcoming.prayer.englishName)
                        .font(.system(size: 17, weight: .bold))
                    Text("in \(TimeFormatting.countdown(countdown))")
                        .font(.system(size: 11, weight: .medium))
                        .monospacedDigit()
                        .foregroundStyle(BrandTheme.accent)
                }
                Spacer()
                Text(TimeFormatting.clock(upcoming.time))
                    .font(.system(size: 15, weight: .semibold))
                    .monospacedDigit()
                    .foregroundStyle(BrandTheme.accent)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }

    private var prayerList: some View {
        VStack(spacing: 1) {
            ForEach(Prayer.dailyOrder) { prayer in
                if let time = model.today?.time(for: prayer) {
                    PrayerRowView(
                        prayer: prayer,
                        time: time,
                        state: state(for: prayer, at: time),
                        countdownText: countdownText(for: prayer)
                    )
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }

    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(model.method.displayName)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 8))
                Text("\(model.selectedDistrict.englishName) · \(coordinates) · Asia/Dhaka")
            }
            .font(.system(size: 10))
            .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
    }

    private var menu: some View {
        VStack(spacing: 1) {
            MenuItemButton(
                symbol: showingSettings ? "chevron.left" : "gearshape",
                title: showingSettings ? "Back to Prayer Times" : "Settings"
            ) {
                showingSettings.toggle()
            }
            MenuItemButton(symbol: "arrow.triangle.2.circlepath", title: "Check for Updates…") {
                if let url = URL(string: "https://github.com/jobayer977/namaz-bd/releases") {
                    NSWorkspace.shared.open(url)
                }
            }
            MenuItemButton(symbol: "power", title: "Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }

    private var coordinates: String {
        let coordinate = model.selectedDistrict.coordinate
        return String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }

    private var todayNextPrayer: Prayer? {
        model.today?.nextPrayer(after: model.now)?.prayer
    }

    private func state(for prayer: Prayer, at time: Date) -> PrayerRowState {
        if prayer == todayNextPrayer {
            return .next
        }
        return time <= model.now ? .past : .upcoming
    }

    private func countdownText(for prayer: Prayer) -> String? {
        guard prayer == todayNextPrayer, let countdown = model.countdownToNext else { return nil }
        return TimeFormatting.compactCountdown(countdown)
    }
}
