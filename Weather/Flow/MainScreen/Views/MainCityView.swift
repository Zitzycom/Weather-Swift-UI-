import SwiftUI

struct MainCityView: View {
    let city: City
    @StateObject var viewModel: WeatherViewModel

    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if let current = viewModel.currentWeather {
                        CurrentWeatherView(current: current)
                    }

                    if let forecast = viewModel.forecast {
                        ForecastListView(response: forecast)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    if viewModel.isLoading {
                        ProgressView("Загрузка...")
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
            }
            .task {
                await viewModel.loadWeather(for: city, days: 5)
            }
            .refreshable {
                await viewModel.loadWeather(for: city, days: 5)
            }
        }
        .navigationTitle(city.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var backgroundView: some View {
        let main = viewModel.currentWeather?.weather.first?.main ?? "Clear"
        switch main {
        case "Clear":
            LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Clouds":
            LinearGradient(colors: [.gray, .blue.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Rain", "Drizzle":
            LinearGradient(colors: [.blue.opacity(0.5), .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Snow":
            LinearGradient(colors: [.white, .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Thunderstorm":
            LinearGradient(colors: [.black, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

#Preview {
    MainCityView(city: WeatherPreviewMock.CityPreviewMock.moscow,
                 viewModel: WeatherViewModel(
                    repository:
                        DefaultWeatherRepository(
                            client: DefaultNetworkClient(),
                            apiKey: WeatherAPI.apiKey
                        )
                 )
    )
}
