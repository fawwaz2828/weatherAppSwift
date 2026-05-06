import Foundation

struct WeatherHelper {

    static func symbolName(for code: Int, isDay: Bool = true) -> String {
        switch code {
        case 0:          return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 1:          return isDay ? "sun.max.fill" : "moon.fill"
        case 2:          return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 3:          return "cloud.fill"
        case 45, 48:     return "cloud.fog.fill"
        case 51, 53, 55: return "cloud.drizzle.fill"
        case 56, 57:     return "cloud.sleet.fill"
        case 61, 63:     return "cloud.rain.fill"
        case 65:         return "cloud.heavyrain.fill"
        case 66, 67:     return "cloud.sleet.fill"
        case 71, 73, 75: return "cloud.snow.fill"
        case 77:         return "cloud.hail.fill"
        case 80, 81:     return "cloud.rain.fill"
        case 82:         return "cloud.heavyrain.fill"
        case 85, 86:     return "cloud.snow.fill"
        case 95:         return "cloud.bolt.rain.fill"
        case 96, 99:     return "cloud.bolt.rain.fill"
        default:         return "cloud.fill"
        }
    }

    static func conditionText(for code: Int) -> String {
        switch code {
        case 0:          return "Clear Sky"
        case 1:          return "Mainly Clear"
        case 2:          return "Partly Cloudy"
        case 3:          return "Overcast"
        case 45, 48:     return "Foggy"
        case 51, 53:     return "Drizzle"
        case 55:         return "Heavy Drizzle"
        case 56, 57:     return "Freezing Drizzle"
        case 61, 63:     return "Rain"
        case 65:         return "Heavy Rain"
        case 66, 67:     return "Freezing Rain"
        case 71, 73:     return "Snowfall"
        case 75:         return "Heavy Snow"
        case 77:         return "Snow Grains"
        case 80, 81:     return "Rain Showers"
        case 82:         return "Heavy Showers"
        case 85, 86:     return "Snow Showers"
        case 95:         return "Thunderstorm"
        case 96, 99:     return "Thunderstorm"
        default:         return "Unknown"
        }
    }

    static func hourlyItems(from response: OpenMeteoResponse) -> [HourlyItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let tz = TimeZone(identifier: response.timezone) {
            formatter.timeZone = tz
        }

        let now = Date()
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!

        var items: [HourlyItem] = []
        let times = response.hourly.time
        for i in times.indices {
            guard let date = formatter.date(from: times[i]) else { continue }
            guard date >= now && date < tomorrow else { continue }
            guard i < response.hourly.temperature2m.count,
                  i < response.hourly.weatherCode.count,
                  i < response.hourly.precipitationProbability.count else { continue }

            items.append(HourlyItem(
                date: date,
                temp: response.hourly.temperature2m[i],
                weatherCode: response.hourly.weatherCode[i],
                precipProbability: response.hourly.precipitationProbability[i]
            ))
        }

        if items.isEmpty {
            for i in times.indices {
                guard let date = formatter.date(from: times[i]) else { continue }
                guard date >= now else { continue }
                guard i < response.hourly.temperature2m.count else { continue }
                items.append(HourlyItem(
                    date: date,
                    temp: response.hourly.temperature2m[i],
                    weatherCode: response.hourly.weatherCode[i],
                    precipProbability: response.hourly.precipitationProbability[i]
                ))
                if items.count == 6 { break }
            }
        }

        return Array(items.prefix(6))
    }

    static func dailyItems(from response: OpenMeteoResponse) -> [DailyItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let tz = TimeZone(identifier: response.timezone) {
            formatter.timeZone = tz
        }

        let daily = response.daily
        return daily.time.indices.compactMap { i in
            guard let date = formatter.date(from: daily.time[i]),
                  i < daily.temperature2mMax.count,
                  i < daily.temperature2mMin.count,
                  i < daily.weatherCode.count else { return nil }

            return DailyItem(
                date: date,
                tempMax: daily.temperature2mMax[i],
                tempMin: daily.temperature2mMin[i],
                weatherCode: daily.weatherCode[i],
                precipProbabilityMax: i < daily.precipitationProbabilityMax.count ? daily.precipitationProbabilityMax[i] : 0,
                windSpeedMax: i < daily.windSpeed10mMax.count ? daily.windSpeed10mMax[i] : 0
            )
        }
    }

    static func hourString(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }

    static func dayName(from date: Date, short: Bool = true) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInTomorrow(date) { return short ? "Tmr" : "Tomorrow" }
        let f = DateFormatter()
        f.dateFormat = short ? "EEE" : "EEEE"
        return f.string(from: date)
    }
}
