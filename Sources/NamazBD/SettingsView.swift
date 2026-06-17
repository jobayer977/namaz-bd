import SwiftUI
import PrayerKit

struct SettingsView: View {
    @ObservedObject var model: AppModel

    private let districts = BangladeshDistricts.all.sorted { $0.englishName < $1.englishName }
    private let reminderOptions = [0, 5, 10, 15, 20, 30]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                section("District") {
                    Picker("District", selection: $model.districtId) {
                        ForEach(districts) { district in
                            Text("\(district.englishName) — \(district.banglaName)").tag(district.id)
                        }
                    }
                    .labelsHidden()
                }

                section("Calculation Method") {
                    Picker("Method", selection: $model.method) {
                        ForEach(CalculationMethod.allCases, id: \.self) { method in
                            Text(method.displayName).tag(method)
                        }
                    }
                    .labelsHidden()
                }

                section("Asr Juristic") {
                    Picker("Asr", selection: $model.asrJuristic) {
                        ForEach(AsrJuristic.allCases, id: \.self) { juristic in
                            Text(juristic.displayName).tag(juristic)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }

                section("Notifications") {
                    Toggle("Adhan time notifications", isOn: $model.notificationsEnabled)
                        .font(.system(size: 12))
                    if model.notificationsEnabled {
                        Picker("Early reminder", selection: $model.reminderLeadMinutes) {
                            ForEach(reminderOptions, id: \.self) { minutes in
                                Text(minutes == 0 ? "No early reminder" : "\(minutes) min before").tag(minutes)
                            }
                        }
                        .labelsHidden()
                    }
                }
            }
            .padding(14)
        }
        .frame(maxHeight: 320)
    }

    @ViewBuilder
    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .bold))
                .tracking(0.8)
                .foregroundStyle(.secondary)
            content()
        }
    }
}
