import Foundation

struct City: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let country: String
    let lat: Double
    let lon: Double

    init(id: UUID = UUID(), name: String, country: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
    }

    var displayName: String {
        "\(name), \(country)"
    }
}

// MARK: - Geocoding API Response Item
struct GeoCodingItem: Codable {
    let name: String
    let local_names: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
















// CurrentWeatherResponse.swift
import Foundation

struct CurrentWeatherResponse: Codable {
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int?
        let grnd_level: Int?
    }
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    struct Rain: Codable {
        let _1h: Double?

        enum CodingKeys: String, CodingKey {
            case _1h = "1h"
        }
    }
    struct Clouds: Codable {
        let all: Int
    }
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let country: String
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }

    let coord: Coord
    let weather: [Weather]
    let base: String?
    let main: Main
    let visibility: Int?
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}







struct ForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
}

struct ForecastItem: Codable, Identifiable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: [WeatherInfo]
    let dt_txt: String

    var id: TimeInterval { dt } // для ForEach

    struct MainInfo: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct WeatherInfo: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}





