import Foundation

struct SolarPosition {
    let declination: Double
    let equationOfTime: Double
}

enum AstronomicalMath {
    static func degreesToRadians(_ degrees: Double) -> Double {
        degrees * .pi / 180
    }

    static func radiansToDegrees(_ radians: Double) -> Double {
        radians * 180 / .pi
    }

    static func sinDegrees(_ degrees: Double) -> Double {
        sin(degreesToRadians(degrees))
    }

    static func cosDegrees(_ degrees: Double) -> Double {
        cos(degreesToRadians(degrees))
    }

    static func tanDegrees(_ degrees: Double) -> Double {
        tan(degreesToRadians(degrees))
    }

    static func arcsinDegrees(_ value: Double) -> Double {
        radiansToDegrees(asin(value))
    }

    static func arccosDegrees(_ value: Double) -> Double {
        radiansToDegrees(acos(value))
    }

    static func arccotDegrees(_ value: Double) -> Double {
        radiansToDegrees(atan2(1, value))
    }

    static func arctan2Degrees(_ y: Double, _ x: Double) -> Double {
        radiansToDegrees(atan2(y, x))
    }

    static func normalizeAngle(_ angle: Double) -> Double {
        wrap(angle, range: 360)
    }

    static func normalizeHour(_ hour: Double) -> Double {
        wrap(hour, range: 24)
    }

    private static func wrap(_ value: Double, range: Double) -> Double {
        var result = value - range * floor(value / range)
        if result < 0 { result += range }
        return result
    }

    static func julianDay(year: Int, month: Int, day: Int) -> Double {
        var adjustedYear = year
        var adjustedMonth = month
        if adjustedMonth <= 2 {
            adjustedYear -= 1
            adjustedMonth += 12
        }
        let a = floor(Double(adjustedYear) / 100)
        let b = 2 - a + floor(a / 4)
        return floor(365.25 * Double(adjustedYear + 4716))
            + floor(30.6001 * Double(adjustedMonth + 1))
            + Double(day) + b - 1524.5
    }

    static func solarPosition(julianDay: Double) -> SolarPosition {
        let daysSinceEpoch = julianDay - 2451545.0
        let meanAnomaly = normalizeAngle(357.529 + 0.98560028 * daysSinceEpoch)
        let meanLongitude = normalizeAngle(280.459 + 0.98564736 * daysSinceEpoch)
        let eclipticLongitude = normalizeAngle(
            meanLongitude + 1.915 * sinDegrees(meanAnomaly) + 0.020 * sinDegrees(2 * meanAnomaly)
        )
        let obliquity = 23.439 - 0.00000036 * daysSinceEpoch
        let declination = arcsinDegrees(sinDegrees(obliquity) * sinDegrees(eclipticLongitude))
        let rightAscension = arctan2Degrees(
            cosDegrees(obliquity) * sinDegrees(eclipticLongitude),
            cosDegrees(eclipticLongitude)
        ) / 15
        let equationOfTime = meanLongitude / 15 - normalizeHour(rightAscension)
        return SolarPosition(declination: declination, equationOfTime: equationOfTime)
    }
}
