import Dependencies
import Foundation

protocol NewsServiceProtocol {
    func fetchTopHeadlines(for query: String, page: Int) async throws -> [ArticleDataModel]?
    func fetchEverything(for query: String, page: Int)  async throws -> [ArticleDataModel]?
    func fetchAllEverythings() async throws -> [ArticleDataModel]?
}

class NewsService: NewsServiceProtocol {

    @Dependency(\.networkClient) private var networkClient: NetworkClient
    private let jsonDecoder = JSONDecoder()
    private let pageSize = "10"


    func fetchTopHeadlines(for query: String, page: Int) async throws -> [ArticleDataModel]? {

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return nil }

        let request = HTTPSRequest(method: .get,
                                   path: "/top-headlines",
                                   queryParameters: [URLQueryItem(name: "country", value: "us"),
                                                     URLQueryItem(name: "apiKey", value: apiKey),
                                                     URLQueryItem(name: "page", value: String(page)),
                                                     URLQueryItem(name: "q", value: query),
                                                     URLQueryItem(name: "pageSize", value: pageSize)],
                                   headers: ["Accept": "application/json"])

        let data = try await networkClient.execute(request)
        let articles = try jsonDecoder.decode(NewsResponse.self, from: data).articles
        return articles

    }

    func fetchEverything(for query: String, page: Int) async throws -> [ArticleDataModel]? {

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return nil }

        let request = HTTPSRequest(method: .get,
                                   path: "/everything",
                                   queryParameters: [URLQueryItem(name: "q", value: query),
                                                     URLQueryItem(name: "apiKey", value: apiKey),
                                                     URLQueryItem(name: "page", value: String(page)),
                                                     URLQueryItem(name: "pageSize", value: pageSize)],
                                   headers: ["Accept": "application/json"])

        let data = try await networkClient.execute(request)
        let articles = try jsonDecoder.decode(NewsResponse.self, from: data).articles
        return articles

    }

    func fetchAllEverythings() async throws -> [ArticleDataModel]? {

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return nil }

        let request = HTTPSRequest(method: .get,
                                   path: "/everything",
                                   queryParameters: [URLQueryItem(name: "q", value: "dog"),
                                                     URLQueryItem(name: "apiKey", value: apiKey)],
                                   headers: ["Accept": "application/json"])

        let data = try await networkClient.execute(request)
        let articles = try jsonDecoder.decode(NewsResponse.self, from: data).articles
        return articles

    }

}

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDataModel]
}

// MARK: - Dependency Injection
struct NewsServiceKey: DependencyKey {

    static var liveValue: any NewsServiceProtocol {
        NewsService()
    }

}

extension DependencyValues {

    var newsService: any NewsServiceProtocol {
        get { self[NewsServiceKey.self] }
        set { self[NewsServiceKey.self] = newValue }
    }

}
