import SwiftUI
import PrayerKit

struct PrayerPanelView: View {
    @ObservedObject var model: AppModel
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            if showingSettings {
                SettingsView(model: model)
            } else {
                prayerList
            }
            Divider()
            footer
        }
        .frame(width: 320)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(model.selectedDistrict.englishName)
                        .font(.system(size: 14, weight: .bold))
                    Text(model.selectedDistrict.banglaName)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(TimeFormatting.longDate(model.now))
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            nextPrayerBanner
        }
        .padding(14)
    }

    @ViewBuilder
    private var nextPrayerBanner: some View {
        if let upcoming = model.upcoming, let countdown = model.countdownToNext {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Next: \(upcoming.prayer.englishName)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                    Text("at \(TimeFormatting.clock(upcoming.time))")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(TimeFormatting.countdown(countdown))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color.accentColor)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor.opacity(0.10)))
        }
    }

    private var prayerList: some View {
        VStack(spacing: 2) {
            ForEach(Prayer.dailyOrder) { prayer in
                if let time = model.today?.time(for: prayer) {
                    PrayerRowView(
                        prayer: prayer,
                        time: time,
                        isCurrent: model.currentPrayer == prayer,
                        isNext: model.upcoming?.prayer == prayer && prayer.isPrayer
                    )
                }
            }
        }
        .padding(8)
    }

    private var footer: some View {
        HStack {
            Button {
                showingSettings.toggle()
            } label: {
                Label(showingSettings ? "Back" : "Settings", systemImage: showingSettings ? "chevron.left" : "gearshape")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)

            Spacer()

            Text(model.method.displayName)
                .font(.system(size: 9))
                .foregroundStyle(.tertiary)
                .lineLimit(1)

            Spacer()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit", systemImage: "power")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
