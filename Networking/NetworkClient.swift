import Dependencies
import Foundation

class NetworkClient {

    func execute(_ httpsRequest: HTTPSRequest) async throws -> Data {

        guard let urlRequest = URLRequest(from: httpsRequest) else {
            throw HTTPError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.noResponse
        }

        if (400...499).contains(httpResponse.statusCode) {
            if httpResponse.statusCode == 429 {
                print("You have exceeded the request amount per day")
            }
            throw HTTPError.clientError(statusCode: httpResponse.statusCode)
        }

        if (500...599).contains(httpResponse.statusCode) {
            throw HTTPError.serverError(statusCode: httpResponse.statusCode)
        }

        return data
    }

}

// MARK: - NetworkClient
extension NetworkClient: DependencyKey {
    static var liveValue: NetworkClient = {
        return NetworkClient()
    }()

}

extension DependencyValues {

    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }

}
