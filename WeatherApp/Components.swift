import SwiftUI

// MARK: - App Background
struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(hex: "080818"),
                Color(hex: "0f0f28"),
                Color(hex: "131330")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Weather Icon with Glow
struct WeatherIconView: View {
    let code: Int
    let size: CGFloat
    var isDay: Bool = true

    private var symbol: String { WeatherHelper.symbolName(for: code, isDay: isDay) }

    var body: some View {
        ZStack {
            // Glow layer
            Image(systemName: symbol)
                .font(.system(size: size))
                .symbolRenderingMode(.multicolor)
                .blur(radius: size * 0.18)
                .opacity(0.55)

            // Main icon
            Image(systemName: symbol)
                .font(.system(size: size))
                .symbolRenderingMode(.multicolor)
        }
        .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 14)
    }
}

// MARK: - Stat Card (main screen)
struct StatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.65))
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.07))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Mini Stat Card (forecast view)
struct MiniStatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.6))
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.06))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Hourly Forecast Card
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

// MARK: - Daily Forecast Row
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

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 18) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 60))
                    .symbolRenderingMode(.multicolor)
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.3)
                Text("Getting your weather...")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.55))
            }
        }
    }
}

// MARK: - Location Denied View
struct LocationDeniedView: View {
    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 20) {
                Image(systemName: "location.slash.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.5))
                Text("Location Access Needed")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)
                Text("Please allow location access in\nSettings > Privacy > Location Services")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Color.blue.opacity(0.7))
                .cornerRadius(14)
                .foregroundColor(.white)
                .font(.subheadline.weight(.semibold))
            }
            .padding()
        }
    }
}
