import Foundation

public final class NetworkClient {

    public func execute(_ httpRequest: HTTPRequest) async throws -> Data {

        guard let urlRequest = URLRequest(from: httpRequest) else {
            throw HTTPError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.noResponse
        }

        if (400...499).contains(httpResponse.statusCode) {
            throw HTTPError.clientError(statusCode: httpResponse.statusCode)
        }

        if (500...599).contains(httpResponse.statusCode) {
            throw HTTPError.serverError(statusCode: httpResponse.statusCode)
        }

        return data
    }

}
