import SwiftUI

struct CityWeatherContainer: View {
    let city: City
    let repository: WeatherRepositoryProtocol

    @StateObject private var viewModel: WeatherViewModel

    init(city: City, repository: WeatherRepositoryProtocol) {
        self.city = city
        self.repository = repository
        _viewModel = StateObject(wrappedValue: WeatherViewModel(repository: repository))
    }

    var body: some View {
        MainCityView(city: city, viewModel: viewModel)
            .task {
                viewModel.loadWeather(for: city)
            }
    }
}


#Preview {
    CityWeatherContainer(city: WeatherPreviewMock.CityPreviewMock.moscow, repository: WeatherRepository(client: NetworkManager(), apiKey: WeatherAPI.apiKey))
}
