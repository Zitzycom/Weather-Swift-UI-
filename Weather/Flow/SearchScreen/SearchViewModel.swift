import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [GeoCodingItem] = []
    @Published var isSearching = false
    @Published var errorText: String? = nil
    @Published var viewId = UUID()
    
    private let repository: WeatherRepositoryProtocol
    private let appState: AppState
    
    init(repository: WeatherRepositoryProtocol, appState: AppState) {
        self.repository = repository
        self.appState = appState
    }
    
    func performSearch() {
        Task { [weak self] in
            guard let self else { return }
            await self.performSearch()
        }
    }
    
    private func performSearch() async {
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
        errorText = nil
        let newCity = City(
            name: item.name,
            country: item.country,
            lat: item.lat,
            lon: item.lon,
            state: item.state
        )
        
        if appState.cities.contains(where: { Self.isDuplicate(existing: $0, new: newCity) }) {
            errorText = "Город уже добавлен."
            return
        }
        
        appState.cities.append(newCity)
        appState.selectedCityIndex = appState.cities.count - 1
    }
    
    func selectCity(at index: Int) {
        guard index >= 0, index < appState.cities.count else { return }
        appState.selectedCityIndex = index
    }
    
    func removeCity(_ city: City) {
        DispatchQueue.main.async {
            self.appState.removeCity(city)
            self.viewId = UUID()
        }
    }
    
    var savedCities: [City] {
        appState.cities
    }
    
    var selectedCityIndex: Int? {
        appState.selectedCityIndex
    }
    
    private static func isDuplicate(existing: City, new: City) -> Bool {
        let epsilon = 0.00001
        let sameCoords = abs(existing.lat - new.lat) <= epsilon &&
        abs(existing.lon - new.lon) <= epsilon
        
        let sameFullName =
        existing.name.compare(new.name, options: .caseInsensitive) == .orderedSame &&
        (existing.state ?? "").compare(new.state ?? "", options: .caseInsensitive) == .orderedSame &&
        existing.country.compare(new.country, options: .caseInsensitive) == .orderedSame
        
        return sameCoords || sameFullName
    }
}
