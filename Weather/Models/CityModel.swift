import Foundation

struct City: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let state: String?

    init(id: UUID = UUID(), name: String, country: String, lat: Double, lon: Double, state: String?) {
        self.id = id
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
        self.state = state
    }

    var displayName: String {
        "\(name), \(country)"
    }
}
