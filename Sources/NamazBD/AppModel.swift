import Foundation
import Combine
import PrayerKit

@MainActor
final class AppModel: ObservableObject {
    @Published var districtId: String {
        didSet { persist(districtId, forKey: Keys.district); recompute() }
    }
    @Published var method: CalculationMethod {
        didSet { persist(method.rawValue, forKey: Keys.method); recompute() }
    }
    @Published var asrJuristic: AsrJuristic {
        didSet { persist(asrJuristic.rawValue, forKey: Keys.asr); recompute() }
    }
    @Published var notificationsEnabled: Bool {
        didSet { persist(notificationsEnabled, forKey: Keys.notifications); refreshNotifications() }
    }
    @Published var reminderLeadMinutes: Int {
        didSet { persist(reminderLeadMinutes, forKey: Keys.reminderLead); refreshNotifications() }
    }

    @Published private(set) var now: Date = Date()
    @Published private(set) var today: DailyPrayerTimes?
    @Published private(set) var tomorrow: DailyPrayerTimes?

    private let defaults = UserDefaults.standard
    private let notifications = NotificationScheduler()
    private var timer: AnyCancellable?

    static let timeZone = TimeZone(identifier: "Asia/Dhaka") ?? .current

    init() {
        districtId = defaults.string(forKey: Keys.district) ?? BangladeshDistricts.dhaka.id
        method = CalculationMethod(rawValue: defaults.string(forKey: Keys.method) ?? "") ?? .bangladeshDefault
        asrJuristic = AsrJuristic(rawValue: defaults.string(forKey: Keys.asr) ?? "") ?? .hanafi
        notificationsEnabled = defaults.object(forKey: Keys.notifications) as? Bool ?? true
        reminderLeadMinutes = defaults.object(forKey: Keys.reminderLead) as? Int ?? 10
        recompute()
        startTimer()
    }

    var selectedDistrict: District {
        BangladeshDistricts.find(id: districtId) ?? BangladeshDistricts.dhaka
    }

    var upcoming: (prayer: Prayer, time: Date)? {
        if let next = today?.nextPrayer(after: now) {
            return next
        }
        if let fajrTomorrow = tomorrow?.time(for: .fajr) {
            return (.fajr, fajrTomorrow)
        }
        return nil
    }

    var currentPrayer: Prayer? {
        today?.currentPrayer(at: now)
    }

    var countdownToNext: TimeInterval? {
        guard let target = upcoming?.time else { return nil }
        return max(0, target.timeIntervalSince(now))
    }

    func recompute() {
        let calendar = makeCalendar()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? startOfToday

        today = PrayerTimeCalculator.calculate(request: makeRequest(for: startOfToday))
        tomorrow = PrayerTimeCalculator.calculate(request: makeRequest(for: startOfTomorrow))
        refreshNotifications()
    }

    private func makeRequest(for date: Date) -> PrayerTimeRequest {
        PrayerTimeRequest(
            date: date,
            coordinate: selectedDistrict.coordinate,
            method: method,
            asrJuristic: asrJuristic,
            timeZone: Self.timeZone
        )
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Self.timeZone
        return calendar
    }

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                guard let self else { return }
                self.now = date
                self.rolloverIfNeeded()
            }
    }

    private func rolloverIfNeeded() {
        guard let today else { return }
        let calendar = makeCalendar()
        guard !calendar.isDate(today.date, inSameDayAs: now) else { return }
        recompute()
    }

    private func refreshNotifications() {
        guard let today, let tomorrow else { return }
        notifications.reschedule(payload: NotificationSchedulePayload(
            enabled: notificationsEnabled,
            reminderLeadMinutes: reminderLeadMinutes,
            today: today,
            tomorrow: tomorrow,
            now: now
        ))
    }

    private func persist(_ value: Any, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    private enum Keys {
        static let district = "namazbd.district"
        static let method = "namazbd.method"
        static let asr = "namazbd.asr"
        static let notifications = "namazbd.notifications"
        static let reminderLead = "namazbd.reminderLead"
    }
}
