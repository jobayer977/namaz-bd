import Foundation

public struct DailyPrayerTimes: Sendable {
    public let date: Date
    public let coordinate: GeoCoordinate
    public let method: CalculationMethod
    public let asrJuristic: AsrJuristic
    public let times: [Prayer: Date]

    public func time(for prayer: Prayer) -> Date? {
        times[prayer]
    }

    public func nextPrayer(after reference: Date) -> (prayer: Prayer, time: Date)? {
        let upcoming = Prayer.dailyOrder
            .compactMap { prayer -> (Prayer, Date)? in
                guard prayer.isPrayer, let time = times[prayer], time > reference else { return nil }
                return (prayer, time)
            }
            .sorted { $0.1 < $1.1 }
        return upcoming.first
    }

    public func currentPrayer(at reference: Date) -> Prayer? {
        let passed = Prayer.dailyOrder
            .compactMap { prayer -> (Prayer, Date)? in
                guard prayer.isPrayer, let time = times[prayer], time <= reference else { return nil }
                return (prayer, time)
            }
            .sorted { $0.1 < $1.1 }
        return passed.last?.0
    }
}
