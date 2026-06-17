import Foundation

private enum SunDirection {
    case clockwise
    case counterClockwise
}

private struct CalculatorContext {
    let julianDay: Double
    let latitude: Double
    let fajrAngle: Double
    let ishaAngle: Double
    let asrShadowFactor: Double
}

public struct PrayerTimeRequest: Sendable {
    public let date: Date
    public let coordinate: GeoCoordinate
    public let method: CalculationMethod
    public let asrJuristic: AsrJuristic
    public let timeZone: TimeZone

    public init(
        date: Date,
        coordinate: GeoCoordinate,
        method: CalculationMethod,
        asrJuristic: AsrJuristic,
        timeZone: TimeZone
    ) {
        self.date = date
        self.coordinate = coordinate
        self.method = method
        self.asrJuristic = asrJuristic
        self.timeZone = timeZone
    }
}

public enum PrayerTimeCalculator {
    private static let riseSetAngle = 0.833
    private static let refinementPasses = 3

    public static func calculate(request: PrayerTimeRequest) -> DailyPrayerTimes {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = request.timeZone
        let components = calendar.dateComponents([.year, .month, .day], from: request.date)
        let year = components.year ?? 2026
        let month = components.month ?? 1
        let day = components.day ?? 1

        let baseJulian = AstronomicalMath.julianDay(year: year, month: month, day: day)
            - request.coordinate.longitude / (15 * 24)

        let context = CalculatorContext(
            julianDay: baseJulian,
            latitude: request.coordinate.latitude,
            fajrAngle: request.method.fajrAngle,
            ishaAngle: request.method.ishaAngle,
            asrShadowFactor: request.asrJuristic.shadowFactor
        )

        var hours = initialGuesses()
        for _ in 0..<refinementPasses {
            hours = refine(hours: hours, context: context)
        }

        let adjustment = Double(request.timeZone.secondsFromGMT(for: request.date)) / 3600
            - request.coordinate.longitude / 15

        let midnight = calendar.startOfDay(for: request.date)
        var resolved: [Prayer: Date] = [:]
        for (prayer, hour) in hours {
            let adjusted = hour + adjustment
            resolved[prayer] = midnight.addingTimeInterval(adjusted * 3600)
        }

        return DailyPrayerTimes(
            date: request.date,
            coordinate: request.coordinate,
            method: request.method,
            asrJuristic: request.asrJuristic,
            times: resolved
        )
    }

    private static func initialGuesses() -> [Prayer: Double] {
        [.fajr: 5, .sunrise: 6, .dhuhr: 12, .asr: 13, .maghrib: 18, .isha: 18]
    }

    private static func refine(hours: [Prayer: Double], context: CalculatorContext) -> [Prayer: Double] {
        var result: [Prayer: Double] = [:]
        result[.fajr] = sunAngleTime(angle: context.fajrAngle, dayPortion: dayPortion(hours[.fajr]), direction: .counterClockwise, context: context)
        result[.sunrise] = sunAngleTime(angle: riseSetAngle, dayPortion: dayPortion(hours[.sunrise]), direction: .counterClockwise, context: context)
        result[.dhuhr] = midDay(dayPortion: dayPortion(hours[.dhuhr]), context: context)
        result[.asr] = asrTime(shadowFactor: context.asrShadowFactor, dayPortion: dayPortion(hours[.asr]), context: context)
        result[.maghrib] = sunAngleTime(angle: riseSetAngle, dayPortion: dayPortion(hours[.maghrib]), direction: .clockwise, context: context)
        result[.isha] = sunAngleTime(angle: context.ishaAngle, dayPortion: dayPortion(hours[.isha]), direction: .clockwise, context: context)
        return result
    }

    private static func dayPortion(_ hour: Double?) -> Double {
        (hour ?? 0) / 24
    }

    private static func midDay(dayPortion: Double, context: CalculatorContext) -> Double {
        let position = AstronomicalMath.solarPosition(julianDay: context.julianDay + dayPortion)
        return AstronomicalMath.normalizeHour(12 - position.equationOfTime)
    }

    private static func sunAngleTime(angle: Double, dayPortion: Double, direction: SunDirection, context: CalculatorContext) -> Double {
        let position = AstronomicalMath.solarPosition(julianDay: context.julianDay + dayPortion)
        let noon = midDay(dayPortion: dayPortion, context: context)
        let numerator = -AstronomicalMath.sinDegrees(angle)
            - AstronomicalMath.sinDegrees(position.declination) * AstronomicalMath.sinDegrees(context.latitude)
        let denominator = AstronomicalMath.cosDegrees(position.declination) * AstronomicalMath.cosDegrees(context.latitude)
        let hourAngle = (1.0 / 15.0) * AstronomicalMath.arccosDegrees(numerator / denominator)
        return direction == .counterClockwise ? noon - hourAngle : noon + hourAngle
    }

    private static func asrTime(shadowFactor: Double, dayPortion: Double, context: CalculatorContext) -> Double {
        let position = AstronomicalMath.solarPosition(julianDay: context.julianDay + dayPortion)
        let angle = -AstronomicalMath.arccotDegrees(
            shadowFactor + AstronomicalMath.tanDegrees(abs(context.latitude - position.declination))
        )
        return sunAngleTime(angle: angle, dayPortion: dayPortion, direction: .clockwise, context: context)
    }
}
