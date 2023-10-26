import Foundation

public enum HTTPError: Error {

    case invalidURL
    case noResponse
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknown
    case decodingError
    case encodingError

}

