import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    var body: some View {
        NavigationView {
            Group {
                if appState.cities.isEmpty {
                    VStack(spacing: 16) {
                        Text("Пока нет городов")
                            .font(.title2)
                        Text("Добавьте город во вкладке «Поиск»")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(appState.cities, id: \.id) { city in
                                CityWeatherContainer(city: city, repository: repository)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Погода")
        }
    }
}

#Preview {
    MainView(repository: WeatherRepository(client: NetworkManager(), apiKey: ""))
        .environmentObject(AppState())
}




