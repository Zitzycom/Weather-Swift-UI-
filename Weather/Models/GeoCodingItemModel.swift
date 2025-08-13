import Foundation

struct GeoCodingItem: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let local_names: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
