import SwiftUI

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
