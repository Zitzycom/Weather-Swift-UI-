import Foundation

enum WeatherPreviewMock {
    static let currentWeather = CurrentWeatherResponse(
        coord: .init(lon: 37.62, lat: 55.75),
        weather: [
            .init(id: 800, main: "Clear", description: "clear sky", icon: "01d")
        ],
        base: "stations",
        main: .init(
            temp: 22.0,
            feels_like: 21.0,
            temp_min: 20.0,
            temp_max: 25.0,
            pressure: 1015,
            humidity: 40,
            sea_level: nil,
            grnd_level: nil
        ),
        visibility: 10000,
        wind: .init(speed: 3.5, deg: 180, gust: nil),
        rain: nil,
        clouds: .init(all: 0),
        dt: Date().timeIntervalSince1970,
        sys: .init(type: 1, id: 9020, country: "RU", sunrise: Date().addingTimeInterval(-3600*6).timeIntervalSince1970, sunset: Date().addingTimeInterval(3600*6).timeIntervalSince1970),
        timezone: 10800,
        id: 524901,
        name: "Moscow",
        cod: 200
    )

    static let forecast: ForecastResponse = {
        let now = Date()
        let one3h: TimeInterval = 3 * 3600

        func makeItem(offsetHours: Int, temp: Double, description: String, icon: String) -> ForecastItem {
            ForecastItem(
                dt: now.addingTimeInterval(Double(offsetHours) * one3h).timeIntervalSince1970,
                main: .init(temp: temp, temp_min: temp - 1, temp_max: temp + 1, pressure: 1012, humidity: 50),
                weather: [.init(id: 801, main: "Clouds", description: description, icon: icon)],
                dt_txt: ISO8601DateFormatter().string(from: now.addingTimeInterval(Double(offsetHours) * one3h))
            )
        }

        return ForecastResponse(
            cod: "200",
            message: 0,
            cnt: 5,
            list: [
                makeItem(offsetHours: 1, temp: 20.0, description: "few clouds", icon: "02d"),
                makeItem(offsetHours: 2, temp: 21.5, description: "scattered clouds", icon: "03d"),
                makeItem(offsetHours: 3, temp: 19.0, description: "broken clouds", icon: "04d"),
                makeItem(offsetHours: 4, temp: 18.0, description: "shower rain", icon: "09d"),
                makeItem(offsetHours: 5, temp: 17.5, description: "rain", icon: "10d")
            ]
        )
    }()

    enum CityPreviewMock {
        static let moscow = City(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            name: "Moscow",
            country: "RU",
            lat: 55.7558,
            lon: 37.6173,
            state: "Moscow"
        )

        static let saintPetersburg = City(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            name: "Saint Petersburg",
            country: "RU",
            lat: 59.9311,
            lon: 30.3609,
            state: "Moscow"

        )

        static let newYork = City(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            name: "New York",
            country: "US",
            lat: 40.7128,
            lon: -74.0060,
            state: "Moscow"

        )

        static let allCities = [moscow, saintPetersburg, newYork]
    }

    enum GeoCodingItemPreviewMock {
        static let moscowItem = GeoCodingItem(
            name: "Moscow",
            local_names: ["ru": "Москва", "en": "Moscow"],
            lat: 55.7558,
            lon: 37.6173,
            country: "RU",
            state: nil
        )

        static let saintPetersburgItem = GeoCodingItem(
            name: "Saint Petersburg",
            local_names: ["ru": "Санкт-Петербург", "en": "Saint Petersburg"],
            lat: 59.9311,
            lon: 30.3609,
            country: "RU",
            state: nil
        )

        static let newYorkItem = GeoCodingItem(
            name: "New York",
            local_names: ["en": "New York"],
            lat: 40.7128,
            lon: -74.0060,
            country: "US",
            state: "NY"
        )

        static let allItems = [moscowItem, saintPetersburgItem, newYorkItem]
    }
}
