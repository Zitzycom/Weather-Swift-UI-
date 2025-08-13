import Foundation

final class AppDependency: ObservableObject {
    let client: NetworkManager
    let repo: WeatherRepository

    init() {
        self.client = NetworkManager()
        self.repo = WeatherRepository(client: client, apiKey: WeatherAPI.apiKey)
    }
}
