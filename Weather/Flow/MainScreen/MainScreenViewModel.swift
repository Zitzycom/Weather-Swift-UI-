import SwiftUI

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var forecast: ForecastResponse?
    @Published var currentWeather: CurrentWeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func loadWeather(for city: City, days: Int = 7) async {
        isLoading = true
        errorMessage = nil
        do {
            forecast = try await repository.getForecast(lat: city.lat, lon: city.lon, days: days)
            currentWeather = try await repository.getCurrentWeather(lat: city.lat, lon: city.lon)
            print(currentWeather)
            print("-------------------------------------------------------------------------------------------------------------------------------------------------------------")
            print(forecast)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}




