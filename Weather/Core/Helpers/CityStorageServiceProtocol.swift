import Foundation

protocol CityStorageServiceProtocol {
    func saveCities(_ cities: [City])
    func loadCities() -> [City]
}

final class CityStorageService: CityStorageServiceProtocol {
    private let key = "savedCities"
    
    func saveCities(_ cities: [City]) {
        if let data = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadCities() -> [City] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let cities = try? JSONDecoder().decode([City].self, from: data) else {
            return []
        }
        return cities
    }
}
