import Foundation

public struct HTTPSRequest {

    public var method: HTTPMethod
    public var baseURL: URL
    public var path: String
    public var queryParameters: [URLQueryItem]
    public var headers: [String: String]
    public var body: Data?

    var url: URL {
        var fullURL = baseURL.appending(path: path)
        if !queryParameters.isEmpty {
            fullURL = fullURL.appending(queryItems: queryParameters)
        }
        return fullURL
    }

    public init(
        method: HTTPMethod,
        path: String,
        queryParameters: [URLQueryItem] = [],
        headers: [String: String],
        body: Data? = nil
    ) {
        self.method = method
        if let infoDict = Bundle.main.infoDictionary, let baseURL = infoDict["base_url"] as? String {
            self.baseURL = URL(string: baseURL)!
        } else {
            self.baseURL = URL(string: "https://newsapi.org/v2")!
        }
        self.path = path
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
    }

}

// MARK: - HTTPRequest to URLRequest
extension URLRequest {

    init?(from request: HTTPSRequest) {
        self.init(url: request.url)
        httpMethod = request.method.rawValue
        httpBody = request.body
        request.headers.forEach { (key, value) in
            setValue(value, forHTTPHeaderField: key)
        }
    }

}

public enum HTTPMethod: String {

    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"

}
