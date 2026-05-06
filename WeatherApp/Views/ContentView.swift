import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherService = WeatherService()

    var body: some View {
        Group {
            switch locationManager.authorizationStatus {
            case .denied, .restricted:
                LocationDeniedView()

            default:
                if weatherService.isLoading {
                    LoadingView()
                } else if let data = weatherService.weatherData {
                    MainWeatherView(
                        data: data,
                        cityName: locationManager.cityName,
                        isUpdating: weatherService.isUpdating
                    )
                } else if let error = weatherService.errorMessage {
                    errorView(message: error)
                } else {
                    LoadingView()
                }
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: locationManager.location) { newLocation in
            guard let loc = newLocation else { return }
            Task {
                await weatherService.fetchWeather(
                    lat: loc.coordinate.latitude,
                    lon: loc.coordinate.longitude
                )
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }

    private func errorView(message: String) -> some View {
        ZStack {
            AppBackground()
            VStack(spacing: 20) {
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 54))
                    .foregroundColor(.white.opacity(0.5))
                Text("Something went wrong")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.white)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                Button("Try Again") {
                    if let loc = locationManager.location {
                        Task {
                            await weatherService.fetchWeather(
                                lat: loc.coordinate.latitude,
                                lon: loc.coordinate.longitude
                            )
                        }
                    } else {
                        locationManager.requestLocation()
                    }
                }
                .padding(.horizontal, 36)
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
