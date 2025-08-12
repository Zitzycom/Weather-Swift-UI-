import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [GeoCodingItem] = []
    @Published var isSearching = false
    @Published var errorText: String? = nil
    
    private let repository: WeatherRepository
    private let appState: AppState
    
    
    init(repository: WeatherRepository, appState: AppState) {
        self.repository = repository
        self.appState = appState
    }
    
    func performSearch() async {
        errorText = nil
        results = []
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        isSearching = true
        do {
            let found = try await repository.searchCity(named: trimmed, limit: 7)
            results = found
        } catch {
            errorText = String(describing: error)
        }
        isSearching = false
    }
    
    func addCity(from item: GeoCodingItem) {
        let city = City(name: item.name, country: item.country, lat: item.lat, lon: item.lon)
        appState.cities.append(city)
    }
    
    func selectCity(at index: Int) {
        appState.selectedCityIndex = index
    }
    
    func removeCity(at offsets: IndexSet) {
        appState.cities.remove(atOffsets: offsets)
    }
    
    var savedCities: [City] {
        appState.cities
    }
    
    var selectedCityIndex: Int? {
        appState.selectedCityIndex
    }
}
