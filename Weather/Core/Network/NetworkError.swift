import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError(Int)
    case decodingError(Error)
    case unknown(Error)
    case missingAPIKey
}
