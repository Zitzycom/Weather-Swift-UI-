import SwiftUI

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var forecast: ForecastResponse?
    @Published var currentWeather: CurrentWeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func loadWeather(for city: City) {
        Task { [weak self] in
            guard let self else { return }
            await loadWeather(for: city)
        }
    }

    private func loadWeather(for city: City) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            forecast = try await repository.getForecast(lat: city.lat, lon: city.lon)
            currentWeather = try await repository.getCurrentWeather(lat: city.lat, lon: city.lon)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
