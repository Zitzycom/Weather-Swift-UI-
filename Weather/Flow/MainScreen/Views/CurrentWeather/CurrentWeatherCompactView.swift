import SwiftUI

struct CurrentWeatherCompactView: View {
    let current: CurrentWeatherResponse
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(current.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Text(current.weather.first?.description.capitalized ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
            }
            Spacer()
            Text("\(Int(current.main.temp))°C")
                .font(.system(size: 40, weight: .thin))
                .foregroundColor(.white)
            if let icon = current.weather.first?.icon {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
                    .frame(width: 50, height: 50)
                    .padding(.leading, 8)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    CurrentWeatherCompactView(current: WeatherPreviewMock.currentWeather)
}
