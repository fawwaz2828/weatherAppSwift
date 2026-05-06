import SwiftUI

struct ForecastView: View {
    let daily: [DailyItem]
    let cityName: String

    @Environment(\.dismiss) private var dismiss

    private var tomorrow: DailyItem? {
        daily.first(where: { Calendar.current.isDateInTomorrow($0.date) })
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                navBar
                    .padding(.horizontal, 22)
                    .padding(.top, 6)
                    .padding(.bottom, 10)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if let tmr = tomorrow {
                            tomorrowCard(tmr)
                                .padding(.horizontal, 22)
                        }

                        dailyList
                            .padding(.horizontal, 22)
                            .padding(.bottom, 28)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
    }

    // MARK: - Navigation Bar
    private var navBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.75))
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.09))
                    .cornerRadius(12)
            }

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(.white.opacity(0.65))
                Text("7 days")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(width: 40)
        }
    }

    // MARK: - Tomorrow Featured Card
    private func tomorrowCard(_ item: DailyItem) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Tomorrow")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.55))

            HStack(alignment: .center, spacing: 20) {
                WeatherIconView(code: item.weatherCode, size: 80)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("\(Int(item.tempMax.rounded()))")
                            .font(.system(size: 64, weight: .thin, design: .rounded))
                            .foregroundColor(.white)
                        Text("/\(Int(item.tempMin.rounded()))°")
                            .font(.system(size: 28, weight: .thin))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    Text(WeatherHelper.conditionText(for: item.weatherCode))
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.55))
                }
            }

            HStack(spacing: 10) {
                MiniStatCard(
                    icon: "wind",
                    value: "\(Int(item.windSpeedMax.rounded())) km/h",
                    label: "Wind"
                )
                MiniStatCard(
                    icon: "drop.fill",
                    value: "\(item.precipProbabilityMax)%",
                    label: "Humidity"
                )
                MiniStatCard(
                    icon: "cloud.rain.fill",
                    value: "\(item.precipProbabilityMax)%",
                    label: "Rain"
                )
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.07))
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Daily List
    private var dailyList: some View {
        VStack(spacing: 0) {
            ForEach(Array(daily.enumerated()), id: \.element.id) { index, item in
                DailyRow(item: item)
                if index < daily.count - 1 {
                    Rectangle()
                        .fill(Color.white.opacity(0.07))
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                }
            }
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
