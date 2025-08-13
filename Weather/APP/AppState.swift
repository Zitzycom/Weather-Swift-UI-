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
        let city = City(name: geoItem.name, country: geoItem.country, lat: geoItem.lat, lon: geoItem.lon, state: geoItem.state)
        if !cities.contains(where: { $0.name == city.name && $0.country == city.country }) {
            cities.append(city)
        }
    }

    func removeCity(_ city: City) {
        cities.removeAll { $0.id == city.id }
    }
}
