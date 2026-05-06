import Foundation

class WeatherService: ObservableObject {
    @Published var weatherData: OpenMeteoResponse?
    @Published var isLoading = false
    @Published var isUpdating = false
    @Published var errorMessage: String?

    func fetchWeather(lat: Double, lon: Double) async {
        await MainActor.run {
            if weatherData == nil { isLoading = true }
            isUpdating = true
            errorMessage = nil
        }

        let urlString = buildURL(lat: lat, lon: lon)
        guard let url = URL(string: urlString) else {
            await MainActor.run { isLoading = false; isUpdating = false }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            await MainActor.run {
                self.weatherData = response
                self.isLoading = false
                self.isUpdating = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Gagal memuat data cuaca. Periksa koneksi internet."
                self.isLoading = false
                self.isUpdating = false
            }
        }
    }

    private func buildURL(lat: Double, lon: Double) -> String {
        let base = "https://api.open-meteo.com/v1/forecast"
        let coords = "latitude=\(lat)&longitude=\(lon)"
        let current = "current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m"
        let hourly = "hourly=temperature_2m,weather_code,precipitation_probability"
        let daily = "daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,wind_speed_10m_max"
        let options = "timezone=auto&forecast_days=7&wind_speed_unit=kmh"
        return "\(base)?\(coords)&\(current)&\(hourly)&\(daily)&\(options)"
    }
}
