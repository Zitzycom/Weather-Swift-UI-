import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: WeatherViewModel

    init(repository: WeatherRepository) {
        _viewModel = StateObject(wrappedValue: WeatherViewModel(repository: repository))
    }

    var body: some View {
        NavigationView {
            Group {
                if let idx = appState.selectedCityIndex, idx < appState.cities.count {
                    let city = appState.cities[idx]
                    MainCityView(city: city, viewModel: viewModel)
                        .task {
                            await viewModel.loadWeather(for: city)
                        }
                } else {
                    VStack(spacing: 16) {
                        Text("Пока нет городов")
                            .font(.title2)
                        Text("Добавьте город во вкладке «Поиск»")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .navigationTitle("Погода")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !appState.cities.isEmpty {
                        Menu {
                            ForEach(appState.cities.indices, id: \.self) { i in
                                let c = appState.cities[i]
                                Button(c.displayName) {
                                    appState.selectedCityIndex = i
                                }
                            }
                        } label: {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainView(repository: DefaultWeatherRepository(client: DefaultNetworkClient(), apiKey: "")  )
        .environmentObject(AppState())
}
