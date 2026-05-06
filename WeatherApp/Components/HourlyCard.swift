import SwiftUI

struct HourlyCard: View {
    let item: HourlyItem
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            Text(WeatherHelper.hourString(from: item.date))
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .white : .white.opacity(0.55))

            WeatherIconView(code: item.weatherCode, size: 26)

            Text("\(Int(item.temp.rounded()))°")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(width: 70)
        .padding(.vertical, 14)
        .background(
            Group {
                if isSelected {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.55), Color.blue.opacity(0.25)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else {
                    LinearGradient(
                        colors: [Color.white.opacity(0.08), Color.white.opacity(0.03)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isSelected ? Color.blue.opacity(0.5) : Color.white.opacity(0.1),
                    lineWidth: 1
                )
        )
    }
}
