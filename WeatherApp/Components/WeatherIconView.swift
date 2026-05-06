import SwiftUI

struct WeatherIconView: View {
    let code: Int
    let size: CGFloat
    var isDay: Bool = true

    private var symbol: String { WeatherHelper.symbolName(for: code, isDay: isDay) }

    var body: some View {
        ZStack {
            Image(systemName: symbol)
                .font(.system(size: size))
                .symbolRenderingMode(.multicolor)
                .blur(radius: size * 0.18)
                .opacity(0.55)

            Image(systemName: symbol)
                .font(.system(size: size))
                .symbolRenderingMode(.multicolor)
        }
        .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 14)
    }
}
