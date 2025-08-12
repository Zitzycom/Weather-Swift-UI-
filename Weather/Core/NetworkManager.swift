import Foundation

protocol NetworkClient {
    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

struct DefaultNetworkClient: NetworkClient {
    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        guard let url = endpoint.url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        if let body = endpoint.body {
            request.httpBody = body
        }
        if let headers = endpoint.headers {
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NetworkError.serverError(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

struct Endpoint {
    let path: String
    let method: String
    var queryItems: [URLQueryItem]?
    var body: Data?
    var headers: [String: String]?

    var url: URL? {
        var components = URLComponents(string: WeatherAPI.baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}


