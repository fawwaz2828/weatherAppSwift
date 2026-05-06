import SwiftUI

struct MainWeatherView: View {
    let data: OpenMeteoResponse
    let cityName: String
    let isUpdating: Bool

    @State private var showForecast = false

    private var current: OpenMeteoResponse.CurrentWeatherData { data.current }
    private var isDay: Bool { current.isDay == 1 }
    private var hourly: [HourlyItem] { WeatherHelper.hourlyItems(from: data) }
    private var daily: [DailyItem] { WeatherHelper.dailyItems(from: data) }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(spacing: 0) {
                    topBar
                        .padding(.horizontal, 22)
                        .padding(.top, 6)

                    Spacer()

                    // 3D Weather Icon
                    WeatherIconView(code: current.weatherCode, size: 150, isDay: isDay)
                        .padding(.bottom, 12)

                    // Temperature
                    Text("\(Int(current.temperature2m.rounded()))°")
                        .font(.system(size: 100, weight: .thin, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)

                    // Condition label
                    Text(WeatherHelper.conditionText(for: current.weatherCode))
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white.opacity(0.65))
                        .padding(.bottom, 28)

                    // Stats row
                    statsRow
                        .padding(.horizontal, 22)

                    Spacer()

                    // Hourly strip
                    hourlySection
                        .padding(.bottom, 28)
                }
            }
            .preferredColorScheme(.dark)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showForecast) {
                ForecastView(daily: daily, cityName: cityName)
            }
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0.6))

            Spacer()

            VStack(spacing: 5) {
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.75))
                    Text(cityName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }

                HStack(spacing: 5) {
                    Circle()
                        .fill(isUpdating ? Color.yellow : Color.green)
                        .frame(width: 6, height: 6)
                    Text(isUpdating ? "Updating" : "Live")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.55))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.08))
                .cornerRadius(20)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "wind",
                value: "\(Int(current.windSpeed10m.rounded())) km/h",
                label: "Wind"
            )
            StatCard(
                icon: "drop.fill",
                value: "\(current.relativeHumidity2m)%",
                label: "Humidity"
            )
            StatCard(
                icon: "cloud.rain.fill",
                value: "\(daily.first?.precipProbabilityMax ?? 0)%",
                label: "Rain"
            )
        }
    }

    // MARK: - Hourly Section
    private var hourlySection: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Today")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Button(action: { showForecast = true }) {
                    HStack(spacing: 4) {
                        Text("7 days")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.55))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.55))
                    }
                }
            }
            .padding(.horizontal, 22)

            if hourly.isEmpty {
                Text("No hourly data available")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))
                    .frame(height: 100)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(hourly.enumerated()), id: \.element.id) { index, item in
                            HourlyCard(item: item, isSelected: index == 0)
                        }
                    }
                    .padding(.horizontal, 22)
                }
            }
        }
    }
}
