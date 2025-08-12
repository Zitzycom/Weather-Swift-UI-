import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var dep = Dep()
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dep)
                .environmentObject(appState)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var dep: Dep
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView {
            MainView(repository: dep.repo)
                .tabItem {
                    Label("Главный", systemImage: "cloud.sun.fill")
                }
            SearchView(repository: dep.repo, appState: appState)                .tabItem {
                    Label("Поиск", systemImage: "magnifyingglass")
                }
        }
    }
}

final class Dep: ObservableObject {
    let client: DefaultNetworkClient
    let repo: DefaultWeatherRepository

    init() {
        self.client = DefaultNetworkClient()
        self.repo = DefaultWeatherRepository(client: client, apiKey: WeatherAPI.apiKey)
    }
}

// MARK: - AppState.swift
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var cities: [City] = [] {
        didSet { storage.saveCities(cities) }
    }
    @Published var selectedCityIndex: Int? = nil

    private let storage: CityStorageServiceProtocol

    init(storage: CityStorageServiceProtocol = CityStorageService()) {
        self.storage = storage
        self.cities = storage.loadCities()
    }

    func addCity(_ geoItem: GeoCodingItem) {
        let city = City(name: geoItem.name, country: geoItem.country, lat: geoItem.lat, lon: geoItem.lon)
        if !cities.contains(where: { $0.name == city.name && $0.country == city.country }) {
            cities.append(city)
        }
    }

    func removeCity(_ city: City) {
        cities.removeAll { $0.name == city.name && $0.country == city.country }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Dep())
            .environmentObject(AppState())
    }
}
