import Foundation

struct ForecastResponse: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
}

struct ForecastItem: Decodable, Identifiable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: [WeatherInfo]
    let dt_txt: String

    var id: TimeInterval { dt }

    struct MainInfo: Decodable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct WeatherInfo: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
