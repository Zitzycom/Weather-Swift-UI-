import Foundation

protocol WeatherRepositoryProtocol {
    func searchCity(named: String, limit: Int) async throws -> [GeoCodingItem]
    func getCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherResponse
    func getForecast(lat: Double, lon: Double) async throws -> ForecastResponse
}

struct WeatherRepository: WeatherRepositoryProtocol {
    private let client: NetworkManagerProtocol
    private let apiKey: String

    init(client: NetworkManagerProtocol, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func searchCity(named: String, limit: Int = 5) async throws -> [GeoCodingItem] {
        let endpoint = Endpoint(
            path: "/geo/1.0/direct",
            method: "GET",
            queryItems: [
                .init(name: "q", value: named),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "appid", value: apiKey)
            ]
        )
        return try await client.request(endpoint, as: [GeoCodingItem].self)
    }

    func getCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherResponse {
        let endpoint = Endpoint(
            path: "/data/2.5/weather",
            method: "GET",
            queryItems: [
                .init(name: "lat", value: "\(lat)"),
                .init(name: "lon", value: "\(lon)"),
                .init(name: "units", value: WeatherAPI.units),
                .init(name: "lang", value: WeatherAPI.lang),
                .init(name: "appid", value: apiKey)
            ]
        )
        return try await client.request(endpoint, as: CurrentWeatherResponse.self)
    }

    func getForecast(lat: Double, lon: Double) async throws -> ForecastResponse {
        let endpoint = Endpoint(
            path: "/data/2.5/forecast",
            method: "GET",
            queryItems: [
                .init(name: "lat", value: "\(lat)"),
                .init(name: "lon", value: "\(lon)"),
                .init(name: "units", value: WeatherAPI.units),
                .init(name: "lang", value: WeatherAPI.lang),
                .init(name: "appid", value: apiKey)
            ]
        )
        return try await client.request(endpoint, as: ForecastResponse.self)
    }
}
