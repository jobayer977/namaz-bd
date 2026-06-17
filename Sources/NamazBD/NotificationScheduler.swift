import Foundation
import UserNotifications
import PrayerKit

struct NotificationSchedulePayload {
    let enabled: Bool
    let reminderLeadMinutes: Int
    let today: DailyPrayerTimes
    let tomorrow: DailyPrayerTimes
    let now: Date
}

final class NotificationScheduler {
    private let center = UNUserNotificationCenter.current()
    private var authorizationRequested = false

    func requestAuthorizationIfNeeded() {
        guard !authorizationRequested else { return }
        authorizationRequested = true
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func reschedule(payload: NotificationSchedulePayload) {
        center.removeAllPendingNotificationRequests()
        guard payload.enabled else { return }
        requestAuthorizationIfNeeded()

        let entries = upcomingEntries(payload: payload)
        for entry in entries {
            scheduleEntry(prayer: entry.prayer, fireDate: entry.time, isReminder: false)
            if payload.reminderLeadMinutes > 0 {
                let reminderDate = entry.time.addingTimeInterval(Double(-payload.reminderLeadMinutes) * 60)
                if reminderDate > payload.now {
                    scheduleEntry(prayer: entry.prayer, fireDate: reminderDate, isReminder: true, leadMinutes: payload.reminderLeadMinutes)
                }
            }
        }
    }

    private func upcomingEntries(payload: NotificationSchedulePayload) -> [(prayer: Prayer, time: Date)] {
        var entries: [(Prayer, Date)] = []
        for prayer in Prayer.dailyOrder where prayer.isPrayer {
            if let time = payload.today.time(for: prayer), time > payload.now {
                entries.append((prayer, time))
            }
        }
        if let fajr = payload.tomorrow.time(for: .fajr) {
            entries.append((.fajr, fajr))
        }
        return entries
    }

    private func scheduleEntry(prayer: Prayer, fireDate: Date, isReminder: Bool, leadMinutes: Int = 0) {
        let content = UNMutableNotificationContent()
        if isReminder {
            content.title = "\(prayer.englishName) in \(leadMinutes) min"
            content.body = "\(prayer.englishName) (\(prayer.banglaName)) approaches. Prepare for salah."
        } else {
            content.title = "\(prayer.englishName) — \(prayer.banglaName)"
            content.body = "It is time for \(prayer.englishName)."
        }
        content.sound = .default

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = AppModelTimeZoneProvider.timeZone
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let identifier = "namazbd.\(prayer.rawValue).\(isReminder ? "reminder" : "entry").\(Int(fireDate.timeIntervalSince1970))"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)
    }
}

enum AppModelTimeZoneProvider {
    static let timeZone = TimeZone(identifier: "Asia/Dhaka") ?? .current
}
