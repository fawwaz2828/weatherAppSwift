import SwiftUI

struct DailyRow: View {
    let item: DailyItem

    var body: some View {
        HStack(spacing: 14) {
            Text(WeatherHelper.dayName(from: item.date))
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.65))
                .frame(width: 38, alignment: .leading)

            WeatherIconView(code: item.weatherCode, size: 22)
                .frame(width: 30)

            Text(WeatherHelper.conditionText(for: item.weatherCode))
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Text("+\(Int(item.tempMax.rounded()))°")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Text("+\(Int(item.tempMin.rounded()))°")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.45))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 13)
    }
}
