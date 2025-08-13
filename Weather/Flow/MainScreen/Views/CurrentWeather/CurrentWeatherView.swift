import SwiftUI

struct CurrentWeatherView: View {
    let current: CurrentWeatherResponse

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(current.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Text(current.weather.first?.description.capitalized ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }
                Spacer()
                if let icon = current.weather.first?.icon {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
                        .frame(width: 80, height: 80)
                }
            }

            Text("\(Int(current.main.temp))°C")
                .font(.system(size: 52, weight: .thin))
                .foregroundColor(.white)

            HStack(spacing: 16) {
                WeatherInfoRow(icon: "thermometer", label: "Ощущается", value: "\(Int(current.main.feels_like))°")
                WeatherInfoRow(icon: "humidity", label: "Влажность", value: "\(current.main.humidity)%")
                WeatherInfoRow(icon: "gauge", label: "Давление", value: "\(current.main.pressure) hPa")
            }

            HStack(spacing: 16) {
                WeatherInfoRow(icon: "wind", label: "Ветер", value: "\(String(format: "%.1f", current.wind.speed)) м/с")
                WeatherInfoRow(icon: "cloud", label: "Облака", value: "\(current.clouds.all)%")
            }

            HStack(spacing: 16) {
                WeatherInfoRow(icon: "sunrise", label: "Восход", value: timeString(from: current.sys.sunrise, tz: current.timezone))
                WeatherInfoRow(icon: "sunset", label: "Закат", value: timeString(from: current.sys.sunset, tz: current.timezone))
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func timeString(from timestamp: TimeInterval, tz: Int) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: tz)
        return formatter.string(from: date)
    }
}

#Preview {
    CurrentWeatherView(current: WeatherPreviewMock.currentWeather)
}
