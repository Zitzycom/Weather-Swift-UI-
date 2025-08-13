import Foundation

struct CurrentWeatherResponse: Decodable {
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int?
        let grnd_level: Int?
    }

    struct Wind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }

    struct Rain: Decodable {
        let _1h: Double?

        enum CodingKeys: String, CodingKey {
            case _1h = "1h"
        }
    }

    struct Clouds: Decodable {
        let all: Int
    }

    struct Sys: Decodable {
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
