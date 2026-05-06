import Foundation

struct HourlyItem: Identifiable {
    let id = UUID()
    let date: Date
    let temp: Double
    let weatherCode: Int
    let precipProbability: Int
}

struct DailyItem: Identifiable {
    let id = UUID()
    let date: Date
    let tempMax: Double
    let tempMin: Double
    let weatherCode: Int
    let precipProbabilityMax: Int
    let windSpeedMax: Double
}
