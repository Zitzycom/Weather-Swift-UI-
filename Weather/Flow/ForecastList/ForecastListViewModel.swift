import SwiftUI

@MainActor
final class ForecastListViewModel: ObservableObject {
    struct HourlyForecast: Identifiable {
        let id: TimeInterval
        let dateTimeText: String
        let temp: Int
        let description: String
        let iconURL: URL?
    }
    
    @Published var items: [HourlyForecast] = [] 
    
    init(response: ForecastResponse) {
        self.items = response.list.prefix(40).map { item in
            HourlyForecast(
                id: item.dt,
                dateTimeText: item.dt_txt,
                temp: Int(item.main.temp),
                description: item.weather.first?.description.capitalized ?? "",
                iconURL: item.weather.first.flatMap {
                    URL(string: "https://openweathermap.org/img/wn/\($0.icon)@2x.png")
                }
            )
        }
    }
}
